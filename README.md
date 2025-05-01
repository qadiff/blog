# Blog

Qadiff blog.

## How to create

必ずブランチを切ってから、記事を作成しましょう。

### Create Archives

```sh
# 2025年4月の News アーカイブだけ生成
$ContentType = "news"
$TargetYear  = "2025"
$TargetMonth = "04"
./Generate-NewsArchives.ps1
```

## 運用

リモートで削除したブランチを、ローカルでも削除する： `./Delete-Branches.bat`


## そのうち拡張したいところ

1. 検索機能
2. タグクラウド
