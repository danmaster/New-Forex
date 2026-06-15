param(
    [string]$channelName,
    [string]$jsonlFile,
    [string]$outputFile
)

$content = "# Lista de Videos de $channelName`n`nEsta lista se genera automáticamente.`n`n"
if (Test-Path $jsonlFile) {
    $lines = Get-Content $jsonlFile -Encoding UTF8
    foreach ($line in $lines) {
        try {
            $video = $line | ConvertFrom-Json
            $title = $video.title
            $url = $video.webpage_url
            if (-not $url) {
                $url = "https://www.youtube.com/watch?v=" + $video.id
            }
            $date = $video.upload_date
            if ($date -and $date.Length -eq 8) {
                $formattedDate = "$($date.Substring(0,4))-$($date.Substring(4,2))-$($date.Substring(6,2))"
                $content += "- [$title] ($formattedDate) ($url)`n"
            } else {
                $content += "- [$title] ($url)`n"
            }
        } catch {
            Write-Host "Error parsing line: $_"
        }
    }
} else {
    $content += "No se encontraron videos.`n"
}

[System.IO.File]::WriteAllText($outputFile, $content, (New-Object System.Text.UTF8Encoding $False))
Write-Host "Generated $outputFile"
