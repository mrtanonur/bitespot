🍽️ BiteSpot
A Flutter-based mobile application that helps users discover nearby restaurants using Google Maps integration, with features for favorites management, user authentication, and personalized settings.

✨ Features

🗺️ Map & Location

Real-time location tracking

Discover nearby restaurants within 500m radius

Interactive Google Maps integration with custom markers

Detailed restaurant information cards

🔐 Authentication

Email/Password sign up with email verification

Google Sign-In integration

Apple Sign-In support

Password reset functionality

Remember me option for convenience

⭐ Favorites

Save favorite restaurants locally (Hive) and remotely (Firebase)

Sync favorites across devices

Quick access to saved restaurants

Bookmark management

⚙️ Personalization

Multi-language support (English & Turkish)

Theme customization (Light, Dark, System)

User profile management

Persistent settings storage

📍 Restaurant Details

Name, address, and phone number

Opening hours and current status (Open/Closed)

Star ratings

Draggable detail cards for better UX

🛠️ Tech Stack

Frontend

Flutter - Cross-platform mobile framework

Provider - State management

Google Maps Flutter - Map integration

Backend & Services

Firebase Authentication - User authentication

Cloud Firestore - Cloud data storage

Google Places API - Restaurant data

Local Storage

Hive - Local database for favorites and settings

Path Provider - File system access

Additional Packages

Geolocator - Location services

Dio - HTTP client

Google Sign-In - OAuth integration

Sign in with Apple - Apple authentication

Flutter Dotenv - Environment variables

Dartz - Functional programming (Either type)

📱 Screenshots

Add your app screenshots here

🚀 Getting Started

Prerequisites

Flutter SDK (>=3.0.0)

Dart SDK

Android Studio / Xcode

Firebase account

Google Cloud Platform account with Maps API enabled

Installation

Clone the repository

git clone https://github.com/mrtanonur/bitespot.git

cd bitespot


lib/

├── features/

│   ├── auth/           # Authentication logic

│   ├── favorites/      # Favorites management

│   ├── maps/          # Map and location features

│   └── settings/      # User settings

├── models/            # Data models

├── providers/         # State management

├── services/          # API and Firebase services

├── widgets/           # Reusable UI components

├── l10n/             # Localization files

└── main.dart         # App entry point

flutter pub get

