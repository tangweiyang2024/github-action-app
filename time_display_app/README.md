# Smart Clock App

A comprehensive Flutter time management application with beautiful design and multiple time-related features.

## 🎯 Features

### 🕐 Clock Screen
- **Modern Clock Display**: Beautiful gradient background with animated clock icon
- **Real-time Updates**: Updates every second with AM/PM indicator
- **Date Display**: Shows current date with weekday and formatted date
- **Dark/Light Mode**: Automatically adapts to system theme
- **Responsive Design**: Works perfectly on all screen sizes

### ⏰ Alarm Screen
- **Multiple Alarms**: Create and manage unlimited alarms
- **Toggle Alarms**: Enable/disable individual alarms
- **Persistent Storage**: Alarms are saved and restored automatically
- **Easy Time Picker**: Intuitive time selection interface
- **Delete Alarms**: Remove unwanted alarms with one tap

### ⏱️ Stopwatch Screen
- **Precise Timing**: Accurate stopwatch with millisecond precision
- **Lap Function**: Record multiple lap times during timing
- **Play/Pause/Reset**: Full control over stopwatch operations
- **Visual Feedback**: Circular progress indicator with gradient effects
- **Lap History**: View all recorded laps with timestamps

### ⌛ Timer Screen
- **Custom Duration**: Set hours, minutes, and seconds
- **Countdown Display**: Beautiful circular countdown timer
- **Pause/Resume**: Control timer during countdown
- **Reset Function**: Return to original duration
- **Completion Alert**: Dialog notification when timer finishes

## 🎨 Design Features

- **Material Design 3**: Latest Material Design guidelines
- **Gradient Backgrounds**: Beautiful purple-to-blue gradients
- **Circular Indicators**: Modern circular progress displays
- **Smooth Animations**: Fluid transitions and interactions
- **Theme Support**: Dark and light theme support
- **Bottom Navigation**: Easy navigation between features

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.16.5 or higher)
- Dart SDK (3.2.3 or higher)
- Android Studio / VS Code with Flutter extensions
- For iOS: macOS with Xcode (for iOS builds)

### Installation

1. Clone the repository
2. Navigate to the `time_display_app` directory
3. Install dependencies:

```bash
flutter pub get
```

4. Run the app:

```bash
flutter run
```

## 📱 Building the App

### Android APK

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### iOS App

```bash
flutter build ios --release
```

**Note**: iOS builds require macOS and Xcode.

### Web App

```bash
flutter build web --release
```

Output: `build/web/` directory

## 🔧 Technical Details

### Dependencies

- **flutter_local_notifications**: ^16.3.0 - For notification support
- **shared_preferences**: ^2.2.2 - For persistent data storage
- **flutter_local_notifications**: Notification system
- **Material Design 3**: Modern UI components

### Project Structure

```
time_display_app/
├── lib/
│   └── main.dart          # Main application file with all screens
├── android/               # Android-specific files
├── ios/                   # iOS-specific files
├── web/                   # Web-specific files
├── test/                  # Test files
└── pubspec.yaml          # Dependencies and configuration
```

### Application Architecture

The app follows a clean architecture with:

- **State Management**: StatefulWidget with setState
- **Data Persistence**: SharedPreferences for alarms
- **Navigation**: BottomNavigationBar for screen switching
- **Timer Management**: Dart Timer class for periodic updates
- **UI Components**: Material Design 3 widgets

## 🎯 Key Features Implementation

### Clock Screen
- Uses `Timer.periodic` for real-time updates
- Formats time in 12-hour format with AM/PM
- Gradient background with circular icon design
- System theme detection for dark/light mode

### Alarm Screen
- Data persistence using SharedPreferences
- JSON serialization for alarm storage
- Time picker dialog for alarm creation
- Switch widgets for enable/disable functionality

### Stopwatch Screen
- Dart Stopwatch class for precise timing
- 10ms update interval for accuracy
- Lap recording with ListWheelScrollView for display
- Circular progress indicator with gradient

### Timer Screen
- Custom duration picker with scrollable wheels
- Countdown timer with visual feedback
- Alert dialog on completion
- Pause/resume/reset functionality

## 🧪 Testing

Run tests with:

```bash
flutter test
```

Code analysis:

```bash
flutter analyze
```

## 🔄 GitHub Actions CI/CD

The project includes automated building via GitHub Actions:

- **Code Analysis**: Automatic code quality checks
- **Testing**: Automated test execution
- **Multi-platform Builds**: Android, iOS, and Web
- **Artifact Upload**: Build artifacts available for download

## 📊 Performance

- **Smooth 60fps animations**: Optimized widget rebuilds
- **Memory efficient**: Proper timer disposal and state management
- **Fast startup**: Minimal initialization overhead
- **Battery friendly**: Efficient background timers

## 🌐 Platform Support

- ✅ **Android**: Full support with Material Design
- ✅ **iOS**: Full support with adaptive design
- ✅ **Web**: Full support with responsive layout
- ✅ **Desktop**: Supports Windows, macOS, and Linux

## 🔮 Future Enhancements

Potential features for future versions:

- World clock with multiple time zones
- Alarm sound customization
- Background timer support
- Widget support for home screen
- Export/Import alarm settings
- Stopwatch with split times
- Timer presets for common durations
- Vibration and sound effects

## 📄 License

This project is open source and available under the MIT License.

## 👨‍💻 Development

### Development Guidelines

- Follow Material Design 3 guidelines
- Use semantic naming for widgets and variables
- Implement proper state management
- Handle edge cases and errors gracefully
- Write tests for new features
- Update documentation for significant changes

### Code Style

- Follow Dart effective guidelines
- Use const constructors where possible
- Prefer final variables for immutability
- Keep widgets small and focused
- Use meaningful comments for complex logic
