$folderName = "/"
$date = Get-Date -Format "yyyy/MM/dd"
if (Test-Path ./$folderName/$date/) {
    Write-Host "Folder $date already exists."
} 
else
{
    Write-Host "Folder $date Create."
    New-Item -ItemType Directory -Path ./$folderName/$date/ -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Path ./$folderName/$date/attachments/ -ErrorAction SilentlyContinue
    Copy-Item -Path ./Templates/* -Destination ./$folderName/$date/ -Recurse
}

Start-Process -WindowStyle Hidden code .\$folderName\$date\index.md


# VS Code で、対象のフォルダを開く
# Invoke-Item .\$folderName\$date\

# Path: WCreateDailyReport.ps1
