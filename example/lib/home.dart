import 'package:flutter/material.dart';
import 'package:appwrite_auth_ui/appwrite_auth_ui.dart';

import 'constants.dart';
import 'main.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('Home'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You are home',
              style: TextStyle(fontSize: 42),
            ),
            ElevatedButton(
              onPressed: () {
                Account(appwrite).deleteSessions();
                Navigator.of(context).pushReplacementNamed('/');
              },
              child: const Text(
                'Log Out',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
