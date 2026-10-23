# Generates the PWA icons (a bee on a honey background) with GDI+.
Add-Type -AssemblyName System.Drawing
$out = Join-Path $PSScriptRoot 'icons'
New-Item -ItemType Directory -Force $out | Out-Null

function Draw-Icon([int]$size, [string]$path, [bool]$maskable) {
  $bmp = New-Object System.Drawing.Bitmap $size, $size
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = 'AntiAlias'
  $g.Clear([System.Drawing.Color]::Transparent)

  # background: honey gradient, rounded unless maskable (maskable = full bleed, content in safe zone)
  $grad = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    (New-Object System.Drawing.Point 0, 0), (New-Object System.Drawing.Point $size, $size),
    [System.Drawing.Color]::FromArgb(255, 0xF7, 0xC1, 0x4A), [System.Drawing.Color]::FromArgb(255, 0xD9, 0x93, 0x1A))
  if ($maskable) {
    $g.FillRectangle($grad, 0, 0, $size, $size)
  } else {
    $r = [int]($size * 0.22)
    $gp = New-Object System.Drawing.Drawing2D.GraphicsPath
    $gp.AddArc(0, 0, 2*$r, 2*$r, 180, 90); $gp.AddArc($size-2*$r, 0, 2*$r, 2*$r, 270, 90)
    $gp.AddArc($size-2*$r, $size-2*$r, 2*$r, 2*$r, 0, 90); $gp.AddArc(0, $size-2*$r, 2*$r, 2*$r, 90, 90); $gp.CloseFigure()
    $g.FillPath($grad, $gp)
  }

  # faint honeycomb hexagons
  $hexPen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(45, 255, 255, 255)), ([float]($size*0.012))
  $hr = $size * 0.11
  for ($row = -1; $row -lt 8; $row++) {
    for ($col = -1; $col -lt 8; $col++) {
      $cx = $col * $hr * 1.75 + ($(if ($row % 2) { $hr * 0.875 } else { 0 }))
      $cy = $row * $hr * 1.5
      $pts = @()
      for ($i = 0; $i -lt 6; $i++) { $a = [Math]::PI/180 * (60*$i + 30); $pts += New-Object System.Drawing.PointF ([float]($cx + $hr*[Math]::Cos($a))), ([float]($cy + $hr*[Math]::Sin($a))) }
      $g.DrawPolygon($hexPen, $pts)
    }
  }

  # bee
  $s = $size; $cx = $s*0.5; $cy = $s*0.54
  $scale = $(if ($maskable) { 0.78 } else { 1.0 })
  $bw = $s*0.50*$scale; $bh = $s*0.36*$scale
  $dark = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 0x2B, 0x1D, 0x00))
  $yellow = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 0xFF, 0xD9, 0x6B))
  $white = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(225, 255, 255, 255))
  $wingOutline = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(255, 0x2B, 0x1D, 0x00)), ([float]($s*0.018*$scale))

  # wings
  $ww = $s*0.20*$scale; $wh = $s*0.26*$scale
  $g.TranslateTransform($cx - $bw*0.12, $cy - $bh*0.55); $g.RotateTransform(-25)
  $g.FillEllipse($white, -$ww/2, -$wh, $ww, $wh); $g.DrawEllipse($wingOutline, -$ww/2, -$wh, $ww, $wh); $g.ResetTransform()
  $g.TranslateTransform($cx + $bw*0.12, $cy - $bh*0.55); $g.RotateTransform(25)
  $g.FillEllipse($white, -$ww/2, -$wh, $ww, $wh); $g.DrawEllipse($wingOutline, -$ww/2, -$wh, $ww, $wh); $g.ResetTransform()

  # body (clipped stripes)
  $body = New-Object System.Drawing.Drawing2D.GraphicsPath
  $body.AddEllipse([float]($cx-$bw/2), [float]($cy-$bh/2), [float]$bw, [float]$bh)
  $g.FillPath($dark, $body)
  $g.SetClip($body)
  $stripeW = $bw*0.14
  foreach ($k in @(-0.22, 0.10)) { $g.FillRectangle($yellow, [float]($cx + $bw*$k - $stripeW/2), [float]($cy-$bh), [float]$stripeW, [float]($bh*2)) }
  $g.ResetClip()

  # stinger
  $st = @((New-Object System.Drawing.PointF ([float]($cx+$bw/2 - $bw*0.04)), ([float]($cy - $bh*0.10))),
          (New-Object System.Drawing.PointF ([float]($cx+$bw/2 + $bw*0.10)), ([float]$cy)),
          (New-Object System.Drawing.PointF ([float]($cx+$bw/2 - $bw*0.04)), ([float]($cy + $bh*0.10))))
  $g.FillPolygon($dark, $st)

  # eye + smile
  $eye = $s*0.045*$scale
  $g.FillEllipse($white, [float]($cx - $bw*0.34 - $eye/2), [float]($cy - $bh*0.14 - $eye/2), [float]$eye, [float]$eye)
  $g.FillEllipse($dark, [float]($cx - $bw*0.35 - $eye/4), [float]($cy - $bh*0.14 - $eye/4), [float]($eye/2), [float]($eye/2))
  $smilePen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(255, 0xFF, 0xD9, 0x6B)), ([float]($s*0.014*$scale))
  $smilePen.StartCap = 'Round'; $smilePen.EndCap = 'Round'
  $g.DrawArc($smilePen, [float]($cx - $bw*0.44), [float]($cy - $bh*0.05), [float]($bw*0.14), [float]($bh*0.28), 30, 120)

  # antennae
  $antPen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(255, 0x2B, 0x1D, 0x00)), ([float]($s*0.016*$scale))
  $antPen.StartCap = 'Round'; $antPen.EndCap = 'Round'
  $g.DrawLine($antPen, [float]($cx - $bw*0.36), [float]($cy - $bh*0.45), [float]($cx - $bw*0.46), [float]($cy - $bh*0.85))
  $g.FillEllipse($dark, [float]($cx - $bw*0.46 - $eye*0.45), [float]($cy - $bh*0.85 - $eye*0.45), [float]($eye*0.9), [float]($eye*0.9))

  $g.Dispose()
  $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
  $bmp.Dispose()
  Write-Output "wrote $path"
}

Draw-Icon 192 (Join-Path $out 'icon-192.png') $false
Draw-Icon 512 (Join-Path $out 'icon-512.png') $false
Draw-Icon 512 (Join-Path $out 'icon-maskable-512.png') $true
Draw-Icon 180 (Join-Path $out 'apple-touch-icon.png') $false
