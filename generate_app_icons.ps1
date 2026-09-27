Add-Type -AssemblyName System.Drawing

$srcPath = "C:\Users\Hp\.gemini\antigravity-ide\brain\9a8fae6e-d4dd-4e80-84fa-4bb99459864d\bengali_ring_of_words_icon_1790518507356.jpg"
$outDir = "f:\Ring of words\wordnest\android\app\src\main\res"
$previewPath = "C:\Users\Hp\.gemini\antigravity-ide\brain\9a8fae6e-d4dd-4e80-84fa-4bb99459864d\bengali_icon_preview.png"

$src = [System.Drawing.Bitmap]::FromFile($srcPath)

# Crop exactly 620x620 from (198, 198) where all 4 corners and borders are pure white
$cropRect = New-Object System.Drawing.Rectangle(198, 198, 620, 620)
$cropped = New-Object System.Drawing.Bitmap(620, 620)
$gCrop = [System.Drawing.Graphics]::FromImage($cropped)
$gCrop.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$gCrop.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$gCrop.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
$gCrop.DrawImage($src, (New-Object System.Drawing.Rectangle(0, 0, 620, 620)), $cropRect, [System.Drawing.GraphicsUnit]::Pixel)
$gCrop.Dispose()

# Create 1024x1024 master icon with pure white background
$master = New-Object System.Drawing.Bitmap(1024, 1024, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$gMaster = [System.Drawing.Graphics]::FromImage($master)
$gMaster.Clear([System.Drawing.Color]::White)
$gMaster.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$gMaster.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$gMaster.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

# Target size 880x880 with 72px margin
$targetSize = 880
$offset = [int]((1024 - $targetSize) / 2)
$gMaster.DrawImage($cropped, (New-Object System.Drawing.Rectangle($offset, $offset, $targetSize, $targetSize)))
$gMaster.Dispose()

# Save master preview
$master.Save($previewPath, [System.Drawing.Imaging.ImageFormat]::Png)
Write-Host "Saved master preview to $previewPath"

# Mipmap densities
$sizes = @{
    "mipmap-mdpi" = 48
    "mipmap-hdpi" = 72
    "mipmap-xhdpi" = 96
    "mipmap-xxhdpi" = 144
    "mipmap-xxxhdpi" = 192
}

foreach ($entry in $sizes.GetEnumerator()) {
    $folder = Join-Path $outDir $entry.Key
    if (-not (Test-Path $folder)) {
        New-Item -ItemType Directory -Path $folder -Force | Out-Null
    }
    $targetFile = Join-Path $folder "ic_launcher.png"
    $s = $entry.Value
    
    $dest = New-Object System.Drawing.Bitmap($s, $s, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($dest)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.DrawImage($master, (New-Object System.Drawing.Rectangle(0, 0, $s, $s)))
    $g.Dispose()
    
    $dest.Save($targetFile, [System.Drawing.Imaging.ImageFormat]::Png)
    $dest.Dispose()
    Write-Host "Generated $targetFile ($s x $s)"
}

$cropped.Dispose()
$master.Dispose()
$src.Dispose()
Write-Host "All icons generated successfully!"
