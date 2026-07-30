<#
.SYNOPSIS
    Reconstruit Wargame Board (Windows, release) et copie l'exécutable
    prêt à l'emploi vers un dossier fixe, pour ne pas avoir à chercher le
    dossier de build à chaque fois.

.DESCRIPTION
    - Compile l'appli en release avec `flutter build windows`.
    - Définit CMAKE_POLICY_VERSION_MINIMUM=3.5 pour cette exécution
      (contournement d'un souci de compatibilité entre CMake >= 4.0 et
      le plugin pdfx — voir le message d'erreur "Compatibility with
      CMake < 3.10 will be removed" sinon).
    - Copie tout le dossier Release (exe + DLL + assets nécessaires, pas
      juste le .exe seul) vers .\dist\, en la vidant avant pour ne jamais
      mélanger une ancienne DLL avec un nouvel exe.
    - Ouvre le dossier de destination dans l'explorateur à la fin.

.PARAMETER SkipOpen
    N'ouvre pas l'explorateur de fichiers à la fin.

.EXAMPLE
    .\build_and_deploy.ps1
#>

[CmdletBinding()]
param(
    [switch]$SkipOpen
)

$ErrorActionPreference = 'Stop'

$root = $PSScriptRoot
$releaseDir = Join-Path $root 'build\windows\x64\runner\Release'
$distDir = Join-Path $root 'dist'

Write-Host "==> Compilation (flutter build windows --release)..." -ForegroundColor Cyan
$env:CMAKE_POLICY_VERSION_MINIMUM = '3.5'

Push-Location $root
try {
    flutter build windows --release
    if ($LASTEXITCODE -ne 0) {
        throw "flutter build windows a échoué (code $LASTEXITCODE)."
    }
} finally {
    Pop-Location
}

if (-not (Test-Path $releaseDir)) {
    throw "Dossier de build introuvable : $releaseDir"
}

Write-Host "==> Copie vers $distDir ..." -ForegroundColor Cyan
if (Test-Path $distDir) {
    Remove-Item $distDir -Recurse -Force
}
New-Item -ItemType Directory -Path $distDir -Force | Out-Null
Copy-Item -Path (Join-Path $releaseDir '*') -Destination $distDir -Recurse -Force

$exePath = Join-Path $distDir 'wargameboard.exe'
if (-not (Test-Path $exePath)) {
    throw "Copie terminée mais wargameboard.exe est introuvable dans $distDir"
}

Write-Host ""
Write-Host "==> Terminé ! Exécutable prêt : $exePath" -ForegroundColor Green

if (-not $SkipOpen) {
    explorer.exe $distDir
}
