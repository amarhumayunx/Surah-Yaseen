# App Releases

This folder contains release builds of the Surah Yaseen Companion app.

## ⚠️ Important Note

**APK and iOS app files are large binary files (100MB+). GitHub has a 100MB file size limit for individual files.**

### Recommended Approach: GitHub Releases

Instead of committing these files directly to the repository, use **GitHub Releases**:

1. Go to your repository on GitHub
2. Click on "Releases" → "Create a new release"
3. Tag the release (e.g., `v1.0.0`)
4. Upload the APK and iOS app files as release assets
5. Add release notes describing the changes

### Alternative: Git LFS

If you need to store large files in Git, consider using **Git LFS (Large File Storage)**:

```bash
# Install Git LFS
brew install git-lfs  # macOS
# or download from https://git-lfs.github.com/

# Initialize Git LFS
git lfs install

# Track APK files
git lfs track "*.apk"
git lfs track "*.ipa"
git lfs track "*.aab"

# Add and commit
git add .gitattributes
git commit -m "Add Git LFS tracking for app files"
```

## 📱 Current Releases

### Android
- **Debug APK**: `android/app-debug.apk` (133MB)
- **Release APK**: To be built

### iOS
- **iOS App**: To be built

## 🔨 Building Release Versions

### Android Release APK
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Android App Bundle (AAB) - For Play Store
```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

### iOS Release
```bash
flutter build ios --release
# Then archive and export from Xcode
```

## 📝 Notes

- Debug builds are larger and not optimized
- Release builds are smaller and optimized for production
- Always test release builds before distributing
- Sign your apps properly for distribution

