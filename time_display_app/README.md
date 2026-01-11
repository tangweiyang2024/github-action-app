# Time Display App

A simple Flutter application that displays the current time and date with automatic updates.

## Features

- Real-time clock display (updates every second)
- Shows current date with weekday and month
- Clean and modern UI using Material Design 3
- Responsive layout

## Getting Started

### Prerequisites

- Flutter SDK (3.16.5 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Running the App

1. Clone the repository
2. Navigate to the `time_display_app` directory
3. Run the app:

```bash
flutter run
```

### Building the App

**Android APK:**
```bash
flutter build apk --release
```

**Web App:**
```bash
flutter build web --release
```

**iOS App:**
```bash
flutter build ios --release
```

## GitHub Actions CI/CD

This project includes automated building via GitHub Actions. The workflow will:

- Run code analysis
- Execute tests
- Build Android APK
- Build Web application
- Upload build artifacts

The workflow triggers on push and pull requests to main/master branches.

## Project Structure

```
time_display_app/
├── lib/
│   └── main.dart          # Main application file
├── android/               # Android-specific files
├── ios/                   # iOS-specific files
├── web/                   # Web-specific files
└── pubspec.yaml          # Dependencies and configuration
```
