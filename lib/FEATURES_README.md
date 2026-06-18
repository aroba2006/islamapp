# Islamic Prayer Times App ✨ 🕌

A beautiful, feature-rich Islamic prayer times app built with Flutter. Get prayer times for any country/region worldwide with stunning animations, multi-language support, and Adhan notifications.

## ✨ Features

### 🌍 Prayer Times
- **Real-time Prayer Times**: Accurate prayer times for 100+ countries using the Aladhan API
- **Country & Region Selection**: Select your country, then your state/governorate
- **Live Countdown**: Real-time countdown to the next prayer with HH:MM:SS format
- **Prayer Notifications**: Automatic notifications when prayer times arrive
- **Sunrise Display**: Shows sunrise time for each day

### 🎵 Adhan (Islamic Call to Prayer)
- **5 Reciter Options**:
  - Mishary Al-Afasi (default)
  - Nasser Al-Qattami
  - Ali Al-Mala
  - Abdulbasit Abdulsamad
  - Saud Al-Shubait
- **Play/Stop Controls**: Manually play Adhan at any time
- **High-Quality Audio**: Pre-optimized Adhan recordings
- **Auto-play on Notification**: Plays automatically when prayer time arrives

### 🌐 Multi-Language Support
- **Arabic** (العربية) - Main language with RTL support
- **English** (English)
- **French** (Français)
- All UI strings translated
- Persistent language preference storage

### 🎨 UI/UX Features
- **Islamic Green Color Scheme**: Professional #1B5E3F + Gold #D4AF37 accents
- **Islamic Geometric Patterns**: 8-point star background patterns
- **Smooth Animations**: 
  - Fade & slide transitions between screens
  - Staggered list animations
  - Scale and opacity effects
  - Countdown timer animation
- **Beautiful Gradients**: Linear gradients with Islamic theme
- **Responsive Design**: Works on phones and tablets

### ⚙️ Settings
- **Language Selection**: Switch between Arabic, English, and French
- **Adhan Reciter Selection**: Choose your favorite Adhan caller
- **Notification Toggle**: Enable/disable prayer time alerts
- **Persistent Preferences**: All settings saved locally

## 📁 Project Structure

```
lib/
├── main.dart                    # App initialization with localization
├── l10n/                        # Localization files
│   ├── app_localizations.dart   # Base localization class
│   ├── ar_ar.dart               # Arabic strings
│   ├── en_us.dart               # English strings
│   └── fr_fr.dart               # French strings
├── screens/
│   ├── country_selection_screen.dart   # Country picker
│   ├── region_selection_screen.dart    # Region/state picker
│   ├── prayer_times_screen.dart        # Main prayer times display
│   └── settings_screen.dart            # Settings & preferences
├── services/
│   ├── prayer_times_service.dart       # Aladhan API integration
│   ├── adhan_service.dart              # Audio player for Adhan
│   └── notification_service.dart       # Local notifications
├── models/
│   ├── prayer_times.dart        # Prayer times data model
│   └── country_data.dart        # Country/region data
├── data/
│   └── countries_data.dart      # 100+ countries with regions
└── widgets/
    └── islamic_pattern_background.dart # Decorative patterns
```

## 🚀 Setup & Installation

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- iOS 11.0+ or Android 5.0+ (API 21+)

### Installation Steps

