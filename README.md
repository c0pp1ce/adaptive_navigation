<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->
# Adaptive navigation scaffold

This package provides a widget which can display different types of navigation based on the screen size.

## Features

- Customizable breakpoints
- Customizable navigation widgets

<img src="https://raw.githubusercontent.com/c0pp1ce/adaptive_navigation_scaffold/main/example/gifs/adaptive_nav_demo.gif" alt="Gif of the widget in action." width="800">

#### Supported navigation types

- bottom navigation bar
- drawer
- rail / extended rail
- permanent drawer

If the destination count exceeds the allowed amount for **bottom** and **rail** navigation
a drawer containing the remaining destinations is added.

<img src="https://raw.githubusercontent.com/c0pp1ce/adaptive_navigation_scaffold/main/example/screenshots/bottom_nav.jpg" width="200">
<img src="https://raw.githubusercontent.com/c0pp1ce/adaptive_navigation_scaffold/main/example/screenshots/drawer.jpg" width="202"><br>
<img src="https://raw.githubusercontent.com/c0pp1ce/adaptive_navigation_scaffold/main/example/screenshots/rail.jpg" width="350">
<img src="https://raw.githubusercontent.com/c0pp1ce/adaptive_navigation_scaffold/main/example/screenshots/rail_extended.jpg" width="324"><br>
<img src="https://raw.githubusercontent.com/c0pp1ce/adaptive_navigation_scaffold/main/example/screenshots/drawer_permanent.jpg" width="700">

## Usage

Usage showcased in the `/example/lib/main.dart`.
