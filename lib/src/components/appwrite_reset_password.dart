import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:appwrite_auth_ui/src/utils/constants.dart';

/// UI component to create password reset form
class AppwriteResetPassword extends StatefulWidget {
  /// accessToken of the user
  final String? accessToken;

  /// Method to be called when the auth action is success
  final void Function(User response) onSuccess;

  /// Method to be called when the auth action threw an excepction
  final void Function(Object error)? onError;

  const AppwriteResetPassword({
    Key? key,
    this.accessToken,
    required this.onSuccess,
    this.onError,
  }) : super(key: key);

  @override
  State<AppwriteResetPassword> createState() => _AppwriteResetPasswordState();
}

class _AppwriteResetPasswordState extends State<AppwriteResetPassword> {
  final _formKey = GlobalKey<FormState>();
  final _password = TextEditingController();

  @override
  void dispose() {
    _password.dispose();
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
            validator: (value) {
              if (value == null || value.isEmpty || value.length < 6) {
                return 'Please enter a password that is at least 6 characters long';
              }
              return null;
            },
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.lock),
              label: Text('Enter your password'),
            ),
            controller: _password,
          ),
          spacer(16),
          ElevatedButton(
            child: const Text(
              'Update Password',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              if (!_formKey.currentState!.validate()) {
                return;
              }
              try {
                final response = await Account(appwrite).updatePassword(
                  password: _password.text,
                );
                widget.onSuccess.call(response);
              } on AppwriteException catch (error) {
                if (widget.onError == null) {
                  context.showErrorSnackBar(error.message ?? error.toString());
                } else {
                  widget.onError?.call(error);
                }
              } catch (error) {
                if (widget.onError == null) {
                  context.showErrorSnackBar('Unexpected error has occurred: $error');
                } else {
                  widget.onError?.call(error);
                }
              }
            },
          ),
          spacer(10),
        ],
      ),
    );
  }
}