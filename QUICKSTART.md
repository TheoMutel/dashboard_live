# ⚡ Quick Start - Commandes rapides

## 🚀 Démarrage complet en 3 étapes

### Windows (PowerShell)
```powershell
.\start-dashboard.ps1
# Ouvre tout automatiquement dans des nouvelles fenêtres ✨
```

### Linux/macOS
```bash
chmod +x start-dashboard.sh
./start-dashboard.sh
# Lance tous les services en arrière-plan
```

### Manuelle (tout système)
```bash
# Terminal 1: Mercure (Docker)
docker-compose -f compose.yaml up -d

# Terminal 2: Symfony serveur
symfony serve

# Terminal 3: Prix publisher
php bin/console app:publish-price

# Visite:
# → http://localhost:8000/dashboard
```

---

## 📋 Checklist avant de commencer

- [x] PHP 8.2+ installé
- [x] Composer (composer install ✓)
- [x] Docker & Docker Compose
- [x] npm (npm install ✓)
- [x] Code modifié et validé ✓
- [ ] Variables .env vérifiées

---

## 🔧 Commandes utiles

### Symfony/Framework
```bash
# Vider le cache
php bin/console cache:clear

# Validation
php bin/console lint:twig          # Valider templates
php bin/console lint:container     # Valider config

# Routes
php bin/console debug:router       # Afficher les routes
```

### Docker/Mercure
```bash
# Démarrer/Arrêter
docker-compose -f compose.yaml up -d        # Démarrer
docker-compose -f compose.yaml down         # Arrêter
docker-compose -f compose.yaml logs -f      # Logs live

# Vérifier l'état
docker-compose -f compose.yaml ps           # Services actifs
curl http://localhost:56427/healthz         # Santé Mercure
```

### Base de données
```bash
# Créer la DB
php bin/console doctrine:database:create

# Migrations
php bin/console doctrine:migrations:migrate

# Dump/Load
php bin/console doctrine:database:drop --force
php bin/console doctrine:database:create
```

### Assets/Frontend
```bash
# Builder
npm run build

# Watch mode (dev)
npm run watch

# Voir les fichiers finaux
npm run dump-env        # Afficher les importmaps
```

---

## 🎯 URLs d'accès

| Service | URL |
|---------|-----|
| Dashboard | http://localhost:8000/dashboard |
| Symfony | http://localhost:8000 |
| Mercure | http://localhost:56427 |
| Mercure Health | http://localhost:56427/healthz |

---

## 🧪 Test rapide

```bash
# Tester que tout compile
php bin/console cache:clear          # ✓ Symfony OK
php bin/console lint:twig            # ✓ Templates OK  
php bin/console lint:container       # ✓ Config OK

# Tester la connexion à Mercure
curl http://localhost:56427/healthz  # Doit retourner 200

# Tester Symfony routes
php bin/console debug:router         # Affiche /dashboard
```

---

## 🐛 Dépannage rapide

| Problème | Solution |
|----------|----------|
| Port 8000 utilisé | `php bin/console server:run --port=8001` |
| Port 56427 utilisé | `docker-compose -f compose.yaml stop` |
| Cache corrompu | `rm -rf var/cache && php bin/console cache:clear` |
| Assets manquants | `npm run build` |
| DB non trouvée | `php bin/console doctrine:database:create` |

---

## 📞 Besoin d'aide?

1. **Consulter la doc:**
   - [README.md](README.md) - Installation et démarrage
   - [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - Solutions détaillées
   - [ARCHITECTURE.md](ARCHITECTURE.md) - Fonctionnement technique

2. **Vérifier les logs:**
   ```bash
   # Symfony logs
   tail -f var/log/dev.log
   
   # Docker logs
   docker-compose logs -f
   ```

3. **Redémarrer proprement:**
   ```bash
   docker-compose -f compose.yaml down -v    # Stop tout + volumes
   docker-compose -f compose.yaml up -d       # Redémarrer frais
   php bin/console cache:clear
   ```

---

## 💡 Tips de développement

### Workflow développement
```bash
# Terminal 1: Assets watch
npm run watch

# Terminal 2: Symfony serveur
symfony serve

# Terminal 3: Mercure + DB
docker-compose -f compose.yaml up

# Terminal 4: Prix simulator
php bin/console app:publish-price
```

### Code hot-reload
Symfony Serve supporte le hot-reload automatique. Si ce n'est pas le cas:
```bash
php bin/console cache:clear    # Entre chaque changement
```

### Déboguer Turbo
Dans la console navigateur (F12):
```javascript
// Voir les streams reçus
document.addEventListener('turbo:load', () => console.log('Turbo loaded'));
document.addEventListener('turbo:submit-end', () => console.log('Turbo stream received'));

// Vérifier Mercure
fetch('http://localhost:56427/.well-known/mercure?topic=btc-data', {
    headers: {'Authorization': 'Bearer TOKEN'}
})
```

---

## 🎯 Prochaines étapes

**Pour exécuter le dashboard:**
```bash
.\start-dashboard.ps1    # Windows
# ou
./start-dashboard.sh     # Linux/Mac
```

**Puis visiter:**
```
http://localhost:8000/dashboard
```

**À partir de là:**
1. Voir le prix BTC en temps réel
2. Regarder le graphique se construire
3. Les stats se mettre à jour
4. Consulter README.md pour améliorations futures

---

## 📚 Liens utiles

- [Symfony Docs](https://symfony.com/doc/current)
- [Mercure Rocks](https://mercure.rocks)
- [Turbo Hotwired](https://turbo.hotwired.dev)
- [Chart.js](https://www.chartjs.org)
- [Bootstrap 5](https://getbootstrap.com/docs/5.0)

---

**Créé avec ❤️ pour vous. Bon dashboard!** 🚀
