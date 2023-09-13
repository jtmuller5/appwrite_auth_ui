![Appwrite Auth UI](https://github.com/jtmuller5/appwrite_auth_ui/raw/main/assets/appwrite_social.png)

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

## Email Auth

Use a `AppwriteEmailAuth` widget to create an email and password signin/ signup form.
It also contains a button to toggle to display a forgot password form.

```dart
AppwriteEmailAuth(
  redirectUrl: const String.fromEnvironment('APPWRITE_MAGIC_LINK_URL'),
  onSignInComplete: (response) {
    Navigator.of(context).pushReplacementNamed('/home');
  },
  onSignUpComplete: (response) {
    Navigator.of(context).pushReplacementNamed('/home');
  },
  metadataFields: [
    MetaDataField(
      prefixIcon: const Icon(Icons.person),
      label: 'Username',
      key: 'username',
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'Please enter something';
        }
        return null;
      },
    ),
  ],
),
```

## Magic Link Auth

Use `AppwriteMagicAuth` widget to create a magic link signIn form.
```dart
AppwriteMagicAuth(
     onSuccess: (response) {
        // do something, for example: 
        // Navigator.of(context).pushReplacementNamed('/home');
     },
     onError: (error) {
        // Do something with the error
     },
     redirectUrl: kIsWeb
     ? null
     : 'io.appwrite.flutterquickstart://login-callback',
),
```

## Reset password

Use `AppwriteResetPassword` to create a password reset form.

```dart
AppwriteResetPassword(                                   
  onError: (error) {                                     
    // Do something with the error                       
  },                                                     
  onSuccess: (response) {                                
    Navigator.of(context).pushReplacementNamed('/home');
  },                                                     
),                                                        
```

## Social Auth

Use `AppwriteSocialsAuth` to create list of social login buttons.
```agsl
AppwriteSocialsAuth(
    colored: true,
    socialProviders: SocialProviders.values,
    onSuccess: (session) {
      Navigator.of(context).pushReplacementNamed('/home');
    },
    onError: (error) {
      // Do something with the error
    },
)
```

## Theming

This library uses bare Flutter components so that you can control the appearance of the components using your own theme.