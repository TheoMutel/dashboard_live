# 🔧 Guide de Dépannage - Dashboard en Temps Réel

## Problèmes courants et solutions

### 1. Mercure ne démarre pas

**Erreur:** `Failed to start container`

**Solutions:**
```bash
# Vérifier les logs
docker-compose -f compose.yaml logs mercure

# Redémarrer Mercure
docker-compose -f compose.yaml restart mercure

# Recréer les conteneurs
docker-compose -f compose.yaml down
docker-compose -f compose.yaml up -d
```

**Cause commune:** Port 56427 déjà utilisé
```bash
# Sur Windows, trouver le processus utilisant le port
netstat -ano | findstr :56427

# Arrêter le processus (remplacer PID)
taskkill /PID <PID> /F
```

---

### 2. Prix ne se mettent pas à jour

**Symptômes:** 
- Le prix affiche la valeur initiale
- Pas d'erreur en console
- La commande `app:publish-price` tourne

**Diagnostic:**
1. Vérifiez que Turbo est chargé (console F12)
2. Vérifiez que Mercure est accessible
3. Vérifiez l'URL du stream source

**Solutions:**
```bash
# Vérifier que Mercure est accessible
curl http://localhost:56427/.well-known/mercure

# Vérifier les logs du navigateur (F12 > Console)
# Chercher les erreurs de CORS ou Mercure

# Relancer la commande de publication
php bin/console app:publish-price
```

---

### 3. Erreur CORS (Cross-Origin)

**Erreur:** `Access to XMLHttpRequest blocked by CORS policy`

**Solution:** Assurez-vous que le `compose.yaml` inclut votre origine:

```yaml
MERCURE_EXTRA_DIRECTIVES: |
  cors_origins http://127.0.0.1:8000
  cors_origins http://localhost:8000
```

Puis:
```bash
docker-compose -f compose.yaml down
docker-compose -f compose.yaml up -d
```

---

### 4. Charger ressources CSS/JS

**Erreur:** Les styles ne s'appliquent pas, l'interface est très basique

**Solutions:**
```bash
# Regénérer les assets
npm run build

# Ou en mode watch
npm run watch

# Vérifier la console du navigateur pour les erreurs 404
```

---

### 5. Symfony serveur refuse la connexion

**Erreur:** `Connection refused` ou `404 Not Found`

**Solutions:**
```bash
# Démarrer le serveur Symfony
symfony serve
# ou
php bin/console server:run

# Accédez à
http://localhost:8000/dashboard

# Vérifier les logs
tail -f var/log/dev.log
```

---

### 6. La base de données n'est pas créée

**Erreur:** `Connection refused` ou SQL errors

**Solutions:**
```bash
# Créer la base de données
php bin/console doctrine:database:create

# Exécuter les migrations
php bin/console doctrine:migrations:migrate

# Vérifier la connexion
php bin/console doctrine:query:sql "SELECT 1"
```

---

### 7. Permissions insuffisantes (var/cache, var/log)

**Erreur:** `Permission Denied` sur des fichiers dans `var/`

**Solution sur Windows:**
```bash
# Donner les permissions au dossier var
icacls var /grant:r "%USERNAME%:(OI)(CI)F" /T

# Ou plus simplement, supprimer et regénérer
rmdir /s /q var\cache
rmdir /s /q var\log
```

---

### 8. PostgreSQL ne démarre pas

**Erreur:** `cannot start service database`

**Solutions:**
```bash
# Vérifier les logs
docker-compose -f compose.yaml logs database

# Supprimer les données persistantes et recommencer
docker-compose -f compose.yaml down -v
docker-compose -f compose.yaml up -d

# Attendre que PostgreSQL soit prêt
docker-compose -f compose.yaml exec database pg_isready
```

---

### 9. Hotloader/Asset watchaing ne fonctionne pas

**Problème:** Les changements CSS/JS n'apparaissent pas

**Solution:**
```bash
# Démarrer le watchaer d'assets
npm run watch

# Dans un autre terminal, le serveur Symfony
symfony serve
```

---

### 10. Le graphique Chart.js n'apparaît pas

**Symptômes:**
- Zone blanche ou manquante où devrait être le graphique

**Solutions:**
```javascript
// Ouvrir la console (F12) et vérifier
console.log(Chart); // Devrait afficher la classe Chart

// Si undefined, Chart.js n'a pas chargé
// Vérifier base.html.twig pour le script CDN

// Sinon, vérifier les erreurs console
```

---

## 📊 Commandes utiles

```bash
# Mercure
docker-compose -f compose.yaml up -d              # Démarrer
docker-compose -f compose.yaml down               # Arrêter
docker-compose -f compose.yaml logs -f mercure    # Voir les logs live

# Symfony
symfony serve                                     # Serveur dev
php bin/console app:publish-price                # Publier les prix
php bin/console doctrine:database:create         # Créer la DB
php bin/console doctrine:migrations:migrate      # Migrations

# Assets
npm run build                                     # Builder les assets
npm run watch                                     # Watcher les changements

# Docker
docker ps                                         # Voir les conteneurs actifs
docker-compose -f compose.yaml exec mercure bash  # CLI dans le conteneur
```

---

## 🔗 Checklist de démarrage

- [ ] PHP 8.2+ installé
- [ ] Docker & Docker Compose installés  
- [ ] `composer install` exécuté
- [ ] `npm install` exécuté
- [ ] `.env` configuré avec les bonnes URLs Mercure
- [ ] `docker-compose -f compose.yaml up -d` lancé
- [ ] Base de données créée et migée
- [ ] `symfony serve` ou serveur PHP lancé
- [ ] `php bin/console app:publish-price` lancé
- [ ] Dashboard accessible sur http://localhost:8000/dashboard

---

## 🆘 Besoin d'aide?

1. Vérifiez les logs:
   - Symfony: `var/log/dev.log`
   - Docker: `docker-compose logs`
   - Navigateur: F12 > Console

2. Consultez la documentation:
   - [Symfony Docs](https://symfony.com/doc)
   - [Mercure Docs](https://mercure.rocks/)
   - [Turbo Docs](https://turbo.hotwired.dev/)

3. Vérifiez le fichier README.md pour les instructions d'installation
