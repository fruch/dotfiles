@RTK.md

## Shell commands (avoid permission prompts)

- The session cwd is already the right checkout or worktree. Never start a Bash command with `cd`. Use `git -C <abs path>` and absolute paths for other checkouts.
- One logical command per Bash call. No `cd ... && git ...` and no `;`-chains of unrelated steps.
- For loops, pipelines over several commands, inline Python or heredocs, write a script to the scratchpad (or use an existing repo helper in `scripts/`) and run that script.
- Pass literal text only: no `$(...)` and no unquoted `$VAR` lists. Compute values in a separate call first, then inline the result.
- Never wait with `sleep N; check`. Use `run_in_background` for a command that ends, or Monitor with an until-loop for CI and long jobs.
- `pkill`/`pgrep` exit 1 when nothing matches - append `|| true` when "no process" is fine.
- After a compaction or resume, or after a file changes through Bash (sed, git checkout, rebase, a script), Read it again before using Edit/Write on it. Edit by absolute path inside the current worktree.
- After editing a hook script under `~/.claude/hooks/` (or any script a hook runs), run `bash -n <script>` before finishing. A syntax error in a PreToolUse hook makes every matching Bash call fail.
- When the concurrent subagent limit is hit, wait for running agents to finish and queue the rest - never retry immediately.

## Ownership and evidence

- Don't merge PRs in repos I don't own; leave merging to the owners.
- Before a rebase or force-push, check whether another agent-manager session works on the same branch; if so, leave it to that session.
- Push my own branches yourself - don't hand the push back to me.
- Back bug reports and root-cause claims with a local reproduction or real data, not a guess.

## GitHub and Python gotchas

- `gh pr diff` takes no path filter. Fetch the ref and run `git diff base...head -- <path>`.
- Before `gh pr create --head <fork>:<branch>`, push the branch to the fork and confirm with `git ls-remote` (otherwise "Head sha can't be blank").
- Push temporary rebase or scratch branches to my fork, never to the upstream repo.
- If `gh pr edit --add-reviewer` fails with a permissions error, don't retry. Tell me the reviewer must be requested manually.
- `python -I` ignores the cwd and `PYTHON*` variables. Use it only for scripts that read downloaded data. For scripts that import repo code, run `uv run --directory <worktree> python -m ...` or pytest.

## Jenkins MCP (jenkins.scylladb.com)

- Use full folder job paths (`folder/sub/job-name`).
- `query_items` and `run_groovy_script` time out on wide scans: give `query_items` a narrow pattern, and for SCT trigger schedules read `configurations/triggers/*.yaml` in the repo instead of scanning Jenkins.
- `get_build_console_output` patterns: no inline regex flags like `(?i)` - they fail with "global flags not at the start".
- Before `build_item`, read `get_item_parameters` and pass only parameters the job defines (400 Bad Request otherwise).
- `get_build_parameters` / `get_item` sometimes 404 on folder jobs; fall back to `get_build` on a known build number.

## Skills

- `fix-backport-conflicts` (SCT) is user-invoked only (`disable-model-invocation`). When it fits, ask me to run `/fix-backport-conflicts` instead of trying the Skill tool.

## scylla-cluster-tests: ask before

- Prove changes locally first (unit tests, `hydra` commands, a local script against the real API). Don't trigger Jenkins or staging jobs unless I ask.
- Never create new Jenkins jobs. Reuse existing ones and pass the fork/branch as parameters.
- Fix review findings and related bugs as separate commits in the same PR. Don't open Jira issues for them.
- Don't open PRs to scylladb/scylla-cluster-tests without my review. When asked to plan PRs for internal work, target scylla-qa-internal.
- With stacked PRs, don't start the next PR until the earlier ones are reviewed.
- Before running tests, show the test plan and the exact commands as an artifact.