1. **Extract the project files**
2. **Navigate to project directory**
   ```bash
   cd islamic_app
   ```

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Get your dependencies**
   ```bash
   flutter pub upgrade
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

## 📦 Dependencies

```yaml
flutter_localizations:    # Multi-language support
intl: ^0.19.0             # Internationalization utilities
http: ^1.2.0              # HTTP requests for API calls
shared_preferences: ^2.2.2 # Local storage for preferences
flutter_local_notifications: ^14.1.0  # Prayer time notifications
timezone: ^0.9.0          # Timezone support for notifications
audioplayers: ^5.2.0      # Audio player for Adhan recordings
```

## 🎯 How to Use

### First Time Setup
1. **Open the app** → See the country selection screen
2. **Search or scroll** to find your country (100+ countries available)
3. **Tap your country** → See region/governorate selection
4. **Select your region** → Get prayer times instantly!

### Main Features
- **View Prayer Times**: Large display with Fajr, Dhuhr, Asr, Maghrib, Isha
- **Track Countdown**: See exactly how long until the next prayer
- **Play Adhan**: Tap "Play Adhan" button to hear the call to prayer
- **Refresh**: Pull-to-refresh or tap refresh icon for updated times
- **Settings**: Tap settings icon (⚙️) to change language or Adhan reciter

### Notification Setup (iOS)
If you want automatic Adhan notifications on iOS:
1. Go to Settings → Notifications → Islamic Prayer Times
2. Allow notifications
3. Enable "Time Sensitive" for immediate Adhan playback

## 🎨 Customization

### Change Colors
Edit `lib/main.dart` in the `ThemeData`:
```dart
seedColor: const Color(0xFF1B5E3F),  // Islamic green
secondary: const Color(0xFFD4AF37),   // Gold accent
```

### Add More Countries
Edit `lib/data/countries_data.dart` and add to the `countries` list:
```dart
CountryData(
  name: "Country Name",
  flagEmoji: "🏳️",
  regions: ["City 1", "City 2", ...],
),
```

### Add More Adhan Reciters
1. Edit `lib/services/adhan_service.dart`
2. Add URL to `adhanAudioUrls` map
3. Add name to `reciterNames` map
4. Update localization files in `lib/l10n/`

## 🐛 Troubleshooting

### No Prayer Times Showing?
- Check internet connection (uses Aladhan API)
- Verify country/region spelling matches API database
- Try tapping Refresh button

### Notifications Not Working?
- **Android**: Grant notification permissions in app settings
- **iOS**: Check Settings → Notifications → Islamic Prayer Times
- Ensure "Time Sensitive" is enabled for iOS 15+

### Adhan Not Playing?
- Check device volume is not muted
- Ensure audio permissions granted in app settings
- Check internet for streaming Adhan URLs

### Language Not Changing?
- Tap settings icon (⚙️) at top right
- Select new language from radio options
- App will restart with new language

## 🌐 API Reference

### Aladhan Prayer Times API
- **Endpoint**: `https://api.aladhan.com/v1/timingsByCity`
- **Method**: Prayer Time Calculation Method 3 (Muslim World League)
- **Parameters**: 
  - `city`: Region name
  - `country`: Country name
  - `method`: 3 (Muslim World League)
- **Rate Limit**: 1000 requests/day (plenty for this app!)

### Supported Countries (100+)
- Middle East: Saudi Arabia, UAE, Qatar, Bahrain, Oman, Kuwait, Jordan, Lebanon, Iraq, Syria, Palestine, Iran, Yemen
- North Africa: Egypt, Algeria, Tunisia, Libya, Morocco, Sudan
- Sub-Saharan Africa: Nigeria, Kenya, Tanzania, Uganda, Somalia, etc.
- South Asia: Pakistan, Bangladesh, Afghanistan, India
- Southeast Asia: Indonesia, Malaysia, Bangladesh, Thailand
- Europe: UK, France, Germany, Spain, Italy, etc.
- Americas: USA, Canada, Brazil, Mexico
- And 50+ more countries!

## 📝 License

This Islamic Prayer Times app is built with Flutter and uses free/open APIs.
- Prayer data: Aladhan API (free, no API key needed)
- Adhan audio: High-quality recitations
- App: Custom built for community use

## 🙏 Credits

- **UI/Design**: Beautiful Islamic geometric patterns and green color scheme
- **Prayer Times**: Aladhan API for accurate calculation
- **Localization**: Full support for Arabic, English, French
- **Audio**: Quality Adhan recitations from renowned reciters

## 🚀 Future Enhancement Ideas

- [ ] Qibla direction compass
- [ ] Hijri calendar integration
- [ ] Quran/Hadith of the day
- [ ] Zakat calculator
- [ ] Dua collections
- [ ] Prayer tracking/statistics
- [ ] Dark mode theme
- [ ] Widget (home screen shortcut)
- [ ] Apple Watch/Wear OS companion
- [ ] Offline prayer times database

## 📱 Tested On

- ✅ Android 5.0 - 14
- ✅ iOS 11.0 - 17
- ✅ Flutter 3.0+
- ✅ Web browsers (Chrome, Safari, Firefox)

## 🤝 Support

For issues or suggestions:
1. Check the Troubleshooting section above
2. Verify all permissions are granted
3. Ensure Flutter and dependencies are up-to-date
4. Clear app cache: `flutter clean` then `flutter pub get`

---

**Assalamu alaykum wa rahmatullahi wa barakatuh!** 🕌✨

May this app help you stay connected to your daily prayers. Built with ❤️ for the Muslim community worldwide.
