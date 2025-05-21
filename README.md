# Fleet Monitoring App

A Flutter-based real-time fleet monitoring application featuring live car locations on Google Maps with search and filter capabilities.

## Features

- **Live Map View**: Displays car locations with markers on Google Maps.
- **Search Functionality**: Search cars by name or status (e.g., Moving, Parked).
- **Status Filter**: Filter cars by their status using chips (All, Moving, Parked).
- **Car Detail Screen**: Tap on car markers to view detailed information.
- **Auto Camera Adjustment**: The map camera automatically fits bounds of visible cars based on current search and filters.
- **Tracking Highlight**: The tracked car marker is highlighted in blue.

## How to Run the App

1. **Prerequisites**:  
   - Flutter SDK installed (version >= 3.0 recommended)  
   - An Android/iOS emulator or physical device connected  
   - Google Maps API key configured for both Android and iOS (replace in `android/app/src/main/AndroidManifest.xml` and `ios/Runner/AppDelegate.swift` or Info.plist)  
   
2. **Clone the Repository**  
   ```bash
   git clone https://github.com/your-username/fleet-monitoring-app.git
   cd fleet-monitoring-app
