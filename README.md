# 📖 Surah Yaseen Companion

<div align="center">

**✨ Read. Listen. Reflect. Remember. ✨**

*A spiritually enriching Flutter app to engage with Surah Yaseen - the heart of the Qur'an* 🕌

[![Flutter](https://img.shields.io/badge/Flutter-3.7+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey)](https://www.apple.com/ios/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

</div>

---

## 📱 About

**Surah Yaseen Companion** is a beautiful, modern mobile application built with Flutter that helps you connect with Surah Yaseen through structured reading, audio playback, translations, and spiritual insights. Experience the heart of the Qur'an with ease and elegance.

### 🎯 Key Highlights

- 📖 **Ruku-wise Reading** - Navigate through 5 structured Rukus
- 🎧 **Audio Playback** - Listen to beautiful recitations with synchronized highlighting
- 🔖 **Smart Bookmarking** - Save your favorite verses and Rukus
- 🌍 **Multi-language** - Support for English and Urdu
- 🎨 **Beautiful UI** - Modern, clean design with Arabic typography
- ⚙️ **Customizable** - Adjustable font sizes and settings
- 🔔 **Notifications** - Daily reminders for spiritual practice
- 📱 **Cross-platform** - Works seamlessly on Android and iOS

---

## ✨ Features

### 📚 Reading Experience
- ✨ **Ruku-by-Ruku Navigation** - Easy navigation through all 5 Rukus
- 📝 **Translations** - Clear translations for better understanding
- 🔤 **Arabic Typography** - Beautiful Lateef font for authentic reading
- 📏 **Adjustable Font Size** - Customize reading experience
- 🌙 **Smooth Scrolling** - Fluid navigation through verses

### 🎵 Audio Features
- 🎧 **High-Quality Recitation** - Crystal clear audio playback
- 🎯 **Verse Highlighting** - Synchronized highlighting during playback
- ⏯️ **Playback Controls** - Play, pause, and navigate audio
- 🔄 **Auto-scroll** - Automatically scrolls with recitation

### 🔖 Bookmarking
- 📌 **Save Verses** - Bookmark any verse or Ruku
- 📋 **Organized Bookmarks** - Manage all saved content easily
- 🔍 **Quick Access** - Jump to bookmarked verses instantly
- 🗑️ **Manage Bookmarks** - Delete or organize saved items

### ⚙️ Settings & Customization
- 🌐 **Language Selection** - Switch between English and Urdu
- 📱 **Font Size Control** - Adjust text size for comfortable reading
- 🔔 **Notification Settings** - Customize daily reminders
- 💾 **Offline Access** - Read and listen without internet

### 🎨 User Experience
- 🚀 **Onboarding** - Beautiful introduction to app features
- 🏠 **Intuitive Navigation** - Easy-to-use bottom navigation
- 🎯 **Splash Screen** - Elegant app launch experience
- 📊 **Help & About** - Comprehensive app information

---

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev) 3.7+
- **State Management**: GetX, Provider
- **Local Storage**: Hive, SharedPreferences, GetStorage
- **Audio**: Just Audio, Flutter TTS, Audio Session
- **UI Components**: Material Design, Custom Widgets
- **Notifications**: Flutter Local Notifications
- **Navigation**: GetX Navigation
- **Localization**: GetX Translations

---

## 📦 Installation

### Prerequisites

- Flutter SDK (3.7.2 or higher)
- Dart SDK
- Android Studio / Xcode (for platform-specific development)
- An IDE (VS Code / Android Studio)

### Clone the Repository

```bash
git clone https://github.com/yourusername/Surah-Yaseen.git
cd Surah-Yaseen
```

### Install Dependencies

```bash
flutter pub get
```

### Generate Code (if needed)

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Run the App

```bash
# For Android
flutter run

# For iOS
flutter run -d ios

# For Web
flutter run -d chrome
```

---

## 📱 Screenshots

> *Coming soon - Add your app screenshots here!*

---

## 🏗️ Project Structure

```
lib/
├── bookmark.dart              # Bookmark model
├── main.dart                  # App entry point
├── Colors/                    # Color constants
├── constants/                 # App strings and assets
├── controllers/               # State controllers
├── menu/                      # Navigation components
├── screens/                   # App screens
│   ├── HomeScreen.dart
│   ├── RukuScreen.dart
│   ├── BookmarkScreen.dart
│   ├── SettingScreen.dart
│   └── ...
├── services/                  # App services
│   └── notification_service.dart
└── widgets/                   # Reusable widgets
    ├── HomeScreen/
    ├── BookmarkScreen/
    └── ...
```

---

## 🎯 Key Screens

- 🏠 **Home Screen** - Main dashboard with quick access to all features
- 📖 **Ruku Screens** - Individual screens for each of the 5 Rukus
- 🎧 **Audio Player** - Audio playback with translation
- 🔖 **Bookmarks** - Saved verses and Rukus
- ⚙️ **Settings** - App preferences and customization
- 📚 **Library** - Browse all Rukus
- ℹ️ **About & Help** - App information and guidance

---

## 🔧 Configuration

### Fonts

The app uses **Lateef** font family for Arabic text, located in `assets/fonts/`.

### Assets

- **Icons**: `assets/images/icons/`
- **Illustrations**: `assets/images/illustrations/`
- **Fonts**: `assets/fonts/`

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. 

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Spiritual Note

> *This project is created with the intention of providing a means for people to connect with the Qur'an. May it be a source of continuous benefit (Sadaqah Jariyah) and may Allah accept our efforts. Ameen.* 🤲

---

## 👨‍💻 Developer

**Your Name**

- GitHub: [@yourusername](https://github.com/yourusername)
- Email: your.email@example.com

---

## 📞 Support

If you have any questions, suggestions, or feedback, please feel free to:
- 📧 Open an issue on GitHub
- 💬 Create a discussion thread
- 📱 Contact the developer

---

## 🌟 Acknowledgments

- All the scholars and reciters who made this content available
- The Flutter community for amazing tools and packages
- Lateef font creators for beautiful Arabic typography
- All contributors and testers

---

## ⭐ Show Your Support

If you find this project helpful, please give it a ⭐ on GitHub!

---

<div align="center">

**Made with ❤️ and Flutter**

*May this app be a source of guidance and blessing* 🌙✨

</div>
