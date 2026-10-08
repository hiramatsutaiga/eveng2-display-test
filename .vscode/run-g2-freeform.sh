#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

request="${1:-}"
if [[ -z "${request//[[:space:]]/}" ]]; then
  echo "ERROR: Codexへの指示が空です。"
  exit 2
fi
if [[ "$(git branch --show-current)" != "test/iphone-codex-codespaces" ]]; then
  echo "ERROR: テスト用Codespacesブランチで実行してください。"
  exit 3
fi
if [[ -n "$(git status --porcelain -- G2_OUTPUT.md)" ]]; then
  echo "ERROR: G2_OUTPUT.mdに未保存の変更があります。上書きを避けるため中止します。"
  exit 4
fi

if ! codex login status; then
  echo "ChatGPTへのログインを開始します。"
  codex login --device-auth
  codex login status
fi

echo "Codexに依頼を送ります。出力先は G2_OUTPUT.md です。"
codex exec --sandbox danger-full-access \
  "You are preparing the CURRENT answer to appear on Even G2 smart glasses. User request in Japanese: ${request}
Edit ONLY the existing G2_OUTPUT.md in this working directory.
Completely replace stale demonstration or test text with a concise, actionable answer tailored to the request, in Japanese.
Use this Markdown structure:
# [brief title]
## 修正内容
[Clear explanation of what to do or what you changed. Never claim an unperformed test succeeded.]
## コード
[One Markdown fenced code block containing relevant complete, usable code or commands when applicable]
## 修正理由
[one to three brief sentences]
Focus on readable short lines and code suitable for glasses.
Never include passwords, authentication codes, tokens, or private information.
Do not edit any other file. Do not run any git commands. Do not change settings, tasks, or scripts.
If you cannot meet the user's request, explain the limitation in the Markdown rather than inventing results."

if [[ ! -s G2_OUTPUT.md ]]; then
  echo "ERROR: G2_OUTPUT.mdがありません、または空です。GitHubへ送信しません。"
  exit 5
fi
changed="$(git diff --name-only)"
if [[ "$changed" != "G2_OUTPUT.md" ]]; then
  echo "ERROR: 変更ファイルが想定外です: $changed"
  echo "GitHubへ送信しません。"
  exit 6
fi
git diff --check

# Publish ONLY the glasses output on top of the latest remote main.
# Git worktree keeps all Codespaces-only setup files out of main.
git fetch origin main
temp_parent="$(mktemp -d)"
display_worktree="$temp_parent/display-main"
worktree_added=0
cleanup() {
  if [[ "$worktree_added" == 1 ]]; then
    git worktree remove --force "$display_worktree" >/dev/null 2>&1 || true
  fi
  rm -rf "$temp_parent"
}
trap cleanup EXIT
git worktree add --detach "$display_worktree" origin/main
worktree_added=1
cp G2_OUTPUT.md "$display_worktree/G2_OUTPUT.md"
if [[ -z "$(git -C "$display_worktree" status --porcelain -- G2_OUTPUT.md)" ]]; then
  echo "ERROR: mainに対して表示内容の変更がありません。"
  exit 7
fi
git -C "$display_worktree" add -- G2_OUTPUT.md
git -C "$display_worktree" -c user.name="iPhone Codex G2" \
  -c user.email="codex-g2-display@users.noreply.github.com" \
  commit -m "display: publish iPhone Codex response"
git -C "$display_worktree" push origin HEAD:refs/heads/main
git restore -- G2_OUTPUT.md
echo "SUCCESS: Codexの回答をGitHub main/G2_OUTPUT.mdに公開しました。"
