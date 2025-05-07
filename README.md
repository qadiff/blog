# Blog

Qadiff blog.

## How to create

必ずブランチを切ってから、記事を作成しましょう。

## 記事の作成例

### 基本的な記事の作成

```sh
.\New-BlogPost.ps1 -Title "Astroでブログを作る方法"
```

### より詳細な情報を指定した記事の作成

```sh
.\New-BlogPost.ps1 -Title "React Hooksの実践ガイド" `
                  -Description "ReactのHooksを使った状態管理の実践的なアプローチを解説します" `
                  -Author "yamada" `
                  -Category "frontend" `
                  -Tags @("React", "JavaScript", "Hooks", "フロントエンド") `
                  -CoverImg "/images/custom/react-hooks-banner.jpg"
```

## タグページの作成例

### 基本的なタグページの作成

```sh
.\New-TagPage.ps1 -TagName "JavaScript"
```

### 説明付きのタグページの作成

```sh
.\New-TagPage.ps1 -TagName "Web Performance" `
                 -Description "ウェブパフォーマンスに関する最適化テクニックやベストプラクティスを紹介する記事のコレクションです。"
```

## カテゴリページの作成例

### 基本的なカテゴリページの作成

```sh
.\New-CategoryPage.ps1 -CategoryName "チュートリアル"
```

### 詳細情報付きのカテゴリページの作成

```sh
.\New-CategoryPage.ps1 -CategoryName "フロントエンド開発" `
                      -Description "モダンなフロントエンド開発に関する記事をまとめたカテゴリです。" `
                      -Image "/images/custom/frontend-banner.jpg" `
                      -Color "#EC4899"
```

## 運用

リモートで削除したブランチを、ローカルでも削除する： `./Delete-Branches.bat`


## そのうち拡張したいところ

1. 検索機能
