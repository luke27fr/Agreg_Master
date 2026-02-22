Add-Type -AssemblyName System.Drawing

$inputPath = $args[0]
$outputPath = "C:\Users\luke2\Documents\Agreg_Master\paywall_screenshot_apple.png"

$img = [System.Drawing.Image]::FromFile($inputPath)
Write-Host "Original: $($img.Width) x $($img.Height)"

# Target: iPhone 6.5 inch (1284 x 2778)
$targetWidth = 1284
$targetHeight = 2778

$bmp = New-Object System.Drawing.Bitmap($targetWidth, $targetHeight)
$bmp.SetResolution(72, 72)
$graphics = [System.Drawing.Graphics]::FromImage($bmp)
$graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$graphics.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
$graphics.DrawImage($img, 0, 0, $targetWidth, $targetHeight)

$bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)

Write-Host "Saved: $targetWidth x $targetHeight -> $outputPath"

$graphics.Dispose()
$bmp.Dispose()
$img.Dispose()
