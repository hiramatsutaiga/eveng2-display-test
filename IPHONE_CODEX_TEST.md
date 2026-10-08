# iPhoneだけでCodexを動かす検証

この手順は、Codexアプリ／Web版の環境一覧が取得できない場合でも、GitHub Codespacesのブラウザ上で**Codex CLI本体**を動かせるかを検証するものです。iPhone版Codexアプリ自体の修復ではありません。

1. GitHubでこのブランチ `test/iphone-codex-codespaces` を選び、**Code → Codespaces → Create codespace** で開きます。ブラウザ版のエディタが起動し、`.devcontainer/devcontainer.json` によりCodex CLIが自動インストールされます。
2. エディタのターミナルで `codex login --device-auth` を実行します。表示されたURLと一時コードを使ってChatGPTアカウントでログインします。事前にChatGPTの**設定 → セキュリティ**からデバイスコード認証を有効にする必要がある場合があります。認証情報は誰にも送らず、GitHubにコミットしないでください。
3. `codex login status` でChatGPTログインを確認し、`codex` を起動します。
4. Codexに「`G2_OUTPUT.md` の検証IDのみ `G2-IPHONETERM-CODEX-20261009-01` に変更し、変更結果を示してください。その他のファイルは変更しないでください」と指示します。
5. ターミナルで内容を確認し、変更をGitHubに送信します（`git add G2_OUTPUT.md && git commit -m 'test: iPhone Codex output' && git push`）。このブランチのPRを`main`へマージするまでは、`main`を監視するEven G2シミュレーターには反映されません。

* 料金: 個人用GitHubアカウントのCodespacesには月間無料枠があります。超過すると利用停止または設定次第で請求される可能性があるため、GitHubの使用量・支出設定を確認してください。
* Codexの認証: ChatGPTアカウントでのサインインなら別途OpenAI APIキーを必要としません。ChatGPTのプラン利用枠は適用されます。
* PCとの接続は不要ですが、CodexはiPhone端末内ではなくGitHubのクラウドコンピューター上で実行されます。
