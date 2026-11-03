---
name: handling-pr-reviews
description: Full PR review-response cycle - fetch review comments, triage fix vs reply-only, apply fixes, squash follow-ups into logical commits (never fixup commits), force-push safely around concurrent sessions, reply to every thread, restack dependent PRs. Use when asked to "go over review comments", "address the review", "reply to each comment", or "squash logically" on a GitHub PR.
---

# Handling PR reviews: fix → squash logically → push → reply

The deliverable of a review round is four things, in order: fixes pushed, history that
reads as logical commits (no fixups), a reply on **every** thread, and dependent PRs
restacked. Do not stop after the push.

## 1. Fetch what's new

```bash
# top-level comments since the last push (replies excluded)
gh api repos/<org>/<repo>/pulls/<N>/comments --paginate \
  --jq '.[] | select(.created_at > "<last-push-ts>") | select(.in_reply_to_id == null)
        | {id, user: .user.login, path, line, body}'
# review summaries carry SUPPRESSED bot comments — read those too
gh api repos/<org>/<repo>/pulls/<N>/reviews --jq '.[] | {user:.user.login, state, body}'
```
Check every PR in the stack, not just the one under discussion.

## 2. Triage

- **Maintainer comments are rulings**; bot comments are suggestions. When a bot re-raises
  something the maintainer already ruled on, it's reply-only — cite the ruling.
- Classes: (a) fix here, (b) reply-only with reasoning, (c) split to another PR/repo,
  (d) genuine bug found — sometimes worth its own first-in-stack commit.
- Verify every bot claim in code before acting; bots are right often enough to check and
  wrong often enough to never auto-apply.

## 3. Fix, then squash logically — the rebuild technique

Never leave `fixup`/`TEMP`/"address review" commits. Each follow-up change belongs inside
the logical commit that introduced the code. Redistribution that survives refactors
(e.g. a later commit split a file the earlier commit created):

```bash
git commit -m "TEMP"                # snapshot everything, including new fixes
git branch final-ref HEAD           # the target tree
git checkout -B rebuild <last-good-commit>
git cherry-pick <logical-commit-A> -n
git checkout final-ref -- <paths that logically belong to A>
git commit --no-verify -C <logical-commit-A>
# ... repeat per logical commit ...
git diff final-ref rebuild --name-only   # MUST be empty (or only intended exclusions)
```
The final tree-identity diff is the whole safety argument — never skip it.

**Guard rails (each learned the hard way):**
- `git add -A` on a dirty worktree sweeps unrelated litter (stray deletions, another
  task's edits) into your commit. Check `git status` FIRST; the tree-identity diff
  catches what slipped through.
- Never `git stash pop` after a `stash push` that may have created nothing (clean tree):
  it pops someone else's stash. Check `git stash list` before and after; if you pop a
  foreign stash, push it right back with its original description.

## 4. Push safely around concurrent sessions

`--force-with-lease` only protects against tips your local tracking ref hasn't seen — a
fetch done anywhere in the repo (any worktree) updates it and silently re-arms the lease.
Before any force-push:

```bash
git fetch <remote> <branch>
git log --oneline <remote>/<branch> -3     # anything you don't recognize?
```
If the remote moved: diff your rewrite against the foreign tip — if it's your content
rebased/reworked, rebase onto its base and verify `git diff <foreign-tip> HEAD` shows
only your intended changes; if it has novel commits, incorporate them, never clobber.
If the foreign tip is CHANGING between commands, another session is actively pushing —
back off that branch entirely, align local to remote, and report the race.

## 5. Reply to every thread — after pushing

One reply per top-level comment, via:
```bash
gh api repos/<org>/<repo>/pulls/<N>/comments/<comment-id>/replies -f body="..."
```
- Fixed: say what changed and where (commit/file), not just "done".
- Rejected: say why, citing the maintainer ruling or the code evidence.
- Then re-request the bot review:
  `gh api repos/<org>/<repo>/pulls/<N>/requested_reviewers -f 'reviewers[]=copilot-pull-request-reviewer[bot]'`

## 6. Restack dependents

After rewriting a stack-base branch, dependent branches must be rebased
(`git rebase --onto <new-tip> <old-tip> <dependent>`) and force-pushed with the same
safety checks. Prefer the repo's stack tooling (e.g. the SCT `stack-sync` skill /
`gh stack sync`) when all stack branches are checked out in ONE worktree — gh-stack
cannot span branches held by different worktrees; fall back to manual rebase then.

## Project-specific notes (SCT)

- Bugs/gaps in external components (minicloud, etc.) go to Jira QATOOLS with the right
  component — not GitHub issues.
- Commits must pass commitlint (`type(scope): subject` + body); run hook-sensitive
  commits with `.venv/bin` on PATH.
- PRs target `upstream` (scylladb/*); stacked branches live on `upstream` too.
