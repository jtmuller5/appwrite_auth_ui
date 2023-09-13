import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' hide Account;
import 'package:appwrite_auth_ui/src/utils/constants.dart';
import 'package:flutter/material.dart';

/// UI component for verifying phone number
class AppwriteVerifyPhone extends StatefulWidget {
  /// Method to be called when the auth action is success
  final void Function(Session session) onSuccess;

  /// Method to be called when the auth action threw an excepction
  final void Function(Object error)? onError;

  const AppwriteVerifyPhone({
    Key? key,
    required this.onSuccess,
    this.onError,
  }) : super(key: key);

  @override
  State<AppwriteVerifyPhone> createState() => _AppwriteVerifyPhoneState();
}

class _AppwriteVerifyPhoneState extends State<AppwriteVerifyPhone> {
  Map? data;
  final _formKey = GlobalKey<FormState>();
  final _code = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)?.settings.arguments;
    if (args != null) data = args as Map;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the one time code sent';
              }
              return null;
            },
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.code),
              label: Text('Enter the code sent'),
            ),
            controller: _code,
          ),
          spacer(16),
          ElevatedButton(
            child: const Text(
              'Verify Phone',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              if (!_formKey.currentState!.validate()) {
                return;
              }
              try {
                final response = await Account(appwrite).updatePhoneSession(
                  userId:
                      await Account(appwrite).get().then((value) => value.$id),
                  secret: _code.text,
                );
                widget.onSuccess(response);
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
              if (mounted) {
                setState(() {
                  _code.text = '';
                });
              }
            },
          ),
          spacer(10),
        ],
      ),
    );
  }
}
