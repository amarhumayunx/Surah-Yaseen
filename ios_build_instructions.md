# iOS App Build aur Upload Instructions

## Prerequisites

1. **Apple Developer Account** (Free ya Paid)
2. **Xcode** installed
3. **Development Team** setup in Xcode

## Step 1: Xcode mein Signing Setup

1. Xcode project open karein:
   ```bash
   open ios/Runner.xcworkspace
   ```

2. Xcode mein:
   - Left sidebar mein "Runner" project select karein
   - "Runner" target select karein
   - "Signing & Capabilities" tab par jayein
   - "Automatically manage signing" checkbox enable karein
   - "Team" dropdown se apna Apple Developer account select karein
   - Agar account nahi hai, "Add Account" se Apple ID add karein

3. Bundle Identifier unique hona chahiye (agar error aaye to change karein)

## Step 2: Archive Build

### Option A: Xcode se (Recommended)

1. Xcode mein:
   - Top bar mein device "Any iOS Device" select karein
   - Menu: **Product → Archive**
   - Archive complete hone ka wait karein

2. Organizer window open hoga:
   - Archive select karein
   - "Distribute App" click karein
   - "Ad Hoc" ya "Development" select karein (testing ke liye)
   - Ya "App Store Connect" (App Store ke liye)
   - Export karein
   - IPA file save location choose karein

### Option B: Command Line se

```bash
# Xcode project open karein
open ios/Runner.xcworkspace

# Phir Xcode mein manually archive karein (Product → Archive)
# Ya phir ye command try karein:
xcodebuild -workspace ios/Runner.xcworkspace \
  -scheme Runner \
  -configuration Release \
  -archivePath build/ios/Runner.xcarchive \
  archive
```

## Step 3: IPA File Upload

IPA file ready hone ke baad:

```bash
# IPA file ko releases folder mein copy karein
cp path/to/Runner.ipa releases/ios/

# GitHub Release mein upload karein
gh release upload v1.0.0 releases/ios/Runner.ipa --clobber
```

Ya manually browser se:
1. https://github.com/amarhumayunx/Surah-Yaseen/releases/edit/v1.0.0
2. "Attach binaries" section mein IPA file drag & drop karein
3. "Update release" click karein

## Alternative: TestFlight (App Store)

Agar App Store par distribute karna ho:
1. App Store Connect mein app create karein
2. Xcode se "Distribute App" → "App Store Connect"
3. TestFlight mein upload hoga
4. Beta testing ke liye invite kar sakte hain

## Notes

- **Free Apple Developer Account**: Simulator ke liye build kar sakte hain, lekin device par install ke liye paid account chahiye
- **Paid Account ($99/year)**: Real devices par install aur App Store distribution
- **Ad Hoc Distribution**: Specific devices ke liye (UDID register karna hoga)

