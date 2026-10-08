# Even G2 表示テスト
検証ID: G2-IPHONETERM-CODEX-20261009-01

状態: 実コミットによる自動更新テスト

## 修正内容
欠損行を除去した後のインデックスを振り直すよう変更しました。

## コード
```python
import pandas as pd

df = pd.read_csv("data.csv")
df = df.dropna().reset_index(drop=True)
print(df.head())
```

## 実行方法
`python main.py`

## テスト結果
初期サンプル。GitHubから自動取得・表示できることを確認してください。
