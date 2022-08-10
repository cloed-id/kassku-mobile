# kassku_mobile

A new Flutter project.

## Build APK/aab
> flutter build apk --flavor production -t lib/main.dart
> flutter build appbundle --flavor production -t lib/main.dart

## Build Web
> flutter build web --web-renderer html --release -t lib/main.dart

## Watch Serialize Model
> flutter pub run build_runner watch --delete-conflicting-outputs

> flutter pub run build_runner build --delete-conflicting-outputs

## Generate Assets
> fluttergen

## Generate Icon
> flutter pub run flutter_launcher_icons:main

## Generate splash screen
> flutter pub run flutter_native_splash:create

## Check and upgrade dependencies
> flutter pub outdated
> flutter pub upgrade --major-versions

## Mason Command
> mason get
> mason make transtrack_mobile_template --on-conflict overwrite && sh runme.sh