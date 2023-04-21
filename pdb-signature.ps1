#!/usr/bin/env pwsh
# PDB Signature Extractor
#
# Reference:
# * https://stackoverflow.com/questions/1419347/microsoft-symbol-server-local-cache-hash-algorithm
# * https://groups.google.com/g/microsoft.public.vc.debugger/c/xLVvCBIU6fI/m/0ErZ6YlXJDEJ
param(
   [string] $pdb
)
if (-not (Test-Path $pdb)) {
   Write-Host "Usage: pdb-signature.ps1 <file.pdb>"
   Write-Host "Optional: Add -verbose to get all output from dbh.exe"
   exit 1
}
$sdk_bin = "C:\Program Files (x86)\Windows Kits\10\Debuggers\x64"
$dbh_exe = "${sdk_bin}/dbh.exe"
$result = & $dbh_exe $pdb info
$signature = "Unknown"
$suffix = ""
function Parse-DBH-Output($line) {
   return $line -replace "^.*: ","" -replace ", 0x","" -replace "^0x",""
}
foreach ($line in $result) {
   if ($line.contains("PdbSig70")) {
      $signature = Parse-DBH-Output $line
      continue
   }
   if ($line.contains("PdbAge")) {
      $suffix = Parse-DBH-Output $line
   }
}
$signature += $suffix
Write-Output $signature.ToUpper()