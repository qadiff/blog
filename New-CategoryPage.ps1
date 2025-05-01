param (
    [Parameter(Mandatory=$true)]
    [string]$CategoryName,
    
    [Parameter(Mandatory=$false)]
    [string]$Description = "",
    
    [Parameter(Mandatory=$false)]
    [string]$Image = "",
    
    [Parameter(Mandatory=$false)]
    [string]$Color = "#3B82F6"
)

# カテゴリ名から適切なスラグを生成
$categorySlug = $CategoryName.ToLower() -replace '\s+', '-'
$dirPath = "categories"

# ディレクトリが存在しない場合は作成
if (-not (Test-Path -Path $dirPath)) {
    New-Item -ItemType Directory -Path $dirPath -Force | Out-Null
}

# 説明がない場合はデフォルトの説明を設定
if ([string]::IsNullOrEmpty($Description)) {
    $Description = "$CategoryName カテゴリの記事をまとめたページです。"
}


# MDファイルのコンテンツを生成
$content = @"
---
title: '$CategoryName'
description: '$Description'
image: '$Image'
color: '$Color'
---

## $CategoryName カテゴリについて

このカテゴリでは、$CategoryName に関するすべての記事を集めています。
$Description

### 主なトピック

- トピック1の説明
- トピック2の説明
- トピック3の説明

### このカテゴリを選ぶ理由

$CategoryName は、[カテゴリの重要性や特徴について説明]。
当サイトでは、$CategoryName に関する最新の情報と深い洞察を提供することを目指しています。

定期的にチェックして、$CategoryName の最新記事をお見逃しなく。
"@

# カテゴリファイルを作成
$filePath = "$dirPath/$categorySlug.md"
Set-Content -Path $filePath -Value $content -Encoding UTF8

Write-Host "カテゴリページが作成されました: $filePath"
Write-Host "カテゴリ名: $CategoryName"
Write-Host "説明: $Description"
Write-Host "画像パス: $Image"
Write-Host "カラー: $Color"