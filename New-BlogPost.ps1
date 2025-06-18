param (
    [Parameter(Mandatory=$true)]
    [string]$Title,
    
    [Parameter(Mandatory=$false)]
    [string]$Description = "",
    
    [Parameter(Mandatory=$false)]
    [string]$Author = "Kaieda",
    
    [Parameter(Mandatory=$false)]
    [string]$Category = "programming",
    
    [Parameter(Mandatory=$false)]
    [string[]]$Tags = @("tech"),
    
    [Parameter(Mandatory=$false)]
    [string]$CoverImg = ""
)

# 現在の日時をJST（GMT+9）で取得
$now = [DateTime]::UtcNow.AddHours(9)
$publishDate = $now.ToString("yyyy-MM-ddTHH:mm:ss+09:00")
$unpublishDate = $now.AddYears(5).ToString("yyyy-MM-ddTHH:mm:ss+09:00")

# ファイルパスを構築
$yearStr = $now.ToString("yyyy")
$monthStr = $now.ToString("MM")
$dayStr = $now.ToString("dd")
$dirPath = "$yearStr/$monthStr/$dayStr"

# ディレクトリが存在しない場合は作成
if (-not (Test-Path -Path $dirPath)) {
    New-Item -ItemType Directory -Path $dirPath -Force | Out-Null
    # attachmentsディレクトリも作成
    New-Item -ItemType Directory -Path "$dirPath/attachments" -Force | Out-Null
}

# タグを適切な形式に変換
$tagsStr = if ($Tags.Count -gt 0) {
    "['" + ($Tags -join "', '") + "']"
} else {
    "[]"
}

# MDファイルのコンテンツを生成
$content = @"
---
title: '$Title'
description: '$Description'
publishdate: '$publishDate'
unpublishdate: '$unpublishDate'
author: '$Author'
category: '$Category'
tags: $tagsStr
CoverImg: '$CoverImg'
---

# $Title（魅力的でSEOを意識したものか？）

## 導入（読者を引き込む）

- 読者の共感を誘う質問や問題提起
- 記事を読むメリットや得られる情報を提示

> 導入例：
> 「最近、『○○で困っている』という方が増えています。この記事では○○を解決するための具体的な方法を3つご紹介します。」

## 本文（明確な見出しで整理）

### 1. 見出し1（問題の提示やポイント紹介）

- 具体的な問題の提示
- 実際の状況や問題点を明確化する

### 2. 見出し2（解決策や事例の提示）

- 具体的な解決策や方法を示す
- 実際の成功事例やデータ、図表を入れると効果的

### 3. 見出し3（さらに深掘り・追加情報）

- 応用的な情報や知識、裏技、よくある質問への回答
- 読者に役立つ追加的なヒントやアドバイス

## まとめ（行動を促す）

- 記事のポイントを簡潔に再整理
- 次の行動や関連するリンクを提示（関連記事、サービス紹介など）

> まとめ例：
> 「今回は○○を改善する方法を3つご紹介しました。ぜひ実践して、成果を体感してください。○○に興味がある方は以下の関連記事もどうぞ。」

## おすすめ関連記事（任意）

- 記事のテーマに関連した自分の他記事や外部リンクを提示
- 内部リンクはSEO的にも有効

## CTA（行動喚起）セクション（任意）

- メルマガ登録、サービスへの誘導、SNSシェアのお願いなど、具体的な行動を促す

"@

# index.mdファイルを作成
$filePath = "$dirPath/index.md"
Set-Content -Path $filePath -Value $content -Encoding UTF8

Write-Host "ブログ記事が作成されました: $filePath"
Write-Host "タイトル: $Title"
Write-Host "公開日: $publishDate"
Write-Host "カテゴリ: $Category"
Write-Host "タグ: $tagsStr"
Start-Process -WindowStyle Hidden code .\$folderName\$date\index.md


# VS Code で、対象のフォルダを開く
# Invoke-Item .\$folderName\$date\

# Path: WCreateDailyReport.ps1
