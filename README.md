# employ

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Requirements

- Flutter: Channel stable, 3.7.8
- Dart: 2.19.5
- Java: 1.8.0_361

## Running the app

- Run `flutter pub get` to install dependencies
- Run `flutter run lib\main_release.dart --flavor production` to run the app

## Build

- Run `flutter clean` to clean the project
- Run `flutter pub get` to install dependencies

### Demo
- Run `flutter build apk --flavor demo --release --dart-define FLAVOR=demo` to build the app
- Run `flutter build appbundle --flavor demo --release --dart-define FLAVOR=demo` to build the app
- Run `flutter build ipa --flavor demo --release --dart-define FLAVOR=demo` to build the app

### Production
- Run `flutter build apk --flavor production --release --dart-define FLAVOR=production` to build the app
- Run `flutter build appbundle --flavor production --release --dart-define FLAVOR=production` to build the app
- Run `flutter build ipa --flavor production --release --dart-define FLAVOR=production` to build the app