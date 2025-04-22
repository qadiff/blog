#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Generate monthly archive markdowns (YYYY.MM.md) for a given repository.

.DESCRIPTION
    Directory example (news)
    src/
      external/
        news/
          2025/
            04/
              22/
                index.md
          archives/
#>

# ============= 変更する変数 =============
$ContentType = "blog"   # "news" または "blog"

# 生成対象を限定する場合（空なら全期間）
$TargetYear  = ""       # 例 "2025"
$TargetMonth = ""       # 例 "04" (必ず2桁)
# =======================================

# 見出し用ラベル
$ContentTitle = if ($ContentType -eq "news") { "News" } else { "Blog" }

# ルートパス解決
$ScriptRoot  = Split-Path -Parent $MyInvocation.MyCommand.Path
$RootDir     = (Get-Item $ScriptRoot).Parent.FullName
$ContentPath = Join-Path -Path $RootDir -ChildPath "$ContentType"
if (-not (Test-Path $ContentPath)) {
    Write-Error "Content path '$ContentPath' not found."
    exit 1
}

############################################
# フロントマター抽出
function Parse-FrontMatter {
    param ([string]$FilePath)
    $raw = Get-Content $FilePath -Raw
    $fm  = @{}
    if ($raw -match "(?s)^---\s*(.*?)\s*---") {
        foreach ($ln in (($Matches[1]) -split "`n")) {
            if ($ln -match "^\s*([^:]+):\s*(.+)\s*$") {
                $k,$v = $Matches[1].Trim(), $Matches[2].Trim()
                if ($v -eq "true")  { $v = $true }
                if ($v -eq "false") { $v = $false }
                $fm[$k] = $v
            }
        }
    }
    return $fm
}

# 記事収集
function Find-Articles {
    param ([string]$Path)
    $all = @()
    $yearDirs = Get-ChildItem $Path -Directory | Where-Object { $_.Name -match '^\d{4}$' }
    if ($TargetYear) { $yearDirs = $yearDirs | Where-Object { $_.Name -eq $TargetYear } }

    foreach ($y in $yearDirs) {
        $monthDirs = Get-ChildItem $y.FullName -Directory | Where-Object { $_.Name -match '^\d{2}$' }
        if ($TargetMonth) { $monthDirs = $monthDirs | Where-Object { $_.Name -eq $TargetMonth } }

        foreach ($m in $monthDirs) {
            $dayDirs = Get-ChildItem $m.FullName -Directory | Where-Object { $_.Name -match '^\d{2}$' }
            foreach ($d in $dayDirs) {
                $idx = Join-Path $d.FullName "index.md"
                if (Test-Path $idx) {
                    $fm = Parse-FrontMatter $idx
                    $date = $null
                    if ($fm.date) {
                        try   { $date = [datetime]::Parse($fm.date) }
                        catch { $date = Get-Date -Year $y.Name -Month $m.Name -Day $d.Name }
                    } else {
                        $date = Get-Date -Year $y.Name -Month $m.Name -Day $d.Name
                    }
                    $all += [pscustomobject]@{
                        title = $fm.title
                        date  = $date
                        slug  = "$($y.Name)/$($m.Name)/$($d.Name)"
                    }
                }
            }
        }
    }
    return $all
}

# アーカイブ本文生成（すべて数値月）
function Build-Archive {
    param (
        [string]$Year,   # 4 桁
        [string]$Month,  # 2 桁
        [array] $Arts
    )

    $fm = @"
---
lang: ja
title: $ContentTitle articles for $Year-$Month
year:  $Year
month: $Month
layout: archive
---
"@

    $lines = $Arts | ForEach-Object {
        $d = $_.date.Day.ToString("00")
        "- $Month-$d : [$($_.title)](/$ContentType/$Year/$Month/$d)"
    }

    return @"
$fm
# $ContentTitle articles for $Year-$Month

There are **$($Arts.Count)** $ContentTitle articles in $Year-$Month.

$($lines -join "`n")
"@
}
############################################

Write-Host "=== Generating $ContentTitle archives ==="

$archivesDir = Join-Path $ContentPath "archives"
if (-not (Test-Path $archivesDir)) { New-Item $archivesDir -ItemType Directory | Out-Null }

$articles = Find-Articles $ContentPath
if (-not $articles) {
    Write-Warning "No articles found."
    exit 0
}
Write-Host ("Total articles found: {0}" -f $articles.Count)

# 年月でグループ化
$groups = $articles | Group-Object { $_.date.ToString("yyyy.MM") }
foreach ($g in $groups) {
    $ym     = $g.Name           # "2025.04"
    $yr,$mn = $ym -split '\.'
    $out    = Join-Path $archivesDir "$ym.md"

    $sorted = $g.Group | Sort-Object date -Descending
    $body   = Build-Archive -Year $yr -Month $mn -Arts $sorted

    Set-Content $out -Value $body -Encoding utf8
    Write-Host ("Generated: {0} ({1} articles)" -f $out, $sorted.Count)
}

Write-Host "=== Done. ==="
