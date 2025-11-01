$files = Get-ChildItem -Path .\lib -Recurse -Filter *.dart
$all = Get-ChildItem -Path . -Recurse -Include *.dart -File | Select-Object -ExpandProperty FullName
foreach($f in $files) {
  $rel = $f.FullName.Substring((Get-Location).Path.Length+1) -replace '\\','/'
  $pkg = 'package:pagination_and_theme_task/' + ($rel -replace '^lib/','')
  $basename = $f.Name
  $matches_pkg = Select-String -Path $all -Pattern ([regex]::Escape($pkg)) -SimpleMatch -List
  $matches_name = Select-String -Path $all -Pattern ([regex]::Escape($basename)) -SimpleMatch -List
  # exclude self-match
  $other_matches_name = $matches_name | Where-Object { $_.Path -ne $f.FullName }
  $other_matches_pkg = $matches_pkg | Where-Object { $_.Path -ne $f.FullName }
  if (($other_matches_pkg).Count -eq 0 -and ($other_matches_name).Count -eq 0) {
    Write-Output $rel
  }
}
