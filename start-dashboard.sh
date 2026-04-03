#!/bin/bash

# Dashboard Live - Start Script (macOS/Linux)
# Ce script démarre tous les services nécessaires pour le dashboard en temps réel

echo "===================================="
echo "  Crypto Dashboard - Start Script"
echo "===================================="
echo ""

# Vérifier les prérequis
echo "[1/4] Vérification des prérequis..."

MISSING_TOOLS=0

for tool in php docker-compose npm; do
    if command -v $tool &> /dev/null; then
        version=$($tool --version 2>&1 | head -1)
        echo "✓ $tool trouvé: $version"
    else
        echo "✗ $tool non trouvé"
        MISSING_TOOLS=1
    fi
done

if [ $MISSING_TOOLS -eq 1 ]; then
    echo ""
    echo "⚠️  Veuillez installer les dépendances manquantes avant de continuer."
    exit 1
fi

echo ""
echo "[2/4] Démarrage de Mercure (Docker)..."

if docker-compose -f compose.yaml ps 2>/dev/null | grep -q "Up"; then
    echo "✓ Mercure est déjà en cours d'exécution"
else
    docker-compose -f compose.yaml up -d
    sleep 3
    echo "✓ Mercure démarré sur http://localhost:56427"
fi

echo ""
echo "[3/4] Démarrage du serveur Symfony..."

# Vérifier si symfony-cli est installé
if command -v symfony &> /dev/null; then
    (cd "$(pwd)" && symfony serve) &
    echo "✓ Serveur Symfony lancé"
else
    echo "Note: symfony-cli non trouvé, utilisation de 'php bin/console server:run' à la place"
    (cd "$(pwd)" && php bin/console server:run) &
    echo "✓ Serveur lancé"
fi

sleep 2

echo ""
echo "[4/4] Démarrage de la commande de publication des prix..."

(cd "$(pwd)" && php bin/console app:publish-price) &
echo "✓ Commande de publication lancée"

echo ""
echo "===================================="
echo "✨ Dashboard prêt à l'emploi!"
echo "===================================="
echo ""
echo "Accédez au dashboard à:"
echo "  http://localhost:8000/dashboard"
echo ""
echo "Services:"
echo "  • Symfony:     http://localhost:8000"
echo "  • Mercure:     http://localhost:56427"
echo ""
echo "Pour arrêter les services:"
echo "  docker-compose -f compose.yaml down"
echo "  pkill -f 'symfony serve|server:run|app:publish-price'"
echo ""
