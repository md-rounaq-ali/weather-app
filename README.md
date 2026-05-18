<h1 align="center">Weather Report App 🌤️</h1>

<p align="center">
  A premium, beautifully designed cross-platform weather application built with Flutter. Features live autocomplete search, dynamic Lottie animations, GPS integration, and a glassmorphism UI.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white" alt="Flutter Badge"/>
  <img src="https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white" alt="Dart Badge"/>
  <img src="https://img.shields.io/github/actions/workflow/status/md-rounaq-ali/weather-app/deploy.yml?style=for-the-badge&logo=github&label=Deployment" alt="Deployment Status Badge"/>
  <img src="https://img.shields.io/badge/license-MIT-green?style=for-the-badge" alt="License Badge"/>
</p>

<p align="center">
  <a href="#features">Features</a> •
  <a href="#tech-stack">Tech Stack</a> •
  <a href="#screenshots">Screenshots</a> •
  <a href="#installation">Installation</a> •
  <a href="#live-demo">Live Demo</a> •
  <a href="#cicd-pipeline">CI/CD Pipeline</a>
</p>

---

## ✨ Features

* 🔍 **Live Autocomplete Search**: Instantly searches millions of global cities using the Open-Meteo Geocoding API, utilizing precise Lat/Lon coordinates for perfect accuracy.
* 📍 **GPS Location Integration**: Automatically detects your current physical location (with permission) on startup to instantly show local weather.
* 💾 **Persistent State**: Remembers your last searched location locally across app restarts so you never lose your place.
* 🎨 **Premium UI/UX**: Dark mode, glassmorphism container design, and smooth `Lottie` animations that dynamically change based on weather conditions.
* 📅 **7-Day Forecast**: Clean and accurate daily temperature and condition predictions.

## 🛠 Tech Stack

* **Framework**: [Flutter](https://flutter.dev/) (Dart)
* **State Management**: `provider`
* **API Integration**: `http` (RESTful calls to Open-Meteo API)
* **Local Storage**: `shared_preferences`
* **Hardware/Location**: `geolocator`
* **Animations**: `lottie`
* **Typography**: `google_fonts`
* **DevOps / CI/CD**: GitHub Actions & GitHub Pages

## 📸 Screenshots

<div align="center">
  <!-- Screenshots automatically render on GitHub once you add them to assets/screenshots/ -->
  <img src="assets/screenshots/home.png" alt="Home Screen" width="250"/>
  &nbsp;&nbsp;&nbsp;&nbsp;
  <img src="assets/screenshots/search.png" alt="Search Screen" width="250"/>
</div>

## 🚀 Live Demo

[🌍 Click here to view the live Web Demo](https://md-rounaq-ali.github.io/weather-app/) 
*(Note: Powered by GitHub Pages. It will run instantly once the initial CI/CD workflow is complete!)*

## 💻 Installation

Follow these steps to build and run the app locally:

1. **Clone the repository:**
   ```bash
   git clone https://github.com/md-rounaq-ali/weather-app.git
   cd weather-app
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

## 📂 Architecture & Folder Structure

This project follows a clean separation of concerns:

```text
lib/
├── models/          # Robust data models for safe JSON parsing
│   ├── location_model.dart
│   └── weather_model.dart
├── providers/       # Centralized state management & business logic
│   └── weather_provider.dart
├── screens/         # Separated UI views
│   ├── home_screen.dart
│   └── search_screen.dart
├── services/        # API integration and asynchronous network calls
│   └── weather_api.dart
└── main.dart        # Entry point and theme configuration
```

## ⚙️ CI/CD Pipeline

This repository features fully automated Continuous Deployment (CD). Every time a push is made to the `main` branch, a **GitHub Actions** runner:
1. Clones the project and downloads dependencies.
2. Compiles the Flutter application for **Web**.
3. Deploys the release build directly to the `gh-pages` branch, serving it immediately on **GitHub Pages**.

This automated DevOps pipeline ensures that the live demo is always in sync with the latest code changes.

## 📝 License

This project is open-source and available under the MIT License.
