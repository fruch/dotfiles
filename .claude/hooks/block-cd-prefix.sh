#!/usr/bin/env bash
# PreToolUse hook (Bash): reject commands that use `cd` as a command word:
# at the start, or after && || ; | ( or a newline.
# `cd X && cmd` compounds trigger permission prompts and auto-mode denials;
# exit 2 blocks the call and feeds stderr back to Claude so it retries without cd.
# ponytail: regex on the raw string, so `cd` inside a quoted string after ; or && also trips it.
cmd=$(jq -r '.tool_input.command // empty')
re=$'(^|[;&|(\n])[[:space:]]*cd([[:space:]]|$)'
if [[ "$cmd" =~ $re ]]; then
    echo "Blocked: don't use cd in Bash commands (not at the start, not after && or ;). The session cwd is already the right checkout; use absolute paths or 'git -C <dir>' / tool flags like 'make -C', 'npm --prefix', 'uv --directory'." >&2
    exit 2
fi
exit 0
