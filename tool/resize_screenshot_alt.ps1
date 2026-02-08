Add-Type -AssemblyName System.Drawing

$inputPath = $args[0]
$outputPath = "C:\Users\luke2\Documents\Agreg_Master\paywall_screenshot_apple_alt.png"

$img = [System.Drawing.Image]::FromFile($inputPath)

# Target: iPhone 6.5 inch alternative (1242 x 2208)
$targetWidth = 1242
$targetHeight = 2208

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
