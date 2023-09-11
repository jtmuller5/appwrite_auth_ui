import 'package:flutter/material.dart';
import 'package:appwrite_auth_ui/appwrite_auth_ui.dart';

import 'constants.dart';

class VerifyPhone extends StatelessWidget {
  const VerifyPhone({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('Verify Phone'),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            AppwriteVerifyPhone(
              onSuccess: (response) {
                Navigator.of(context).pushReplacementNamed('/home');
              },
            ),
            TextButton(
              child: const Text(
                'Forgot Password? Click here',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/forgot_password');
              },
            ),
            TextButton(
              child: const Text(
                'Take me back to Sign Up',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
            ),
          ],
        ),
      ),
    );
  }
}
