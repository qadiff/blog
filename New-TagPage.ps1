param (
    [Parameter(Mandatory=$true)]
    [string]$TagName,
    
    [Parameter(Mandatory=$false)]
    [string]$Description = ""
)

# タグ名から適切なスラグを生成
$tagSlug = $TagName.ToLower() -replace '\s+', '-'
$dirPath = "tags"

# ディレクトリが存在しない場合は作成
if (-not (Test-Path -Path $dirPath)) {
    New-Item -ItemType Directory -Path $dirPath -Force | Out-Null
}

# 説明がない場合はデフォルトの説明を設定
if ([string]::IsNullOrEmpty($Description)) {
    $Description = "$TagName に関連した記事のコレクションです。"
}

# MDファイルのコンテンツを生成
$content = @"
---
title: '$TagName'
description: '$Description'
---

## $TagName タグについて

このタグでは、$TagName に関連する記事を集めています。このトピックに興味がある方はこのページをブックマークしておくと便利です。

### 主なトピック

- トピック1
- トピック2
- トピック3

定期的にチェックして、$TagName に関する最新情報をお見逃しなく。
"@

# タグファイルを作成
$filePath = "$dirPath/$tagSlug.md"
Set-Content -Path $filePath -Value $content -Encoding UTF8

Write-Host "タグページが作成されました: $filePath"
Write-Host "タグ名: $TagName"
Write-Host "説明: $Description"