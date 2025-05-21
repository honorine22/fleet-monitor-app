# Fleet Monitoring App

A Flutter-based fleet monitoring application that displays real-time locations of cars on a Google Map with support for tracking, filtering by status, and detailed car views.

---

## Features

- **Real-time car location updates** simulated via polling every few seconds.
- **Google Maps integration** to show car markers dynamically.
- **Marker InfoWindows** display the car's name and allow navigation to a detailed screen.
- **Track/Stop tracking** individual cars to follow their movement live on the map.
- **Filtering cars** by status: All, Moving, or Parked.
- **Search functionality** to filter cars by their status.
- **Persistent caching** of car data using Hive.
- Responsive UI with smooth map animations and camera adjustment to car locations.

---

## Screens

- **Home Screen**: Map view with all cars shown as markers. Search and filter by car status. Tap marker to view details.
- **Car Detail Screen**: Displays detailed info about a selected car and allows start/stop tracking.

---

## Getting Started

### Prerequisites

- Flutter SDK installed (tested on Flutter 3.x+)
- Google Maps API key configured in your `android` and `iOS` project files.
- Backend API or mocked service providing car data with the following fields at minimum:
  - `id`
  - `name`
  - `latitude`
  - `longitude`
  - `status` (e.g., "Moving", "Parked")

---

### Install Dependencies

```bash
flutter pub get

### Run App

```bash
flutter run


