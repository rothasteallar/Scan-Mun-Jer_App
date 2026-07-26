# Scan Mun Jer — ស្កេនមុនជឿ
QR and URL Threat Scanner

A mobile security app that helps everyday Cambodian users check if a QR code or link is safe before opening it. Built with Flutter for Android.

---

## About the App

QR codes are scanned daily in Cambodia for KHQR payments, Telegram links, and Facebook links. Users often tap without checking where the link leads. Scan Mun Jer gives users a simple tool to verify any link before trusting it — using Google Safe Browsing API and local rule-based analysis.

Direction: Blue Team (defensive)

---

## Features

- Scan any QR code using the camera to instantly check the link inside
- Manually paste or type a URL to check it
- Two-layer threat detection — Google Safe Browsing API + local rule-based scoring
- View, search, filter, and delete scan history
- Plain language explanations for every threat — designed for non-technical users
- Flashlight toggle for scanning in low light

---

## Detection Logic

### Layer 1 — Google Safe Browsing API
Checks the URL against Google's database of known threats. Detects MALWARE, SOCIAL_ENGINEERING, UNWANTED_SOFTWARE, and POTENTIALLY_HARMFUL_APPLICATION. If a threat is found, the URL is immediately classified as High Risk and Layer 2 is skipped. If the API fails, the app silently falls back to Layer 2.

### Layer 2 — Local Rule-Based Scoring
Runs only if Layer 1 returns clean:

| Rule | Points |
|---|---|
| IP-based URL (e.g. http://192.168.1.1) | +30 |
| Known URL shortener (bit.ly, tinyurl, etc.) | +25 |
| Lookalike domain (paypa1, g00gle, etc.) | +25 |
| Suspicious TLD (.tk, .ml, .xyz, .zip, etc.) | +15 |
| Too many subdomains | +10 |

Verdict based on total score:
- 0 to 20 — Safe
- 21 to 49 — Suspicious
- 50 and above — High Risk

---

## Tech Stack

| | |
|---|---|
| Framework | Flutter (Dart) |
| Local database | sqflite |
| API | Google Safe Browsing API v4 |
| QR scanning | mobile_scanner |
| Icons | flutter_tabler_icons |

---

## Required Packages

| Package | Version | Purpose |
|---|---|---|
| mobile_scanner | ^6.0.0 | Camera-based QR code scanning |
| sqflite | ^2.3.3 | Local SQLite database |
| http | ^1.2.2 | HTTP requests to Google Safe Browsing API |
| image_picker | ^1.0.0 | Gallery image selection |
| flutter_tabler_icons | ^1.0.0 | UI icons |
| flutter_launcher_icons | ^0.14.3 | App icon generation |

---

## Architecture

Layered architecture:

```
lib/
  data/
    repositories/
      scan_repository.dart
    database_helper.dart
    google_safebrowsing_api.dart
    rule_engine.dart
  models/
    scan_result.dart
    risk_rule.dart
    safe_browsing_response.dart
  ui/
    screens/
      home_screen.dart
      qr_scanner_screen.dart
      result_screen.dart
      history_screen.dart
      manual_input_screen.dart
    widget/
      verdict_banner.dart
      verdict_badge.dart
      risk_score_bar.dart
      rule_card.dart
      scan_row.dart
  main.dart
```

---

## App Screens

1. **Home** — Entry point with two action cards: Scan a QR code and Enter a URL
2. **QR Scanner** — Live camera view to scan QR codes with flashlight control
3. **Result** — Displays the verdict, threat details, and plain language explanation
4. **History** — List of all past scans with search, filter, and delete options
5. **Manual Input** — Form to paste or type a URL and submit for analysis

---

## Basic User Flow

```
Open App
   |
Home Screen
   |
   |--- Scan a QR code
   |         |
   |    QR Scanner
   |         |
   |    Result Screen
   |
   |--- Enter a URL
             |
       Manual Input
             |
       Result Screen
             |
       History Screen (via bottom nav)
```

---

## Getting Started

### Prerequisites
- Flutter SDK installed
- Android device or emulator
- Google Safe Browsing API key

### Setup

1. Clone the repository:
```bash
git clone https://github.com/rothasteallar/Scan-Mun-Jer_App.git
cd Scan-Mun-Jer_App
```

2. Install dependencies:
```bash
flutter pub get
```

3. Add your Google Safe Browsing API key in `lib/data/google_safebrowsing_api.dart` (No need for now, Already provided):
```dart
const String _apiKey = 'YOUR_API_KEY_HERE';
```

4. Run the app:
```bash
flutter run
```

---

## Test URLs

### Google Safe Browsing
```
MALWARE:            http://testsafebrowsing.appspot.com/apiv4/ANY_PLATFORM/MALWARE/URL/
SOCIAL_ENGINEERING: http://testsafebrowsing.appspot.com/apiv4/ANY_PLATFORM/SOCIAL_ENGINEERING/URL/
UNWANTED_SOFTWARE:  http://testsafebrowsing.appspot.com/apiv4/ANY_PLATFORM/UNWANTED_SOFTWARE/URL/
```

### Local Rules
```
Safe:       https://aba.com.kh
Suspicious: http://192.168.1.1/login
High Risk:  http://bit.ly/paypa1.tk
```

---

## Future Improvements

- Share scan results via Telegram or WhatsApp
- Scan QR codes from gallery images
- Camera zoom control
- Multi-select delete in History
- Custom exception handling

---

## Contributors

Prepared By: Loun Rotha; Oun Vireak

Course: Mobile Development in Cybersecurity

Lecturer: Mr. Ronan Ogor

Department: Telecom and Networking

Specialization: Cyber Security

Institution: Cambodia Academy of Digital Technology (CADT)

---

## License

This project is licensed under the MIT License.

MIT License

Copyright (c) 2026 Loun Rotha, Oun Vireak


