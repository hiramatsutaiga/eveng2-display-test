# CSVの欠損行を除去

## 修正内容
pandasでCSVを読み込み、
欠損値を含む行を削除して保存します。
事前に `pip install pandas` を実行し、
以下をCSVと同じフォルダで実行します。

## コード
```python
import pandas as pd

# 入力ファイル名を指定
df = pd.read_csv("data.csv")

# 1列でも欠損がある行を削除
clean = df.dropna()

# 別ファイルへ保存（行番号なし）
clean.to_csv("clean.csv", index=False)
```

## 修正理由
`read_csv` は空欄などを欠損値として扱い、
`dropna` はその行を削除します。
元のCSVを残すため、別名で保存します。
