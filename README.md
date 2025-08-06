# Todo App with REST API

A comprehensive Flutter todo application that combines local storage with REST API synchronization, providing offline-first functionality with seamless cloud sync.

## Features

- ✅ **Task Management**: Create, edit, delete, and complete tasks
- 🔄 **Offline-First**: Works without internet connection using Hive local storage
- 🌐 **REST API Integration**: Synchronizes with remote server when online
- 📱 **Cross-Platform**: Runs on Android and iOS
- 🎨 **Custom UI**: Beautiful interface with custom fonts and icons
- 📊 **State Management**: Provider pattern for reactive state updates
- 🔔 **Smart Notifications**: Custom snackbars for user feedback
- 🔄 **Auto-Sync**: Automatic sync queue for offline changes

## Architecture

The app follows a clean architecture pattern with the following layers:

- **Presentation Layer**: Screens and widgets
- **Business Logic**: Provider-based state management
- **Data Layer**: Repository pattern with dual storage (Local + Remote)
- **Models**: Task entity with JSON serialization and Hive type adapters

## Tech Stack

- **Framework**: Flutter 3.7+
- **State Management**: Provider
- **Local Storage**: Hive
- **HTTP Client**: HTTP package for REST API calls
- **Connectivity**: Connectivity Plus for network status
- **Code Generation**: JSON Serializable & Hive Generator

## Project Structure

```
lib/
├── components/          # Reusable UI components
│   ├── app_button.dart
│   ├── app_text.dart
│   ├── app_text_field.dart
│   └── app_text_style.dart
├── constants/           # App constants
│   ├── app_colors_path.dart
│   └── app_icons_path.dart
├── models/             # Data models
│   ├── task.dart
│   └── task.g.dart     # Generated code
├── provider/           # State management
│   ├── demo_provider.dart
│   └── task_provider.dart
├── repositories/       # Data access layer
│   └── task_repository.dart
├── routes/            # App navigation
│   └── app_routes.dart
├── screens/           # UI screens
│   ├── add_screen.dart
│   ├── completed_screen.dart
│   ├── edit_screen.dart
│   ├── home_screen.dart
│   └── widgets/       # Screen-specific widgets
├── services/          # Business services
│   ├── api_service.dart
│   └── storage_service.dart
└── main.dart
```

## Getting Started

### Prerequisites

- Flutter SDK 3.7.0 or higher
- Dart SDK
- Android Studio / VS Code
- iOS development setup (for iOS builds)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd todo_app_with_rest_api
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Code Generation

This project uses code generation for:
- **JSON Serialization**: Task model serialization/deserialization
- **Hive Type Adapters**: Local storage type adapters

To regenerate code after model changes:
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

## Configuration

### REST API Setup

Update the API base URL in `lib/services/api_service.dart`:

```dart
static const String baseUrl = 'your-api-endpoint';
```

### Local Storage

The app uses Hive for local storage with automatic initialization. No additional setup required.

## Usage

### Basic Operations

1. **Add Task**: Tap the floating action button to create a new task
2. **Edit Task**: Tap the edit icon on any task
3. **Complete Task**: Tap the checkmark icon to mark as completed
4. **Delete Task**: Tap the trash icon and confirm deletion
5. **View Completed**: Use bottom navigation to switch between pending and completed tasks

### Offline Functionality

- All operations work offline and are stored locally
- Changes are queued for sync when connection is restored
- Visual indicators show sync status

## Development

### Running Tests

```bash
flutter test
```

### Building for Production

**Android:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

### Debugging

The app includes comprehensive error handling and logging. Check the debug console for detailed information during development.

## Dependencies

### Main Dependencies
- `provider: ^6.1.2` - State management
- `http: ^1.1.0` - HTTP client for API calls
- `hive: ^2.2.3` - Local NoSQL database
- `hive_flutter: ^1.1.0` - Flutter integration for Hive
- `connectivity_plus: ^6.0.0` - Network connectivity monitoring
- `json_annotation: ^4.8.1` - JSON serialization annotations

### Dev Dependencies
- `hive_generator: ^2.0.1` - Code generation for Hive
- `build_runner: ^2.4.7` - Code generation runner
- `json_serializable: ^6.7.1` - JSON serialization code generation
- `flutter_lints: ^5.0.0` - Linting rules

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is available under the MIT License. See the LICENSE file for more info.

## Support

For support and questions, please open an issue in the GitHub repository.