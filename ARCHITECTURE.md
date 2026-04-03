# 🏗️ Architecture du Dashboard Temps Réel

## Vue d'ensemble

```
┌─────────────────┐
│   Navigateur    │  ← Affiche le dashboard
│   (Turbo + JS)  │  ← Écoute les Mercure updates
└────────┬────────┘
         │
         │ 1. WebSocket/SSE
         │ Topic: btc-data
         ▼
┌─────────────────────────────────────────┐
│           Mercure Hub                   │
│    (http://localhost:56427)             │
│  - Reçoit les updates du serveur        │
│  - Broadcast aux clients SSE            │
└──────────────▲──────────────────────────┘
               │
               │ 2. POST Update
               │   Topic: btc-data
               │   Payload: Turbo Stream HTML
               │
┌──────────────┴───────────┐
│   Symfony CLI            │
│ app:publish-price        │
│                          │
│ - Génère prix aléatoire  │
│ - Crée Update Mercure    │
│ - Publie toutes les 2s   │
└──────────────────────────┘
```

## Flux de données en temps réel

### 1️⃣ Publication (Serveur → Mercure)

```php
// src/Command/AppPublishPriceCommand.php

while (true) {
    $newPrice = rand(44000, 46000);
    
    // Créer un Update Mercure avec Turbo Stream
    $update = new Update(
        'btc-data',  // Topic
        sprintf(
            '<turbo-stream action="replace" target="btc-price"><template>%d</template></turbo-stream>',
            $newPrice
        )  // Payload HTML
    );
    
    // Publier via Mercure Hub
    $this->hub->publish($update);
    
    sleep(2);
}
```

### 2️⃣ Souscription (Navigateur → Mercure)

```html
<!-- templates/dashboard/index.html.twig -->

<div id="btc-price" 
     data-turbo-temporary-stream-source="{{ mercure_public_url }}?topic=btc-data">
    $45000
</div>
```

**Ce que cet élément fait:**
- Écoute le stream Mercure du topic `btc-data`
- Reçoit les Turbo Streams HTML du serveur
- Turbo remplace automatiquement le contenu de `#btc-price`

### 3️⃣ Mise à jour du graphique (Navigateur)

```javascript
// Détecter les changements du prix
const observer = new MutationObserver((mutations) => {
    mutations.forEach((mutation) => {
        const newPrice = parsePrice(mutation.target.textContent);
        if (newPrice > 0) {
            updatePrice(newPrice);  // Met à jour le graphique
        }
    });
});

observer.observe(priceElement, {
    childList: true,
    characterData: true,
    subtree: true
});
```

## Configuration Mercure

### Variables d'environnement

```env
# Pour la CLI (publication)
MERCURE_URL=http://localhost:56427/.well-known/mercure

# Pour le navigateur (souscription)
MERCURE_PUBLIC_URL=http://localhost:56427/.well-known/mercure

# Secret pour signer les JWT
MERCURE_JWT_SECRET="!ChangeThisMercureHubJWTSecretKey!"
```

### JWT (JSON Web Tokens)

Mercure utilise des JWT pour:
- **Publish**: Autoriser Symfony à envoyer des updates
- **Subscribe**: Autoriser les clients à recevoir des updates
- **Topic**: Contrôler qui peut se désabonner d'un topic

Actuellement configuré:
```yaml
publish: '*'     # La CLI peut publier sur n'importe quel topic
subscribe: '*'   # N'importe quel client peut souscrire
```

### CORS (Cross-Origin Resource Sharing)

```yaml
MERCURE_EXTRA_DIRECTIVES: |
  cors_origins http://127.0.0.1:8000
  cors_origins http://localhost:8000
```

Permet au navigateur sur `localhost:8000` de se connecter à Mercure sur `localhost:56427`.

## Turbo Streams

### Format HTML envoyé

```html
<turbo-stream action="replace" target="btc-price">
    <template>
        45231
    </template>
</turbo-stream>
```

**Attributs:**
- `action="replace"` - Remplace le contenu de l'élément cible
- `target="btc-price"` - L'ID de l'élément à remplacer
- `<template>` - Le nouveau contenu HTML

**Actions possibles:**
- `replace` - Remplace l'élément entier
- `update` - Met à jour le contenu uniquement
- `append` - Ajoute du contenu
- `prepend` - Ajoute du contenu au début
- `remove` - Supprime l'élément

## Avantages de cette architecture

✅ **Temps réel**: Mises à jour instantanées via Mercure  
✅ **Pas de rechargement**: Turbo met à jour sans rechargement page  
✅ **Scalable**: Mercure peut supporter plusieurs clients  
✅ **Stateless**: Pas de WebSocket tenu = moins de ressources serveur  
✅ **Simple**: Pas de framework JS lourd (React, Vue)  
✅ **Performant**: MutationObserver au lieu de polling  

## Cas d'usage futurs

### Ajouter d'autres cryptomonnaies

```php
// Publier plusieurs topics
$topics = ['btc-data', 'eth-data', 'xrp-data'];

foreach ($topics as $topic => $price) {
    $update = new Update(
        $topic,
        sprintf(
            '<turbo-stream action="replace" target="%s"><template>%d</template></turbo-stream>',
            $topic,
            $price
        )
    );
    $this->hub->publish($update);
}
```

### Ajouter des notifications

```html
<div data-turbo-temporary-stream-source="{{ mercure_public_url }}?topic=notifications">
    <!-- Les notifications arrivent ici dynamiquement -->
</div>
```

### Authentification utilisateur

```php
// Restreindre les topics par utilisateur
$allowedTopics = $user->getSubscribedTopics();
$jwt = $this->mercureAuthorizationProvider->getJwt($allowedTopics);

// Dans le template
{# Seulement les utilisateurs authentifiés reçoivent les updates #}
<div data-turbo-temporary-stream-source="{{ mercure_public_url }}?authorization=Bearer{{ jwt }}">
```

## Performance et optimisations

### Points sur le graphique
- Limité à 30 points pour éviter le lag du navigateur
- À 1 update/2s, 30 prix = 60 secondes d'historique
- Chart.js update() très rapide avec un petit dataset

### Fréquence des updates
- Actuellement: 1 prix toutes les 2 secondes
- Peut être augmenter/diminuer selon les besoins
- Mercure supporte des milliers de messages par seconde

### Latence
- Mercure SSE: ~50-100ms latence
- Turbo Stream: Remplacenment instant
- Graphique update: <100ms avec 30 points

## Dépannage

| Problème | Cause | Solution |
|----------|-------|----------|
| Prix ne met pas à jour | Mercure hors ligne | `docker-compose restart mercure` |
| CORS error | CORS_origins manquant | Ajouter l'origine dans compose.yaml |
| Graphique lag | Trop de points | Réduire à <30 points |
| Pas de connexion Mercure | Firewall/proxy | Vérifier localhost:56427 |

## Références

- 📖 [Mercure Documentation](https://mercure.rocks/)
- 📖 [Turbo Documentation](https://turbo.hotwired.dev/)
- 📖 [Symfony Mercure Bundle](https://symfony.com/doc/current/messenger.html)
