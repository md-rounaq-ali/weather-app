<h1 align="center">🌦️ Weather Report App</h1>

<p align="center">
  A premium, high-fidelity cross-platform weather application built with <b>Flutter</b> and <b>Dart</b>. Designed with a gorgeous, dark-mode glassmorphism interface, this application showcases production-grade architecture, advanced asynchronous programming, automated DevOps, and device hardware integration.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white" alt="Flutter"/>
  <img src="https://img.shields.io/badge/Dart-%230175C2.svg?style=for-the-badge&logo=Dart&logoColor=white" alt="Dart"/>
  <img src="https://img.shields.io/github/actions/workflow/status/md-rounaq-ali/weather-app/deploy.yml?style=for-the-badge&logo=github&label=CI/CD%20Deployment" alt="Build Status"/>
  <img src="https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge" alt="License"/>
</p>

<p align="center">
  <a href="#-key-features">Key Features</a> •
  <a href="#-architecture--software-design">Architecture</a> •
  <a href="#-engineering-highlights">Engineering Highlights</a> •
  <a href="#-screenshots">Screenshots</a> •
  <a href="#-live-demo">Live Demo</a> •
  <a href="#-devops--automation">DevOps & Automation</a> •
  <a href="#-installation">Installation</a>
</p>

---

## ✨ Key Features

* 🔍 **Live Autocomplete Search**: Instantly queries millions of global cities using the **Open-Meteo Geocoding API**, using precise Latitude/Longitude coordinates for coordinate-based fetching.
* 📍 **GPS Geolocation Integration**: Requests and securely handles device location permissions on startup using the **Geolocator** API to automatically load the user's local weather.
* 💾 **Persistent Session Storage**: Uses **SharedPreferences** to quietly serialize and store the last successfully searched city, restoring the user's previous session instantly on app launch.
* 🎨 **Fluid UI/UX with Lottie**: Replaced generic weather icons with rich, responsive **Lottie animations** that react dynamically to shifting weather codes.
* 📅 **7-Day Atmospheric Forecast**: Renders a complete daily outlook featuring temperature ranges, weather descriptions, and predictive stats.

---

## 📂 Architecture & Folder Structure

This application follows a highly scalable **MVVM-inspired Clean Architecture** pattern, strictly separating business logic, models, and UI layers.

```text
lib/
├── models/          # Strongly-typed data models with defensive JSON parsing
│   ├── location_model.dart
│   └── weather_model.dart
├── providers/       # Centralized state management & reactive business logic
│   └── weather_provider.dart
├── services/        # Specialized REST API clients & HTTP wrappers
│   └── weather_api.dart
├── screens/         # Modular, high-fidelity UI views and components
│   ├── home_screen.dart
│   └── search_screen.dart
└── main.dart        # Core initialization, theme tokens, and routing
```

---

## 🚀 Engineering Highlights

This portfolio project goes beyond standard beginner tutorials by implementing real-world production engineering practices:

### 1. Advanced Network Optimization (Debouncing)
To prevent API rate-limiting and unnecessary network consumption, the city search utilizes a debouncing mechanism. Fetching requests are only sent after the user stops typing for **500 milliseconds**, saving bandwith and processing resources.

### 2. Robust State Management (`Provider`)
Using `Provider`, the app implements a clean, reactive state pipeline. The UI cleanly reflects loading, success, and error states, ensuring that network lag or device offline conditions are handled gracefully without app crashes.

### 3. Graceful Hardware Permission Handshakes
Location requests implement a strict triple-check handshake:
1. Verifies if global location services are active.
2. Checks current application permissions.
3. Gracefully requests permission, with automatic offline fallback to a default city (London) if access is denied by the user.

---

## 📸 Screenshots

<div align="center">
  <!-- Screenshots automatically populate once pushed to your repository! -->
  <table border="0">
    <tr>
      <td>
        <p align="center"><b>Dashboard (Dynamic Animations)</b></p>
        <img src="assets/screenshots/home.png" alt="Home Dashboard" width="260"/>
      </td>
      <td>
        <p align="center"><b>Autocomplete City Search</b></p>
        <img src="assets/screenshots/search.png" alt="Autocomplete Search" width="260"/>
      </td>
    </tr>
  </table>
</div>

---

## 🚀 Live Demo

[🌍 Click here to view the live Web Demo](https://md-rounaq-ali.github.io/weather-app/) 

*(Note: Hosted completely for free using GitHub Pages. If the build pipeline has just run, it will launch in seconds!)*

---

## ⚙️ DevOps & Automation (CI/CD)

The repository runs a full **CI/CD DevOps Pipeline** built via GitHub Actions:
* **Workflow File**: `.github/workflows/deploy.yml`
* **Trigger**: Any push or merged Pull Request to the `main` branch.
* **Process**: Spins up a dynamic Ubuntu runner, installs Flutter, retrieves project dependencies, compiles the bundle for **Web**, and pushes the finished release directly to the `gh-pages` branch.

This ensures zero-downtime updates of the live web demo with no manual steps.

---

## 💻 Installation

To build and run this application locally:

### Prerequisites
* Flutter SDK (v3.22.0 or newer recommended)
* Dart SDK (v3.4.0 or newer)
* Active Internet connection

### Setup
1. **Clone the repository:**
   ```bash
   git clone https://github.com/md-rounaq-ali/weather-app.git
   cd weather-app
   ```

2. **Fetch all dependencies:**
   ```bash
   flutter pub get
   ```

3. **Generate Native Configurations (Icons & Splash):**
   ```bash
   flutter pub run flutter_launcher_icons
   flutter pub run flutter_native_splash:create
   ```

4. **Launch the project:**
   ```bash
   flutter run
   ```

---

## 📝 License

This project is fully open-source and released under the [MIT License](LICENSE). Feel free to use, modify, and distribute it!
