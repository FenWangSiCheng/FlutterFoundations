# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Flutter Environment
This project uses FVM (Flutter Version Management) with Flutter 3.35.4. Always prefix Flutter commands with `fvm`:

- `fvm flutter pub get` - Install dependencies
- `fvm flutter pub deps` - Show dependency tree
- `fvm flutter clean && fvm flutter pub get` - Clean and reinstall dependencies

### Code Generation
The project uses injectable for dependency injection with build_runner:
- `fvm flutter packages pub run build_runner build` - Generate dependency injection code
- `fvm flutter packages pub run build_runner build --delete-conflicting-outputs` - Force regenerate

### Running the App
Multi-flavor setup using dart-define-from-file:
- `fvm flutter run --flavor dev --dart-define-from-file=dart_defines/dev.json` - Development
- `fvm flutter run --flavor stg --dart-define-from-file=dart_defines/stg.json` - Staging
- `fvm flutter run --flavor prod --dart-define-from-file=dart_defines/prod.json` - Production

### Building
- `fvm flutter build apk --flavor dev --dart-define-from-file=dart_defines/dev.json` - Development APK
- `fvm flutter build apk --flavor stg --dart-define-from-file=dart_defines/stg.json` - Staging APK
- `fvm flutter build apk --flavor prod --dart-define-from-file=dart_defines/prod.json` - Production APK
- `fvm flutter build ios --flavor prod --dart-define-from-file=dart_defines/prod.json` - Production iOS build

### Analysis and Testing
- `fvm flutter analyze` - Static analysis (required before commits)
- `fvm flutter test` - Run unit tests
- `fvm flutter test test/specific_test.dart` - Run a single test file
- `dart format .` - Format code

## Architecture

### Clean Architecture Structure
The codebase follows Clean Architecture principles with clear separation of concerns:

```
lib/
├── domain/          # Business logic layer
│   ├── entities/    # Core business objects (User)
│   ├── repositories/    # Abstract repository interfaces
│   └── usecase/     # Business use cases
├── data/           # Data layer
│   ├── datasource/  # Remote/local data sources
│   ├── models/      # Data transfer objects with toEntity() methods
│   └── repositories/    # Repository implementations
├── manage/         # Infrastructure/framework layer
│   ├── api/        # HTTP client configuration and interceptors
│   └── client.dart # Dio HTTP client setup with proxy support
├── pages/          # Presentation layer (UI)
├── systems/        # Cross-cutting concerns (logging, etc.)
└── res/           # Resources and constants
```

### Dependency Injection
Uses `get_it` with `injectable` for dependency injection:
- `injection.dart` - Main DI configuration
- `injection.config.dart` - Generated DI registration (auto-generated)
- All services registered with `@Injectable()` annotations
- Repositories injected as interfaces using `@Injectable(as: Interface)`

### Multi-Flavor Configuration
- `app_config.dart` - Contains Flavor enum and all configuration logic
- `dart_defines/` - JSON configuration files for each flavor:
  - `dev.json` - Development environment (flavor: "dev")
  - `stg.json` - Staging environment (flavor: "stg")
  - `prod.json` - Production environment (flavor: "prod")
- `AppConfig.currentFlavor` - Current flavor accessor
- `AppConfig.isProduction` - Production environment check
- `AppConfig.initializeFlavor()` - Initializes flavor from `flavor` dart-define variable
- `AppConfig.flavorTitle` - Human-readable flavor title for UI
- All dart-define fields use snake_case naming: `app_name`, `base_url`, `mock_api_data_source`, `is_need_proxy`
- Supports both full names (develop/staging/production) and short forms (dev/stg/prod)

### HTTP Client Setup
Located in `manage/client.dart`:
- Dio HTTP client with environment-specific base URLs
- Custom CA certificate loading for security
- System proxy detection and configuration
- Auth interceptor for request authentication
- Debug logging in development mode
- Proxy bypass for non-production environments

### Key Dependencies
- `dio` - HTTP client
- `flutter_bloc` - State management
- `get_it` + `injectable` - Dependency injection
- `shared_preferences` - Local storage
- `flutter_inappwebview` - WebView integration
- `mockito` - Mocking for unit tests
- `build_runner` - Code generation

## Important Notes

- Always run `fvm flutter analyze` before committing changes
- The project structure mirrors Clean Architecture - respect layer boundaries
- Use the existing DI container rather than creating manual dependencies
- Follow the established naming conventions: UpperCamelCase for types, lowerCamelCase for members
- Flavor-specific resources are organized in platform folders (android/ios have flavor subdirectories)
- Certificate pinning is configured - CA certificate located in `assets/ca/`