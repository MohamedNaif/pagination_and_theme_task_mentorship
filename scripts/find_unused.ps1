$files = Get-ChildItem -Path .\lib -Recurse -Filter *.dart
$all = Get-ChildItem -Path . -Recurse -Include *.dart -File | Select-Object -ExpandProperty FullName
foreach($f in $files) {
  $rel = $f.FullName.Substring((Get-Location).Path.Length+1) -replace '\\','/'
  $pkg = 'package:pagination_and_theme_task/' + ($rel -replace '^lib/','')
  $matches = Select-String -Path $all -Pattern $pkg -SimpleMatch -List
  if (($matches).Count -eq 0) { Write-Output $rel }
}
