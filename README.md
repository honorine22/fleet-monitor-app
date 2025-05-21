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
![Tracking1](WhatsApp%20Video%202025-05-22%20at%2000.41.36_4aa82dab-4.jpg)
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

## 🚀 Getting Started

### 1. Clone the Repository
git clone https://github.com/honorine22/fleet-monitor-app.git
cd fleet-monitor-app
flutter pub get

# 🛠️ Setup Instructions

## 1. Replace the base URL in your API service file with:
const baseUrl = 'https://682b6827d29df7a95be34818.mockapi.io/api/v1';

# 2. Add your Google Maps API key in android/app/src/main/AndroidManifest.xml:
<meta-data
  android:name="com.google.android.geo.API_KEY"
  android:value="YOUR_GOOGLE_MAPS_API_KEY"/>
  
# ▶️ Run the App
flutter pub get
flutter run
