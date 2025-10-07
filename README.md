
# Inventory Scanner (Flutter) Updated

A cross‑platform Flutter app for scanning product barcodes, managing scanned items, and exporting/sharing results. It includes Firebase authentication (Email/Password and Google Sign‑In), a simple product details view, and CSV export.

---

## ✨ Features

- **Barcode/QR Scanning** using the device camera (via `flutter_barcode_scanner`).
- **Auth** with Firebase: Email/Password and **Google Sign‑In**.
- **Scanned List & Export**: review items and **export to CSV**; share files.
- **Product Details** lightweight view for a scanned/selected item.
- **Persistent state** with `shared_preferences`.
- **Icon‑rich UI** using SVG assets.
- **Multi‑platform** targets: Android, iOS, Web, Windows, macOS, Linux (Flutter).

---

## 🗂️ Project Structure (key parts)

```
lib/
  components/              # Reusable UI widgets
  screens/
    Camera_Screen/         # CameraPage.dart — scan barcodes
    Export_Page/           # ListPage.dart — list & export CSV
    product_details/       # ProductDetailsPage.dart
    sign_in/               # Auth screens & forms
    splash/                # Splash flow
    forgot_password/       # Forgot password flow
  constants.dart           # UI constants
  firebase_options.dart    # Firebase options (FlutterFire)
  main.dart                # App entry
  routs.dart               # Route definitions
  size_config.dart         # Responsive sizing helpers
  theme.dart               # App theme
assets/icons/              # SVG icons used throughout the UI
android/ios/macos/linux/windows/web/  # Platform scaffolding & configs
```

---

## 🧰 Tech Stack

- **Flutter** (Dart >= 3.2.5)
- **Packages**: `flutter_barcode_scanner`, `provider`, `shared_preferences`, `csv`, `path_provider`, `share`, `http`, `firebase_core`, `firebase_auth`, `google_sign_in`, `flutter_svg`, `sign_in_button`
- **Firebase** (Auth)

> See `pubspec.yaml` for exact versions.

---

## 🔧 Prerequisites

- Flutter (stable) 3.x installed & configured
- A Firebase project with **Authentication** enabled
  - Providers: **Email/Password** and **Google**
- Platform SDKs as needed (Android Studio / Xcode, etc.)

---

## ⚙️ Setup

1. **Clone & fetch packages**
   ```bash
   git clone <YOUR_REPO_URL>.git
   cd <repo>
   flutter pub get
   ```

2. **Configure Firebase** (per platform)

   - **Android**
     - Place your `android/app/google-services.json`.
     - Confirm `classpath 'com.google.gms:google-services:4.4.1'` in `android/build.gradle` and `apply plugin: 'com.google.gms.google-services'` in `android/app/build.gradle` (already present).
     - Package name: `ml.sivasai.inventory_scanner` (change if you rename).

   - **iOS / macOS**
     - Place `ios/Runner/GoogleService-Info.plist` and `macos/Runner/GoogleService-Info.plist` (if using macOS).
     - In **Xcode** add URL Types with **REVERSED_CLIENT_ID** from the plist for Google Sign‑In.

   - **Web**
     - If using `flutterfire configure`, ensure `firebase_options.dart` includes Web config.

3. **Permissions**
   - **Camera** is required for scanning.
     - Android: most camera permissions are handled by the scanner plugin; ensure minSdk/targets are compatible.
     - iOS: add camera usage description to `Info.plist` if not present:
       ```xml
       <key>NSCameraUsageDescription</key>
       <string>We use the camera to scan barcodes.</string>
       ```

4. **Run**
   ```bash
   # Choose a device or emulator first
   flutter run
   ```

---

## ▶️ How to Use

1. **Sign In** with Email/Password or **Continue with Google**.
2. Open **Scan** (Camera) to scan a product barcode/QR.
3. Review the **List**; tap an item for **Details**.
4. Use **Export** to generate a **CSV** and **Share** it.

---

## 🧪 Helpful Commands

```bash
flutter clean && flutter pub get        # reset deps
flutter analyze                         # static analysis
flutter test                            # run tests (if any are added)
flutter build apk --release             # Android
flutter build ios --release             # iOS (requires codesigning setup)
flutter build web                       # Web
flutter build macos / linux / windows   # Desktop targets
```

---

## 📦 Notable Files

- `lib/screens/Camera_Screen/CameraPage.dart` — core scanning screen
- `lib/screens/Export_Page/ListPage.dart` — list + export/CSV
- `lib/screens/product_details/ProductDetailsPage.dart` — details view
- `lib/screens/sign_in/*` — sign‑in UI and forms
- `android/app/google-services.json` & `ios/Runner/GoogleService-Info.plist` — Firebase configs
- `pubspec.yaml` — dependencies & assets

---

## 🛡️ Notes / Security

- Do **not** commit your production Firebase files (`google-services.json`, `GoogleService-Info.plist`) publicly.
- Rotate any leaked API keys and restrict them in the Firebase console.


