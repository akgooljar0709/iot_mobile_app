# Firebase Setup Guide

This guide will help you set up Firebase Authentication for the IoT Weather Monitor app.

## Prerequisites

- A Google account
- Flutter project with Firebase dependencies installed

## Step 1: Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project" or select an existing project
3. Enter your project name (e.g., "iot-weather-monitor")
4. Follow the setup wizard to create your project

## Step 2: Enable Authentication

1. In your Firebase project, go to "Authentication" in the left sidebar
2. Click on the "Get started" button
3. Go to the "Sign-in method" tab
4. Enable "Email/Password" sign-in method
5. Click "Save"

## Step 3: Configure Your App

### Option A: Using FlutterFire CLI (Recommended)

1. Install FlutterFire CLI:
   ```bash
   dart pub global activate flutterfire_cli
   ```

2. Login to FlutterFire:
   ```bash
   flutterfire login
   ```

3. Configure your app:
   ```bash
   flutterfire configure --project=<your-project-id>
   ```

   This will automatically:
   - Generate `lib/firebase_options.dart` with your configuration
   - Add platform-specific configuration files

### Option B: Manual Configuration

1. In Firebase Console, click the gear icon → "Project settings"
2. Scroll down to "Your apps" section
3. Click "Add app" and select your platform (Android/iOS/Web)

#### For Android:
1. Download `google-services.json`
2. Place it in `android/app/`
3. Update `lib/firebase_options.dart` with your Android config

#### For iOS:
1. Download `GoogleService-Info.plist`
2. Place it in `ios/Runner/`
3. Update `lib/firebase_options.dart` with your iOS config

## Step 4: Update Firebase Options

Edit `lib/firebase_options.dart` and replace the placeholder values with your actual Firebase configuration:

```dart
class DefaultFirebaseOptions {
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'your-actual-android-api-key',
    appId: 'your-actual-android-app-id',
    messagingSenderId: 'your-sender-id',
    projectId: 'your-project-id',
    storageBucket: 'your-project-id.appspot.com',
  );

  // Similarly for iOS, web, etc.
}
```

## Step 5: Test the Setup

1. Run your app:
   ```bash
   flutter run
   ```

2. Try creating a new account with a valid email and password
3. Verify that authentication works by logging in and out

## Troubleshooting

### Common Issues:

1. **"FirebaseException: [core/no-app] No Firebase App '[DEFAULT]' has been created"**
   - Make sure Firebase is initialized in `main.dart`
   - Check that `firebase_options.dart` has correct values

2. **"PlatformException: [firebase_auth/invalid-api-key]"**
   - Verify your API key in `firebase_options.dart`
   - Check that you've enabled Authentication in Firebase Console

3. **Build fails after adding Firebase**
   - Run `flutter clean` and `flutter pub get`
   - Check that all platform-specific files are in place

### Getting Your Firebase Config:

1. Go to Firebase Console → Project Settings → General
2. Scroll to "Your apps" section
3. Click on your app to see the configuration values

## Security Rules

For production apps, consider setting up Firestore Security Rules and Firebase Security Rules to protect your data.

## Next Steps

- Consider adding additional authentication methods (Google Sign-In, etc.)
- Set up Firebase Crashlytics for error reporting
- Configure Firebase Analytics for user behavior tracking</content>
<parameter name="filePath">c:\Users\DELL\Desktop\TP4\Assignment\iot_mobile_app\FIREBASE_SETUP.md