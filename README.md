# Align! (Flutter)

Technical test project: Tic Tac Toe / Align game.

## Features
- Board sizes: 3x3, 4x4, 5x5
- PvE (bot), PvP local, PvP online
- Firebase Auth (email/password) + multi-step signup
- Profile stored in Firestore: `users/{uid}`
- GoRouter with auth-aware redirects + onboarding (profile required)
- Riverpod state management
- UI polish (animations, confetti, etc.)

## Setup
- Create a Firebase project
- Enable Email/Password auth
- Add iOS/Android/Web apps
- Add firebase config files:
  - Android: `android/app/google-services.json`
  - iOS: `ios/Runner/GoogleService-Info.plist`

## Run
```bash
flutter pub get
flutter run