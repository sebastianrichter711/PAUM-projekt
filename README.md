# Mobile App Design (Projektowanie aplikacji dla urządzeń mobilnych) - project

Authors: 
- Piotr **SOROCIAK**
- Sebastian **RICHTER**

## Project's aim
Implementation of mobile app supporting healthy lifestyle with the use of tracking sports 
activity and life parameters such as blood pressure, heart rate level, body temperature, etc.

## Instruction to launch the app
1. Clone the repository - open the command line in a chosen directory in your laptop/PC and write a command:
```js
git clone <URL_to_repository>
```
You can copy a link to repository from the page of repo (click "Code" button and later copy a shown link).

2. In a command line type:
```js
cd PAUM-projekt\healthcareapp
```
3. Connect a mobile device to your laptop/PC - make sure developer options in your mobile device are enabled and you allowed
USB debugging.
4. In a command line type:
```js
flutter run
```

## Available options in the app
- Main widget: 
    - calendar,
    - info about today's number of steps, 
    - plot presenting number of steps in the last week, 
    - stats presenting:
        - number of calories burned today, 
        - distance walked today, 
        - today's cardio minutes,
        - last measurements of: body temperature, blood glucose and heart rate.
- Track number of steps, calories and distance (stats for today, current week and showing average number of steps/calories and average distance per day in a current week).
- Track life parameters: heart rate, blood glucose and body temperature (plots for each parameter presenting data from the past week with the option of adding a measurement).
- Track length of sleep (plot presenting the length of sleep in the past week with the option of adding a measurement).
- BMI calcuator

## Technologies
- framework: Flutter 3.3.8
- programming language: Dart 2.18.4 (all installed Flutter's libraries in this project are listed in a file pubspec.yaml in "healthcareapp"
directory (section "dependencies"))
- IDE: Visual Studio Code 1.75.0
- Android SDK 33.0.0
- Fitness API

It is recommend to use the app in a mobile device with Android 12 or higher.

## License

Licensed under the [MIT License](LICENSE).
