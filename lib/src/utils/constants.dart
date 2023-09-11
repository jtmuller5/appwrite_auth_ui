import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';

final appwrite =
    Client().setEndpoint('https://cloud.appwrite.io/v1').setProject(
          const String.fromEnvironment('APPWRITE_PROJECT_ID'),
        );

SizedBox spacer(double height) {
  return SizedBox(
    height: height,
  );
}

enum Provider {
  apple,
  azure,
  bitbucket,
  discord,
  facebook,
  github,
  gitlab,
  google,
  kakao,
  keycloak,
  linkedin,
  notion,
  slack,
  spotify,
  twitch,
  twitter,
  workos;
}

/// Set of extension methods to easily display a snackbar
extension ShowSnackBar on BuildContext {
  /// Displays a basic snackbar
  void showSnackBar(
    String message, {
    Color? textColor,
    Color? backgroundColor,
    String? actionLabel,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(
        message,
        style: textColor == null ? null : TextStyle(color: textColor),
      ),
      backgroundColor: backgroundColor,
      action: SnackBarAction(
        label: actionLabel ?? 'ok',
        onPressed: () {},
      ),
    ));
  }

  /// Displays a red snackbar indicating error
  void showErrorSnackBar(
    String message, {
    String? actionLabel,
  }) {
    showSnackBar(
      message,
      textColor: Theme.of(this).colorScheme.onErrorContainer,
      backgroundColor: Theme.of(this).colorScheme.errorContainer,
      actionLabel: actionLabel,
    );
  }
}
