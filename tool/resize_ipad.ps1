Add-Type -AssemblyName System.Drawing

$inputPath = $args[0]
$outputPath = "C:\Users\luke2\Documents\Agreg_Master\paywall_screenshot_ipad.png"

$img = [System.Drawing.Image]::FromFile($inputPath)
Write-Host "Original: $($img.Width) x $($img.Height)"

# Target: iPad Pro 13 inch (2048 x 2732)
$targetWidth = 2048
$targetHeight = 2732

# Create bitmap WITHOUT alpha channel (Format24bppRgb)
$bmp = New-Object System.Drawing.Bitmap($targetWidth, $targetHeight, [System.Drawing.Imaging.PixelFormat]::Format24bppRgb)
$bmp.SetResolution(72, 72)
$graphics = [System.Drawing.Graphics]::FromImage($bmp)
$graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$graphics.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality

# Fill background with white
$brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
$graphics.FillRectangle($brush, 0, 0, $targetWidth, $targetHeight)

# Calculate centered position - scale image to fit height, center horizontally
$scale = $targetHeight / $img.Height
$scaledWidth = [int]($img.Width * $scale)
$scaledHeight = $targetHeight
$offsetX = [int](($targetWidth - $scaledWidth) / 2)

$graphics.DrawImage($img, $offsetX, 0, $scaledWidth, $scaledHeight)

# Save as JPEG to guarantee no alpha, then convert back to PNG
$bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)

Write-Host "Saved: $targetWidth x $targetHeight (no alpha) -> $outputPath"

$brush.Dispose()
$graphics.Dispose()
$bmp.Dispose()
$img.Dispose()
