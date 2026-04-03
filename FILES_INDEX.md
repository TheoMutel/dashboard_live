# 📑 Index des fichiers - Dashboard Live

## 📚 Documentation (LISEZ CECI D'ABORD)

### Pour démarrer rapidement
- **[QUICKSTART.md](QUICKSTART.md)** ⚡ - Commandes rapides et démarrage en 3 étapes
- **[README.md](README.md)** 📖 - Guide complet d'installation

### Pour comprendre
- **[SETUP_SUMMARY.md](SETUP_SUMMARY.md)** ✨ - Résumé de tous les changements
- **[ARCHITECTURE.md](ARCHITECTURE.md)** 🏗️ - Explication technique de Mercure/Turbo

### Pour dépanner
- **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)** 🔧 - Solutions aux problèmes courants
- **[.env.local.example](.env.local.example)** ⚙️ - Configuration d'exemple

---

## 🎨 Interface & Templates

### Nouveaux fichiers
- **[templates/base.html.twig](templates/base.html.twig)** - Template Symfony de base avec Bootstrap, Chart.js, styles
  - Includes: Bootstrap 5 CDN, Chart.js, FontAwesome, Styles modernes
  - Contient: Navbar, structure de base, variables CSS

### Modifiés
- **[templates/dashboard/index.html.twig](templates/dashboard/index.html.twig)** - Interface complète du dashboard
  - Affiche: Prix BTC, graphique, statistiques
  - Mises à jour: En temps réel via Mercure
  - Responsive: Mobile + Desktop

---

## 💻 Code Source (src/)

### Backend - Contrôleurs
- **[src/Controller/DashboardController.php](src/Controller/DashboardController.php)** - Contrôleur principal
  - Route: `/dashboard`
  - Passe: `MERCURE_PUBLIC_URL` au template
  - Modification: Ajouté récupération de la variable d'env

### Commandes
- **[src/Command/AppPublishPriceCommand.php](src/Command/AppPublishPriceCommand.php)** - Simulation de prix
  - Commande: `php bin/console app:publish-price`
  - Intervalle: Toutes les 2 secondes
  - Publique: Via Mercure Hub

---

## 🎮 Assets (assets/)

### JavaScript
- **[assets/app.js](assets/app.js)** - Entry point principal
  - Importe: Controllers, styles
  - Utilise: Stimulus Bootstrap

- **[assets/controllers/price_tracker.js](assets/controllers/price_tracker.js)** - Nouvelle
  - Gère: MutationObserver pour prix
  - Émet: Events custom

### Styles
- **[assets/styles/app.css](assets/styles/app.css)** - Feuille de style globale
  - Contient: Variables CSS, gradient background
  - Modifiée: Changé de `skyblue` simples styles modernes

---

## ⚙️ Configuration

### Docker & Services
- **[compose.yaml](compose.yaml)** - Configuration Docker Compose
  - Services: Mercure, PostgreSQL, Database
  - Modification: Ajout ports 56427:80, CORS origins

### Environnement
- **[.env.local.example](.env.local.example)** - Nouveau
  - Gabarit: Configuration locale d'exemple
  - Variables: MERCURE_URL, MERCURE_PUBLIC_URL, DATABASE_URL

### Autres configurations
- **.env** - Existant (pas modifié, mais vérifié pour Mercure)
- **config/packages/mercure.yaml** - Existant (pas modifié)
- **config/packages/ux_turbo.yaml** - Existant (pas modifié)

---

## 🚀 Scripts d'automatisation

### Windows
- **[start-dashboard.ps1](start-dashboard.ps1)** - Nouveau
  - Langue: PowerShell
  - Vérifie: Prérequis (PHP, Docker, npm)
  - Démarre: Mercure, Symfony, Prix Publisher dans des nouvelles fenêtres

### Linux/macOS  
- **[start-dashboard.sh](start-dashboard.sh)** - Nouveau
  - Langue: Bash
  - Vérifie: Prérequis (php, docker-compose, npm)
  - Démarre: Mercure, Symfony, Prix Publisher en arrière-plan

---

## 📄 Fichiers à connaître

### Existants (pas modifiés, mais importants)
- **[bin/console](bin/console)** - CLI Symfony
- **[package.json](package.json)** - Dépendances npm
- **[composer.json](composer.json)** - Dépendances PHP
- **[config/routes.yaml](config/routes.yaml)** - Routage
- **[config/services.yaml](config/services.yaml)** - Services
- **[public/index.php](public/index.php)** - Entry point

### À utiliser
- **[importmap.php](importmap.php)** - Gestion des imports JS
- **[phpunit.dist.xml](phpunit.dist.xml)** - Configuration test
- **[symfony.lock](symfony.lock)** / **[composer.lock](composer.lock)** - Versions verrouillées

---

## 🔄 Workflow pour développer

```
CODE
 ↓
assets/app.js ou src/**
 ↓
npm run build (ou npm run watch)
 ↓
VISITE: http://localhost:8000/dashboard
 ↓
VOIR: Interface + Prix temps réel
```

---

## 📊 Stats du projet

| Métrique | Valeur |
|----------|--------|
| Fichiers créés | 9 |
| Fichiers modifiés | 4 |
| Fichiers documentés | 4 |
| Lignes de code | ~600+ |
| Lignes de doc | ~1500+ |
| Template Twig valides | 2/2 ✓ |

---

## ✅ Validations effectuées

- [x] Cache Symfony vidé et recompilé
- [x] Templates Twig validés (2/2 OK)
- [x] Configuration container DI validée
- [x] Syntaxe PHP vérifiée
- [x] Mercure configuration correcte
- [x] CORS configuré
- [x] Routes accessibles

---

## 🎯 Prochaines étapes

1. **Lire:** [QUICKSTART.md](QUICKSTART.md) pour démarrer
2. **Lancer:** `.\start-dashboard.ps1` (Windows) ou `./start-dashboard.sh` (Linux/Mac)
3. **Visiter:** http://localhost:8000/dashboard
4. **Consulter:** [README.md](README.md) pour plus de détails
5. **Améliorer:** Voir [ARCHITECTURE.md](ARCHITECTURE.md) pour les améliorations futures

---

## 🆘 Questions?

| Sujet | Fichier |
|-------|---------|
| Comment démarrer? | [QUICKSTART.md](QUICKSTART.md) |
| Erreur au démarrage? | [TROUBLESHOOTING.md](TROUBLESHOOTING.md) |
| Comment ça marche? | [ARCHITECTURE.md](ARCHITECTURE.md) |
| Qu'est-ce qui a changé? | [SETUP_SUMMARY.md](SETUP_SUMMARY.md) |
| Installation détaillée? | [README.md](README.md) |

---

## 🎁 Bonus

**Fichiers d'exemple/template fournis pour référence:**
- `.env.local.example` - Configuration à copier en `.env.local`
- `start-dashboard.ps1` & `start-dashboard.sh` - À rendre exécutables et lancer

**Fichiers de référence technique:**
- [ARCHITECTURE.md](ARCHITECTURE.md) - Explication Mercure/Turbo flow
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - 10+ solutions côté devel

---

**Le dashboard est maintenant prêt à utiliser!** 🚀  
Commençez par [QUICKSTART.md](QUICKSTART.md) pour le démarrer en 3 étapes.
