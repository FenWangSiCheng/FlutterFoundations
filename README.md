# Flutter Foundations

**Clean Architecture in Flutter | BLoC | Dio**

A production-ready Flutter project template implementing Clean Architecture, BLoC state management, Dio HTTP client, multi-flavor configuration, dependency injection, and comprehensive development tooling.

## Features

- **Clean Architecture** with feature-first organization
- **Multi-flavor support** (Development, Staging, Production)
- **Dependency Injection** using get_it and injectable
- **State Management** with flutter_bloc
- **Mock API** support for offline development
- **Code Generation** for models, DI, and mocks
- **Comprehensive testing** setup with unit, widget, and integration tests
- **Proxy support** for development environments

## Prerequisites

- Flutter SDK: 3.35.4 (managed via FVM)
- Dart SDK: >=3.9.2 <4.0.0
- FVM (Flutter Version Management)

## Getting Started

### 1. Install FVM and Flutter

```bash
# Install FVM (if not already installed)
brew install fvm

# Install Flutter 3.35.4 via FVM
fvm install 3.35.4
fvm use 3.35.4
```

### 2. Install Dependencies

```bash
fvm flutter pub get
```

### 3. Generate Code

**Important**: Generated files (*.g.dart, *.freezed.dart, *.mocks.dart, *.config.dart) are NOT committed to Git. You MUST run code generation after cloning the repository:

```bash
fvm flutter packages pub run build_runner build
```

Or to force regenerate:

```bash
fvm flutter packages pub run build_runner build --delete-conflicting-outputs
```

### 4. Run the App

```bash
# Development flavor
fvm flutter run --flavor dev --dart-define-from-file=dart_defines/dev.json

# Staging flavor
fvm flutter run --flavor stg --dart-define-from-file=dart_defines/stg.json

# Production flavor
fvm flutter run --flavor prod --dart-define-from-file=dart_defines/prod.json
```

## Project Structure

```
lib/
├── features/                    # Feature modules (feature-first organization)
│   └── user/                    # Example: User feature
│       ├── domain/              # Business logic layer
│       │   ├── entities/        # Core business objects
│       │   ├── repositories/    # Abstract repository interfaces
│       │   └── usecase/         # Business use cases
│       ├── data/                # Data layer
│       │   ├── datasource/      # Remote/local data sources
│       │   ├── models/          # Data transfer objects
│       │   └── repositories/    # Repository implementations
│       └── presentation/        # UI layer
│           └── pages/           # Feature-specific pages
└── core/                        # Shared/cross-cutting concerns
    ├── config/                  # App configuration (flavors, environment)
    ├── network/                 # HTTP client, interceptors, error handling
    ├── injection/               # Dependency injection configuration
    ├── widgets/                 # Shared widgets
    └── constants/               # App-wide constants
```

## Development Commands

### Code Generation
```bash
# Generate all code (DI, models, mocks)
fvm flutter packages pub run build_runner build

# Force regenerate
fvm flutter packages pub run build_runner build --delete-conflicting-outputs
```

### Building
```bash
# Development APK
fvm flutter build apk --flavor dev --dart-define-from-file=dart_defines/dev.json

# Staging APK
fvm flutter build apk --flavor stg --dart-define-from-file=dart_defines/stg.json

# Production APK
fvm flutter build apk --flavor prod --dart-define-from-file=dart_defines/prod.json

# Production iOS build
fvm flutter build ios --flavor prod --dart-define-from-file=dart_defines/prod.json
```

### Analysis and Testing
```bash
# Static analysis (required before commits)
fvm flutter analyze

# Run all unit tests
fvm flutter test

# Run tests with coverage
fvm flutter test --coverage

# Run a specific test file
fvm flutter test test/specific_test.dart

# Run tests for a specific feature
fvm flutter test test/features/user/

# Format code
dart format .
```

### Cleaning
```bash
# Clean and reinstall dependencies
fvm flutter clean && fvm flutter pub get
```

## Architecture

### Clean Architecture Layers

1. **Domain Layer** (Business Logic)
   - Entities: Core business objects
   - Repositories: Abstract interfaces
   - Use Cases: Business rules and logic
   - No dependencies on other layers

2. **Data Layer** (Data Management)
   - Data Sources: Remote/local data access
   - Models: Data transfer objects with toEntity() methods
   - Repository Implementations: Concrete implementations of domain repositories
   - Depends only on domain layer

3. **Presentation Layer** (UI)
   - Pages: UI screens
   - BLoC: State management (Events, States, BLoC)
   - Depends on domain and data layers

### State Management

Uses `flutter_bloc` following the BLoC pattern:
- **Events**: User actions or system events
- **States**: UI states (Initial, Loading, Loaded, Error)
- **BLoC**: Transforms events into states

### Dependency Injection

- Uses `get_it` with `injectable` for DI
- All services registered with `@Injectable()` annotations
- Configuration in `core/injection/injection.dart`
- Auto-generated registration via build_runner

### Multi-Flavor Configuration

Three flavors configured via dart-define-from-file:
- **dev**: Development environment with mock API support
- **stg**: Staging environment
- **prod**: Production environment

Configuration files: `dart_defines/dev.json`, `dart_defines/stg.json`, `dart_defines/prod.json`

### HTTP Client & Mock API

- Dio HTTP client with environment-specific base URLs
- Mock API adapter using `http_mock_adapter` (enabled in dev flavor)
- System proxy detection and configuration
- Auth interceptor for request authentication
- Debug logging in development mode

## Key Dependencies

- **dio** - HTTP client
- **flutter_bloc** - State management
- **get_it** + **injectable** - Dependency injection
- **shared_preferences** - Local storage
- **flutter_inappwebview** - WebView integration
- **freezed** - Immutable data classes
- **json_serializable** - JSON serialization
- **mockito** - Mocking for unit tests
- **build_runner** - Code generation
- **http_mock_adapter** - Mock HTTP responses
- **native_flutter_proxy** - System proxy detection

## Testing

### Test Organization
- Mirror the `lib/` structure in `test/` directory
- Unit tests for domain and data layers
- Widget tests for presentation layer
- Use `bloc_test` for testing BLoCs
- Target coverage: >80%

### Running Tests
```bash
# All tests
fvm flutter test

# With coverage
fvm flutter test --coverage

# Specific feature
fvm flutter test test/features/user/
```

## Contributing

1. Always run `fvm flutter analyze` before committing
2. Regenerate code after modifying annotations
3. Follow Clean Architecture layer boundaries
4. Keep feature code within its module
5. Use the existing DI container
6. Follow naming conventions: UpperCamelCase for types, lowerCamelCase for members
7. Add unit tests for new features
8. Data models should have toEntity() methods

## Error Handling

- Custom exception classes in `core/network/error/exception.dart`
- DioException conversion in `core/network/error/dio_error_handler.dart`
- Data sources throw custom exceptions
- Repositories propagate exceptions to use cases
- BLoCs catch exceptions and emit error states
- UI displays user-friendly error messages

## License

This project is private and not licensed for public use.