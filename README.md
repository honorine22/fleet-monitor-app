# 🚗 Fleet Monitor App

[![Watch the demo video](https://img.youtube.com/vi/F1fXBSJOuNk/hqdefault.jpg)](https://youtu.be/F1fXBSJOuNk)

A real-time fleet monitoring mobile app built with **Flutter**, **Google Maps**, and **MockAPI**. Track and manage vehicle locations with smooth animations, live updates, and offline support.

---

## 📸 Screenshots

### Home Map View  
![Home View](WhatsApp%20Video%202025-05-22%20at%2000.41.36_4aa82dab-0.jpg)

### Car Detail View  
![Detail View](WhatsApp%20Video%202025-05-22%20at%2000.41.36_4aa82dab-1.jpg)

### Tracking Car  
![Tracking](WhatsApp%20Video%202025-05-22%20at%2000.41.36_4aa82dab-2.jpg)

---

## 🚀 Features

- 📍 **Real-time vehicle data** fetched from [MockAPI](https://mockapi.io)
- 📈 **Track individual cars** with animated marker movement on Google Maps
- 🌐 **Offline fallback** using cached data (SharedPreferences or Hive)
- 🔍 **Search and filter** cars by name or status
- 🧑‍💻 **Riverpod** for clean, reactive state management
- 💡 Modular and extensible architecture

---

## 🛠️ Getting Started

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install)
- Internet connection (uses HTTP API)
- Google Maps API Key

### Installation

```bash
git clone https://github.com/honorine22/fleet-monitor-app.git
cd fleet-monitor-app
flutter pub get

## 🛠️ Setup

### Replace the base URL in your API service file with:

```dart
const baseUrl = 'https://682b6827d29df7a95be34818.mockapi.io/api/v1';
Add your Google Maps API key in android/app/src/main/AndroidManifest.xml:
xml
Copy
Edit
<meta-data
  android:name="com.google.android.geo.API_KEY"
  android:value="YOUR_GOOGLE_MAPS_API_KEY"/>
▶️ Run the App
bash
Copy
Edit
flutter pub get
flutter run
📁 Folder Structure
bash
Copy
Edit
lib/
├── models/        # Car model and API parsing
├── providers/     # Riverpod state management
├── screens/       # UI screens (home, detail)
├── services/      # API calls using MockAPI
├── widgets/       # Reusable UI components
🤝 Contributing
Feedback and contributions are welcome.
Feel free to fork the repository and open a pull request.

vbnet
Copy
Edit
