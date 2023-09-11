import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:appwrite_auth_ui/src/utils/constants.dart';

/// UI component to create magic link login form
class AppwriteMagicAuth extends StatefulWidget {
  /// `redirectUrl` to be passed to the `.signIn()` or `signUp()` methods
  ///
  /// Typically used to pass a DeepLink
  final String? redirectUrl;

  /// Method to be called when the auth action is success
  final void Function(Session response) onSuccess;

  /// Method to be called when the auth action threw an excepction
  final void Function(Object error)? onError;

  const AppwriteMagicAuth({
    Key? key,
    this.redirectUrl,
    required this.onSuccess,
    this.onError,
  }) : super(key: key);

  @override
  State<AppwriteMagicAuth> createState() => _AppwriteMagicAuthState();
}

class _AppwriteMagicAuthState extends State<AppwriteMagicAuth> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            validator: (value) {
              if (value == null ||
                  value.isEmpty ||
                  !EmailValidator.validate(_email.text)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.email),
              label: Text('Enter your email'),
            ),
            controller: _email,
          ),
          spacer(16),
          ElevatedButton(
            child: (_isLoading)
                ? SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(
                color: Theme
                    .of(context)
                    .colorScheme
                    .onPrimary,
                strokeWidth: 1.5,
              ),
            )
                : const Text(
              'Continue with magic Link',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              if (!_formKey.currentState!.validate()) {
                return;
              }
              setState(() {
                _isLoading = true;
              });
              try {
                await Account(appwrite).createMagicURLSession(
                  email: _email.text,
                  userId: await Account(appwrite).get().then((value) => value.$id),
                );
                if (mounted) {
                  context.showSnackBar('Check your email inbox!');
                }
              } on AppwriteException catch (error) {
                if (widget.onError == null) {
                  context.showErrorSnackBar(error.message ?? 'Error occurred');
                } else {
                  widget.onError?.call(error);
                }
              } catch (error) {
                if (widget.onError == null) {
                  context.showErrorSnackBar(
                      'Unexpected error has occurred: $error');
                } else {
                  widget.onError?.call(error);
                }
              }
              setState(() {
                _isLoading = false;
              });
            },
          ),
          spacer(10),
        ],
      ),
    );
  }
}