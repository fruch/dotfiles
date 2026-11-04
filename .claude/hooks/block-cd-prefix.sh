#!/usr/bin/env bash
# PreToolUse hook (Bash): reject commands that start with `cd`.
# `cd X && cmd` compounds trigger permission prompts and auto-mode denials;
# exit 2 blocks the call and feeds stderr back to Claude so it retries without cd.
cmd=$(jq -r '.tool_input.command // empty')
if [[ "$cmd" =~ ^[[:space:]]*cd([[:space:]]|$) ]]; then
    echo "Blocked: don't start Bash commands with cd. The session cwd is already the right checkout; use absolute paths or 'git -C <dir>' / tool flags like 'make -C', 'npm --prefix', 'uv --directory'." >&2
    exit 2
fi
exit 0
