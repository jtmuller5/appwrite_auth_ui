A simple library of predefined widgets to easily and quickly create auth components using Flutter and Appwrite.

## Disclaimer
The newest version of the [appwrite](https://pub.dev/packages/appwrite) package is designed to work with Appwrite 1.4.0. Appwrite Cloud is currently using Appwrite 1.1.2. As a result, this package uses Appwrite 9.0.1. You can track the progress of this issue [here](https://github.com/appwrite/sdk-for-flutter/issues/173).

## Getting Started
Create a config.json file in your `assets` folder and add the following fields:
```json
{
  "APPWRITE_PROJECT_ID": "",
  "APPWRITE_MAGIC_LINK_URL": ""
}
```

Run your app using the following command:
```bash
flutter run --dart-define-from-file=assets/config.json
```

