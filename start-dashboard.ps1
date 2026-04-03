# Dashboard Live - Start Script
# Ce script démarre tous les services nécessaires pour le dashboard en temps réel

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "  Crypto Dashboard - Start Script" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Vérifier les prérequis
Write-Host "[1/4] Vérification des prérequis..." -ForegroundColor Yellow

$prereqs = @("php", "docker-compose", "npm")
$missing = @()

foreach ($tool in $prereqs) {
    try {
        $version = & $tool --version 2>&1 | Select-Object -First 1
        Write-Host "✓ $tool trouvé: $version" -ForegroundColor Green
    } catch {
        $missing += $tool
        Write-Host "✗ $tool non trouvé" -ForegroundColor Red
    }
}

if ($missing.Count -gt 0) {
    Write-Host "`n⚠️  Outils manquants: $($missing -join ', ')" -ForegroundColor Red
    Write-Host "Veuillez installer les dépendances manquantes avant de continuer." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "[2/4] Démarrage de Mercure (Docker)..." -ForegroundColor Yellow

$dockerRunning = docker-compose -f compose.yaml ps 2>&1 | Select-String "Up" -Quiet

if (-not $dockerRunning) {
    docker-compose -f compose.yaml up -d | Out-Host
    Start-Sleep -Seconds 3
    Write-Host "✓ Mercure démarré sur http://localhost:56427" -ForegroundColor Green
} else {
    Write-Host "✓ Mercure est déjà en cours d'exécution" -ForegroundColor Green
}

Write-Host ""
Write-Host "[3/4] Démarrage du serveur Symfony..." -ForegroundColor Yellow

# Vérifier si symfony-cli est installé
$symfonyExists = Test-Path "C:\Program Files\symfony\bin\symfony.exe" -ErrorAction SilentlyContinue
$symphonyInPath = (Get-Command symfony -ErrorAction SilentlyContinue) -ne $null

if ($symphonyInPath -or $symfonyExists) {
    Start-Process powershell -ArgumentList "-NoExit -Command `"cd '$PWD'; symfony serve`"" -WindowStyle Normal
    Write-Host "✓ Serveur Symfony lancé dans une nouvelle fenêtre" -ForegroundColor Green
} else {
    Write-Host "Note: symfony-cli non trouvé, utilisation de 'php bin/console server:run' à la place" -ForegroundColor Yellow
    Start-Process powershell -ArgumentList "-NoExit -Command `"cd '$PWD'; php bin/console server:run`"" -WindowStyle Normal
    Write-Host "✓ Serveur lancé dans une nouvelle fenêtre" -ForegroundColor Green
}

Start-Sleep -Seconds 2

Write-Host ""
Write-Host "[4/4] Démarrage de la commande de publication des prix..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit -Command `"cd '$PWD'; php bin/console app:publish-price`"" -WindowStyle Normal
Write-Host "✓ Commande de publication lancée dans une nouvelle fenêtre" -ForegroundColor Green

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "✨ Dashboard prêt à l'emploi!" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Accédez au dashboard à:" -ForegroundColor White
Write-Host "  http://localhost:8000/dashboard" -ForegroundColor Cyan
Write-Host ""
Write-Host "Services:" -ForegroundColor White
Write-Host "  • Symfony:     http://localhost:8000" -ForegroundColor Cyan
Write-Host "  • Mercure:     http://localhost:56427" -ForegroundColor Cyan
Write-Host ""
Write-Host "Pour arrêter les services:" -ForegroundColor Yellow
Write-Host "  docker-compose -f compose.yaml down" -ForegroundColor Gray
Write-Host ""
