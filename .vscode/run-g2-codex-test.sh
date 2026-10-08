#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
expected_branch="test/iphone-codex-codespaces"
current_branch="$(git branch --show-current)"
if [ "$current_branch" != "$expected_branch" ]; then
  echo "ERROR: expected branch $expected_branch but found $current_branch"
  exit 2
fi
if ! codex login status; then
  echo "ChatGPT sign-in required. Start device-code login now."
  codex login --device-auth
  codex login status
fi
echo "Starting Codex CLI. No prompt copy/paste is required."
codex exec --sandbox workspace-write "In G2_OUTPUT.md, change ONLY the value of the existing line that begins with '検証ID:' to 'G2-IPHONETERM-CODEX-20261009-01'. Keep all other lines, whitespace, and files exactly as they are. Do not perform git operations. After editing, report the changed line."
if ! grep -qx '検証ID: G2-IPHONETERM-CODEX-20261009-01' G2_OUTPUT.md; then
  echo "ERROR: Codex did not make the expected change; not pushing."
  exit 4
fi
changed_files="$(git diff --name-only)"
if [ "$changed_files" != "G2_OUTPUT.md" ]; then
  echo "ERROR: unexpected changed files: $changed_files; not pushing."
  exit 5
fi
git diff --check
git add -- G2_OUTPUT.md
git -c user.name="Codex G2 verification" -c user.email="codex-g2-verification@users.noreply.github.com" commit -m "test: update G2 output via iPhone Codespaces Codex"
git push origin HEAD:refs/heads/test/iphone-codex-codespaces
echo "SUCCESS: Codex updated G2_OUTPUT.md and pushed to GitHub TEST branch; main is unchanged."
