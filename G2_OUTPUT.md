# Even G2 表示テスト

状態: 初回コミット

## 修正内容
CSVデータの欠損行を除去する処理を追加しました。

## コード
```python
import pandas as pd

df = pd.read_csv("data.csv")
df = df.dropna()
print(df.head())
```

## 実行方法
`python main.py`

## テスト結果
初期サンプル。GitHubから自動取得・表示できることを確認してください。
