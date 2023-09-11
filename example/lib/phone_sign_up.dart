import 'package:flutter/material.dart';
import 'package:appwrite_auth_ui/appwrite_auth_ui.dart';

import 'constants.dart';

class PhoneSignUp extends StatelessWidget {
  const PhoneSignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('Phone Sign Up'),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            AppwritePhoneAuth(
              authAction: AppwriteAuthAction.signUp,
              onSuccess: (response) {
                Navigator.of(context).pushReplacementNamed('/verify_phone');
              },
            ),
            TextButton(
              child: const Text(
                'Already have an account? Sign In',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('/sign_in');
              },
            ),
          ],
        ),
      ),
    );
  }
}
