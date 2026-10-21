# Orange Jordan - O-Trip Mobile Application

Official cross-platform mobile application for the Orange Jordan Executive Trip, built using Flutter for Android and iOS.

---

## 1. Overview & Architecture

- **Framework:** Flutter 3.24+ (Dart 3.5+)
- **Platforms:** Android (minSdkVersion 21) & iOS (iOS 12.0+)
- **Design System:** Orange Brand Design System (RTL Arabic & LTR English)
- **Local Storage:** `flutter_secure_storage` for encrypted token and session caching
- **Networking:** Secure REST HTTP client connecting to OrangeTrip.API backend

---

## 2. Prerequisites

- Flutter SDK (version 3.24 or higher)
- Android SDK / Xcode for platform builds
- Active backend API endpoint

---

## 3. Environment & API Configuration

Configure the backend API base URL in `lib/core/constants/api_constants.dart` or via compile-time environment variables:

```bash
flutter run --dart-define=API_BASE_URL=http://<BACKEND_HOST>:5000/api
```

---

## 4. Setup and Run

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Run Test Suite
```bash
flutter test
```

### 3. Launch Application (Development)
```bash
flutter run
```

---

## 5. Production Builds

### Android Release APK:
```bash
flutter build apk --release
```
Output path:
`build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle (for Play Store):
```bash
flutter build appbundle --release
```

### iOS Release Build:
```bash
flutter build ipa --release
```
