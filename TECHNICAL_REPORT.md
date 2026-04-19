# Rapport Technique — Application Mobile IoT/AIoT

## 1. Introduction
Ce rapport présente le projet Flutter `iot_mobile_app`, développé pour simuler un scénario IoT/AIoT mobile. L’application collecte et affiche des données de capteurs, les stocke localement avec SQLite, et propose une interface utilisateur multilingue et moderne.

## 2. Objectifs du projet
- Concevoir une application mobile hybride intelligente.
- Simuler des données de capteurs (température, humidité, etc.).
- Stocker les lectures localement dans une base SQLite.
- Proposer un tableau de bord avec alertes visuelles et seuils critiques.
- Prévoir des fonctionnalités de configuration et de thème.
- Intégrer une API externe IoT en option.
- Préparer le projet pour publication sur un store mobile.

## 3. Technologies choisies
- **Flutter & Dart**
- **SQLite** via `sqflite`
- **OpenWeatherMap API** pour données météo externalisées
- **HTTP** via `package:http`
- **Internationalisation** via `flutter_localizations` et `intl`
- **Architecture propre** avec séparation Data / Domain / Presentation

## 4. Architecture du projet
### 4.1 Couches principales
- **Data**
  - `lib/features/sensor/data/weather_service.dart`
  - `lib/features/sensor/data/sensor_local_db.dart`
  - `lib/features/sensor/data/sensor_repository_impl.dart`
  - `lib/features/sensor/data/settings_repository.dart`
- **Domain**
  - `lib/features/sensor/domain/repositories/weather_repository.dart`
  - `lib/features/sensor/domain/repositories/weather_repository_impl.dart`
- **Presentation**
  - `lib/features/sensor/presentation/pages/dashboard/enhanced_dashboard_page.dart`
  - `lib/features/sensor/presentation/pages/settings_page.dart`
  - `lib/features/sensor/presentation/pages/sensor_history_page.dart`
  - `lib/features/sensor/presentation/widgets/enhanced_weather_card.dart`

### 4.2 Fonctionnalités clefs implémentées
- `WeatherService` avec cache et retry
- Stockage SQLite pour lectures de capteurs
- Lecture et affichage de l’historique
- Page de paramètres pour seuil de critique et thème
- Widget de tableau de bord avec alertes visuelles
- Mode sombre / clair

## 5. Fonctionnalités requises et état
| Fonctionnalité | Statut | Commentaire |
|---|---|---|
| Afficher valeurs capteur en temps réel | ✅ | Dashboard met à jour toutes les 30 secondes |
| Alertes critiques visuelles | ✅ | Alerte rouge lorsque la température dépasse le seuil |
| Sauvegarde SQLite | ✅ | `sensor_data` et `app_settings` stockés localement |
| Consultation historique | ✅ | Page dédiée `SensorHistoryPage` |
| Simulation IA / AIoT | ✅ | Prédiction de température via régression linéaire, détection d'anomalies, analyse de tendance, recommandation de seuils dynamiques |
| Modification de seuils | ✅ | Page `SettingsPage` |
| Thème clair/sombre | ✅ | `themeMode` sauvegardé en SQLite |
| Intégration API externe | ✅ | OpenWeatherMap via `WeatherService` |
| Authentification utilisateur | ✅ | Écran de connexion avec validation email/mot de passe, stockage état avec SharedPreferences, bouton déconnexion |

## 6. Détails techniques
### 6.1 Stockage SQLite
- Table `sensor_data` : `id`, `temperature`, `humidity`, `timestamp`
- Table `app_settings` : `key`, `value`
- Repository de configuration à travers `SettingsRepository`

### 6.2 Gestion des paramètres
- `SettingsModel` contient `threshold` et `themeMode`
- `SettingsRepository` lit et écrit les préférences dans SQLite
- `SettingsPage` permet la modification par l’utilisateur

### 6.3 Dashboard
- `EnhancedDashboardPage` : affichage météo, alertes, graphiques et statistiques
- Lecture auto actualisée toutes les 30 secondes
- Sauvegarde automatique de chaque lecture dans SQLite
- Simulation de lecture locale si l’API réseau échoue
### 6.4 Intelligence Artificielle (AIoT)
- `AIService` : service d'analyse prédictive utilisant les données historiques
- **Prédiction de température** : régression linéaire sur les 10 dernières lectures pour estimer la valeur suivante
- **Détection d'anomalies** : calcul du score Z (>2 écarts-types) pour identifier les valeurs aberrantes
- **Analyse de tendance** : comparaison des moyennes mobiles pour détecter hausse/baisse/stable
- **Recommandation de seuils** : ajustement automatique basé sur l'historique (moyenne +5°C, max-2°C)
- Affichage en temps réel sur le dashboard avec indicateurs visuels

### 6.5 Authentification
- `AuthModel` : modèle de données pour email/mot de passe avec validation
- `AuthService` : gestion de l'état de connexion via SharedPreferences
- `LoginPage` : écran de connexion avec formulaire, validation et gestion d'erreurs
- Authentification mock (mot de passe "password123" pour tout email)
- Navigation conditionnelle : LoginPage si non connecté, Dashboard sinon
- Bouton déconnexion dans l'AppBar du dashboard
## 7. Instructions de déploiement
### 7.1 Installation
1. Cloner le projet
2. Ouvrir le dossier dans VS Code
3. Exécuter `flutter pub get`
4. Lancer sur un simulateur ou un appareil réel

### 7.2 Génération APK / AAB
- `flutter build apk --release`
- `flutter build appbundle --release`

### 7.3 Publication Amazon Appstore
- Créer un compte développeur Amazon
- Préparer captures d’écran et fiche descriptive
- Charger le fichier AAB / APK généré

## 8. Points d’amélioration
- Intégrer TensorFlow Lite pour des modèles IA plus avancés (classification d'images, prédictions complexes)
- Ajouter des alertes de mouvement ou consommation énergétique
- Synchronisation distante (Firebase, Supabase, backend IoT)
- Améliorer la gestion des erreurs et le retour utilisateur

## 9. Conclusion
L’application est en bon chemin pour couvrir le cahier des charges IoT/AIoT. Les fonctions de base sont implémentées, avec une architecture propre et un stockage local opérationnel. Il reste à finaliser le déploiement et à enrichir le comportement IA pour un scénario plus complet.
