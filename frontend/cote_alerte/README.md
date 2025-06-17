# Côte Alerte

## Description
Côte Alerte est une application mobile développée avec Flutter qui permet de surveiller et d'alerter les utilisateurs sur les conditions côtières. L'application utilise des technologies avancées comme la détection d'objets via Roboflow pour analyser les conditions maritimes.

## Fonctionnalités
- 📍 Géolocalisation en temps réel
- 📸 Capture et analyse d'images
- 🗺️ Intégration de cartes interactives
- 🔔 Système d'alertes personnalisées
- 💾 Stockage local des données
- 📱 Interface utilisateur intuitive

## Prérequis
- Flutter SDK (version ^3.7.2)
- Dart SDK
- Android Studio / Xcode (pour le développement)
- Un appareil Android/iOS ou un émulateur

## Installation

1. Clonez le dépôt :
```bash
git clone [URL_DU_REPO]
cd cote_alerte
```

2. Installez les dépendances :
```bash
flutter pub get
```

3. Configurez la clé API Roboflow :
   - Créez un fichier `lib/config/api_config.dart`
   - Ajoutez votre clé API Roboflow

4. Lancez l'application :
```bash
flutter run
```

## Dépendances principales
- `flutter_map` : ^5.0.0 - Pour l'affichage des cartes
- `geolocator` : ^10.0.0 - Pour la géolocalisation
- `camera` : ^0.10.5+3 - Pour l'accès à la caméra
- `sqflite` : ^2.3.2 - Pour le stockage local
- `http` : ^1.1.0 - Pour les requêtes réseau et l'intégration avec Roboflow
- `shared_preferences` : ^2.2.2 - Pour le stockage des préférences
- `permission_handler` : ^10.4.0 - Pour la gestion des permissions

## Structure du projet
```