# 🌾 AgriConnect - Smart Logistics & Transport Platform

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Riverpod](https://img.shields.io/badge/Riverpod-State%20Management-blue?style=for-the-badge)
![Clean Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture-success?style=for-the-badge)

**AgriConnect** is a comprehensive UI/UX prototype designed to bridge the gap between agricultural suppliers, buyers, and independent transporters. This project was developed with a strong emphasis on **Human-Computer Interaction (HCI)** principles, reducing cognitive load for truck drivers while providing a seamless, highly responsive interface.

---

## 🎯 Project Objective
The traditional agricultural logistics pipeline relies heavily on manual coordination. AgriConnect digitizes this process by providing a centralized "Command Center" for drivers to find high-paying loads, manage active deliveries, and track their financial earnings. 

*Note: This repository currently serves as an interactive frontend prototype built for HCI evaluation, utilizing mock data to demonstrate state changes and UI flows.*

---

## 🚀 Features (What Works)
This application features a fully navigable, state-driven user interface:

* **Command Center Dashboard:** A centralized hub featuring a toggleable online/offline status, quick action routing, and an earnings overview.
* **State Management:** Powered by **Riverpod 3.x** (`Notifier` and `NotifierProvider`), ensuring reactive UI updates without unnecessary rebuilds.
* **Available Jobs Marketplace:** A dynamic list allowing drivers to view freight opportunities, complete with urgency badges and functional filter bottom sheets.
* **Active Deliveries Tracking:** Tabbed interfaces separating ongoing and completed jobs, featuring a visual progress timeline.
* **Native Intent Launches:** * Seamless integration with **Google Maps** via `url_launcher` to show delivery routes based on destination queries.
    * Direct links to native Dialer and WhatsApp for the "Help & Support" module.
* **Driver Public Profile:** A trust-building interface displaying vehicle details, verified documents, and performance ratings.
* **Responsive Design:** Grid ratios and typography scale gracefully to prevent overflow on smaller mobile screens.

---

## 🚧 Limitations (What is Simulated / Doesn't Work Yet)
To keep the focus on UI/UX and HCI principles, backend integrations have been mocked:

* **No Live Database:** The jobs, earnings, and delivery histories are generated using static mock repositories within the Riverpod providers.
* **Simulated Delays:** "Loading" states (like fetching new jobs or accepting a load) use `Future.delayed` to demonstrate asynchronous UI handling.
* **No Real-time GPS:** While the architecture is prepared to handle `Geolocator` streams, real-time live tracking is disabled in this build to prevent excessive battery drain during UI demos.
* **Form Submissions:** The Vehicle Registration form allows user input and photo uploads visually, but does not push data to a remote server.

---

## 🏗️ Architecture
The project strictly follows **Feature-Driven Clean Architecture** to ensure testability and scalability:

```text
lib/
├── core/                       # Shared utilities, theme, and colors
│   ├── theme/
│   └── utils/                  # e.g., url_launcher_helper.dart
├── features/                   # Feature modules
│   ├── auth/                   
│   ├── dashboard/              # e.g., notifications
│   ├── logistics/              # Driver core features
│   │   ├── data/               # Models (JobModel, TransactionModel)
│   │   ├── presentation/
│   │   │   ├── providers/      # Riverpod Notifiers (driver_jobs_provider.dart)
│   │   │   ├── screens/        # UI Screens (Command Center, My Deliveries, etc.)
│   │   │   └── widgets/        # Reusable UI components (StatCard, ShipmentCard)
│   └── settings/               # Preferences and User Settings
└── main.dart                   # Entry point

🛠️ How to Run
Clone the repository:
git clone [https://github.com/Thrillind/Agriconnect.git](https://github.com/Thrillind/Agriconnect.git)

Navigate to the directory:
cd agriconnect

Install dependencies:
flutter pub get

Run the app:
flutter run

(To build a release APK for Android, use flutter build apk --release)

👥 Team
1. M Zeeshan (Team Lead & UI/Architecture)

2. Ibrahim Asif

3. Laiba Gousia

4. Hira Midhat

Developed for the Human-Computer Interaction (HCI) Lab - Bachelor of Science in Artificial Intelligence (BSAI).
