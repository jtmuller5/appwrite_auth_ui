import 'package:flutter/material.dart';
import 'package:appwrite_auth_ui/appwrite_auth_ui.dart';

import 'constants.dart';

class PhoneSignIn extends StatelessWidget {
  const PhoneSignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('Phone Sign In'),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            AppwritePhoneAuth(
              authAction: AppwriteAuthAction.signIn,
              onSuccess: (response) {
                Navigator.of(context).pushReplacementNamed('/home');
              },
            ),
            TextButton(
              child: const Text(
                'Don\'t have an account? Sign Up',
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
