---
name: merge-prs
description: >-
  Batch approve and rebase-merge GitHub PRs by range. Use when asked to
  merge PRs, merge backports, or merge a range of pull requests.
  Supports --yolo mode for auto-approve + admin bypass.
---

# Merge PRs

Batch approve and rebase-merge a range of GitHub PRs.

## Usage

Run the script at `~/bin/merge-prs.sh`:

```bash
# Normal mode: shows PRs, asks confirmation, rebase-merges
merge-prs.sh 14177-14181

# Yolo mode: auto-approve + admin merge (bypass branch protection)
merge-prs.sh --yolo 14177-14181

# Single PR
merge-prs.sh --yolo 14200
```

## When the user asks to merge PRs

1. Parse the PR numbers from the user's request (e.g., "merge 14177-14181" or "merge PRs 14177 to 14181")
2. Run: `~/bin/merge-prs.sh [--yolo] <start>-<end>`
3. If the user says "yolo" or asks to bypass checks, use `--yolo`
4. Report the results
