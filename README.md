# Live Crypto Dashboard

Un dashboard de prix Bitcoin en temps réel créé avec Symfony, Turbo, et Mercure.

## 🎯 Caractéristiques

- ✨ **Mise à jour en temps réel** - Utilisé Mercure SSE pour les mises à jour instantanées
- 📊 **Graphique dynamique** - Affichage Chart.js de l'évolution des prix
- 🎨 **Interface moderne** - Design attrayant avec Bootstrap et animations
- 📈 **Statistiques** - Prix min/max/moyen et compteur de mises à jour
- 🔄 **Actualisations fluides** - Turbo Streams pour une navigation sans rechargement

## 🚀 Démarrage rapide

### Prérequis

- PHP 8.2+
- Composer
- Docker & Docker Compose (pour Mercure)
- Node.js/npm (pour les assets)

### Installation

1. **Clonez et installez les dépendances**

```bash
cd dashboard_live
composer install
npm install
```

2. **Configurez l'environnement**

Vérifiez que le fichier `.env` contient:

```env
APP_ENV=dev
MERCURE_URL=http://localhost:56427/.well-known/mercure
MERCURE_PUBLIC_URL=http://localhost:56427/.well-known/mercure
MERCURE_JWT_SECRET="!ChangeThisMercureHubJWTSecretKey!"
```

3. **Démarrez Mercure Server**

```bash
docker-compose -f compose.yaml up -d
```

Vous verrez une sortie similaire:

```
mercure  | 🛜 SERVER Listening on http://localhost:56427
```

4. **Démarrez le serveur Symfony**

Dans un terminal:

```bash
symfony serve
```

Ou avec PHP directement:

```bash
php bin/console server:run
```

5. **Démarrez la commande de publication des prix**

Dans un autre terminal:

```bash
php bin/console app:publish-price
```

Cette commande publie des prix BTC simulés toutes les 2 secondes via Mercure.

6. **Accédez au dashboard**

Ouvrez votre navigateur et allez à:

```
http://localhost:8000/dashboard
```

## 🎮 Utilisation

Une fois le dashboard chargé:

- **Prix en direct** - Le prix BTC s'affiche au centre en gros caractères
- **Graphique** - Scroll down pour voir le graphique de 30 derniers prix
- **Statistiques** - Consultez min/max/moyenne en temps réel
- **Pourcentage de changement** - Voyez si le prix monte ou baisse avec l'indicateur

## 📁 Structure du projet

```
src/
├── Command/
│   └── AppPublishPriceCommand.php    # Publie les prix via Mercure
├── Controller/
│   └── DashboardController.php       # Rend le dashboard
└── Entity/                           # Entités (DB)

templates/
├── base.html.twig                    # Template de base Symfony
└── dashboard/
    └── index.html.twig               # Template principal du dashboard

assets/
├── app.js                            # JS principal
├── controllers/
│   └── price_tracker.js              # Gestion des mises à jour
└── styles/
    └── app.css                       # Styles globaux
```

## 🔧 Configuration Mercure

### Pour la production

1. Changez `MERCURE_JWT_SECRET` en une vraie clé secrète
2. Configurez les URLs publiques correctement
3. Utilisez HTTPS
4. Limitez les topics et les souscripteurs

### Dépannage

**Mercure ne démarre pas?**
```bash
docker-compose -f compose.yaml logs mercure
```

**Pas de mise à jour du prix?**
- Vérifiez que `composer run app:publish-price` est lancé
- Vérifiez la console du navigateur (F12) pour les erreurs
- Vérifiez que Mercure est accessible sur le port 56427

**Les prix ne s'affichent pas?**
- Vérifiez que Turbo est chargé (sans erreurs jQuery/Bootstrap)
- Vérifiez que l'URL Mercure est correcte dans l'attribut `data-turbo-temporary-stream-source`

## 💡 Améliorations futures

- [ ] Ajouter d'autres cryptomonnaies (ETH, XRP, etc.)
- [ ] Persister les prix en base de données
- [ ] Ajouter des indicateurs techniques (RSI, MACD)
- [ ] Authentification utilisateur
- [ ] Notifications d'alertes
- [ ] Historique et exports

## 📚 Documentation

- [Symfony](https://symfony.com/doc/current/index.html)
- [Mercure](https://mercure.rocks/)
- [Turbo](https://turbo.hotwired.dev/)
- [Chart.js](https://www.chartjs.org/)

## 📝 Licence

MIT

## 👥 Support

En cas de problème, consultez les logs:

```bash
# Logs Symfony
tail -f var/log/dev.log

# Logs Mercure
docker-compose logs mercure -f
```
