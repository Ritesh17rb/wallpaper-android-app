# 📱 Wallpaper App

### 🎬 App Preview

<p align="center">
  <img src="assets/App video.gif" width="300" alt="App Demo">
</p>

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-2.18+-0175C2?logo=dart)
![License](https://img.shields.io/badge/License-MIT-green)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-blue)

**Flutter • Pexels API • Masonry Grid • Offline Favorites • Gallery Save**

A beautifully designed Pinterest-style wallpaper application built with Flutter, featuring smooth animations, HD wallpapers via Pexels API, downloads, sharing, and offline favorites using Hive.

---

## 🔗 Live App & Demo

📥 **Download APK**  
👉 [Download from Google Drive](https://drive.google.com/file/d/1PDW5XTKJjfeSA9Lh0aKfBa0XUrtn6vQ6/view?usp=sharing)

🎥 **Watch Demo Video**  
👉 [Watch on Google Drive](https://drive.google.com/file/d/1j3ZMi81fUMudTsOqyMtanuycXwQSVUgQ/view?usp=drivesdk)

### 🎬 App Preview

<p align="center">
  <img src="assets/App video.gif" width="300" alt="App Demo">
</p>
---

## 🌟 Features

### 🖼️ HD Wallpapers (Pexels API)
- ✨ Trending wallpapers
- 📜 Infinite scroll
- 🎬 Fullscreen viewer
- 🔍 Image zoom + pinch gestures

### 🧱 Masonry Grid (Pinterest-style)
- 🎨 Modern staggered grid layout
- 🦸 Smooth hero transitions
- ⚡ Lazy loading with caching

### ❤️ Favorites
- 💾 Save wallpapers locally (Hive)
- 📴 Offline support
- 🔄 Persistent across app restarts

### 📥 Download & Gallery Save
- 💿 Save images using Gal plugin
- 📁 Saves in a custom "Wallpapers" album
- 🔐 Handles permissions automatically

### 🔗 Share
- 📤 Share wallpapers via WhatsApp, Instagram, Messenger, etc.

---

## 📸 Screenshots

<p align="center">
  <img src="assets/screenshots/home.jpg" width="250">
  <img src="assets/screenshots/fullscreen.jpg" width="250">
</p>

*(Add your screenshots in `/assets/screenshots/` then reference them here)*

---

## 🚀 Tech Stack

| Layer | Technology |
|-------|-----------|
| **Framework** | Flutter 3.x |
| **Language** | Dart |
| **API** | Pexels Wallpapers REST API |
| **UI** | Staggered Grid, Hero Animations, PhotoView |
| **Storage** | Hive NoSQL |
| **Networking** | Dio |
| **Gallery Save** | Gal |
| **Sharing** | share_plus |

---

## 🛠️ Installation & Setup

### 1️⃣ Clone the repository

```bash
git clone https://github.com/YOUR_USERNAME/wallpaper_app.git
cd wallpaper_app
```

### 2️⃣ Install dependencies

```bash
flutter pub get
```

### 3️⃣ Add your Pexels API key

Create `/lib/config/api_keys.dart`:

```dart
class ApiKeys {
  static const pexelsApiKey = "YOUR_PEXELS_API_KEY";
}
```

Get your free API key here: 🔗 [https://www.pexels.com/api/](https://www.pexels.com/api/)

---

## 📂 Folder Structure

```
lib/
 ├── main.dart
 ├── pages/
 │    ├── home_page.dart
 │    ├── full_screen_page.dart
 ├── services/
 │    ├── pexels_api.dart
 ├── widgets/
 ├── config/
 │    └── api_keys.dart
assets/
 ├── icon.png
 └── screenshots/
android/
ios/
web/
```

---

## 🧱 API Example (Pexels)

```dart
final response = await Dio().get(
  "https://api.pexels.com/v1/search?query=wallpaper&per_page=80",
  options: Options(headers: {
    "Authorization": ApiKeys.pexelsApiKey,
  }),
);
```

---

## 🧪 Run the App

**Chrome (Web):**
```bash
flutter run -d chrome
```

**Android:**
```bash
flutter run
```

---

## 📦 Build APK

```bash
flutter build apk --release
```

APK location:
```
build/app/outputs/flutter-apk/app-release.apk
```

**Build AAB (Play Store)**
```bash
flutter build appbundle --release
```

---

## ❗ Troubleshooting

### Gallery save not working?

Add permissions in `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"
    android:maxSdkVersion="32" />
```

### Build errors with dependencies?

```bash
flutter clean
flutter pub get
flutter build apk --release
```

---

## 🤝 Contributing

Pull requests are welcome! If you have ideas for new features, feel free to open an issue.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## ⭐ Support the Project

If you like this project, please ⭐ **star the repository** — it motivates further development!

---

## 📜 License

```
MIT License © 2025 Ritesh
```

---

## 👨‍💻

**Ritesh**  
🔗 [GitHub](https://github.com/ritesh17rb)  
🔗 [LinkedIn](https://www.linkedin.com/in/ritesh17rb/)  
📧 ritesh17lifeamazing@gmail.com

---

<p align="center">Made with ❤️</p>
