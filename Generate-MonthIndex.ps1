#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Generate a monthly index (index.md) in each YYYY/MM folder.

.DESCRIPTION
    Directory example (news)
    src/
      external/
        news/
          2025/
            04/
              22/
                index.md  ← 記事本体
            04/
              index.md    ← ★このスクリプトが生成
#>

# ======================= 設定セクション =========================
$ContentType  = "blog"        # "news" か "blog" に書き換えて使用
$TargetYear   = ""            # 例 "2025" / "" なら全年
$TargetMonth  = ""            # 例 "04"   / "" なら全月（2桁必須）
# ===============================================================

# 見出し用ラベル
$ContentTitle = if ($ContentType -eq "news") { "News" } else { "Blog" }

# スクリプトのルートを基準にリポジトリルートを取得
$ScriptRoot  = Split-Path -Parent $MyInvocation.MyCommand.Path
$RootDir     = (Get-Item $ScriptRoot).Parent.FullName
$ContentPath = Join-Path $RootDir "$ContentType"
if (-not (Test-Path $ContentPath)) {
    Write-Error "Content path '$ContentPath' not found."
    exit 1
}

# 月番号配列 "01"～"12"
$MonthNumbers = 1..12 | ForEach-Object { $_.ToString("00") }

#################################################################
# Markdown のフロントマター＋本文を分離して返す
function Parse-Markdown {
    param([string]$FilePath)

    $raw = Get-Content $FilePath -Raw
    $fm  = @{}
    $body = ""

    if ($raw -match "(?s)^---\s*(.*?)\s*---\s*(.*)$") {
        $fmText, $body = $Matches[1], $Matches[2]
        foreach ($ln in ($fmText -split "`n")) {
            if ($ln -match "^\s*([^:]+):\s*(.+)\s*$") {
                $k,$v = $Matches[1].Trim(),$Matches[2].Trim()
                if ($v -eq "true")  { $v = $true }
                if ($v -eq "false") { $v = $false }
                $fm[$k] = $v
            }
        }
    }
    return @{ FrontMatter = $fm; Content = $body }
}

# 記事本文から簡易抜粋を生成
function Get-ArticleExcerpt {
    param([string]$Content,[int]$MaxLength=150)

    if ([string]::IsNullOrEmpty($Content)) { return "" }
    $x = $Content
    $x = $x -replace "#+\s.+", ""                   # 見出し除去
    $x = $x -replace "!\[.*?\]\(.+?\)", ""          # 画像除去
    $x = $x -replace "\[(.+?)\]\(.+?\)", '$1'       # リンクテキスト化
    $x = $x -replace "\s+", " "
    $x = $x.Trim()
    if ($x.Length -gt $MaxLength) { $x = $x.Substring(0,$MaxLength) + "..." }
    return $x
}

# 指定月フォルダ内の記事を取得
function Find-ArticlesInMonth {
    param([string]$MonthDir)

    $arts = @()
    $dayDirs = Get-ChildItem $MonthDir -Directory | Where-Object { $_.Name -match '^\d{2}$' }
    foreach ($d in $dayDirs) {
        $idx = Join-Path $d.FullName "index.md"
        if (Test-Path $idx) {
            $parsed    = Parse-Markdown $idx
            $fm        = $parsed.FrontMatter
            $body      = $parsed.Content

            $parts     = $d.FullName -split [regex]::Escape([io.path]::DirectorySeparatorChar)
            $year,$mon,$day = $parts[-3],$parts[-2],$parts[-1]

            $dt = $null
            if ($fm.date) {
                try { $dt = [datetime]::Parse($fm.date) }
                catch { $dt = Get-Date -Year $year -Month $mon -Day $day }
            } else {
                $dt = Get-Date -Year $year -Month $mon -Day $day
            }
            $arts += [pscustomobject]@{
                title   = $fm.title
                date    = $dt
                day     = [int]$day
                slug    = "$year/$mon/$day"
                excerpt = Get-ArticleExcerpt $body
            }
        }
    }
    return $arts | Sort-Object date -Descending
}

# 月インデックスを組み立て
function Generate-MonthIndexContent {
    param(
        [string]$Year,
        [string]$Month,
        [array] $Articles
    )
    $front = @"
---
lang: ja
title: $ContentTitle for $Year-$Month
description: $ContentTitle articles published in $Year-$Month
layout: month-index
---

"@

    $featured = $Articles | Select-Object -First ([math]::Min(3,$Articles.Count)) | ForEach-Object {
        $d = $_.day.ToString("00")
        "- **[$($_.title)](/$ContentType/$Year/$Month/$d)** - $($_.excerpt)"
    }

    $list = $Articles | ForEach-Object {
        $d = $_.day.ToString("00")
        "## [${_.title}](/$ContentType/$Year/$Month/$d)`n`n$Year-$Month-$d — $($_.excerpt)"
    }

    return @"
$front
# $ContentTitle for $Year-$Month

There are **$($Articles.Count)** $ContentTitle articles in $Year‑$Month.

## Featured

$($featured -join "`n")

## All articles

$($list -join "`n`n")
"@
}
#################################################################

Write-Host "=== Generating monthly index for $ContentTitle ($ContentType) ==="

# 年ディレクトリを列挙（フィルタあり）
$yearDirs = Get-ChildItem $ContentPath -Directory | Where-Object { $_.Name -match '^\d{4}$' }
if ($TargetYear) { $yearDirs = $yearDirs | Where-Object { $_.Name -eq $TargetYear } }

foreach ($yDir in $yearDirs) {
    $yr = $yDir.Name

    # 月ディレクトリを列挙（フィルタあり）
    $monDirs = Get-ChildItem $yDir.FullName -Directory | Where-Object { $_.Name -match '^\d{2}$' }
    if ($TargetMonth) { $monDirs = $monDirs | Where-Object { $_.Name -eq $TargetMonth } }

    foreach ($mDir in $monDirs) {
        $mn = $mDir.Name
        if ($MonthNumbers -notcontains $mn) { continue }   # 不正フォルダ無視

        $articles = Find-ArticlesInMonth $mDir.FullName
        if (-not $articles) { continue }

        $indexPath = Join-Path $mDir.FullName "index.md"
        $content   = Generate-MonthIndexContent -Year $yr -Month $mn -Articles $articles
        Set-Content $indexPath -Value $content -Encoding utf8

        Write-Host ("Generated: {0} ({1} articles)" -f $indexPath,$articles.Count)
    }
}

Write-Host "=== Done. ==="
