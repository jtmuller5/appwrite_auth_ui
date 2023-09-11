import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:appwrite_auth_ui/src/utils/constants.dart';

/// Social provider that are supported
enum SocialProviders {
  apple(
    iconData: FontAwesomeIcons.apple,
    btnBgColor: Colors.black,
    provider: Provider.apple,
  ),
  azure(
    iconData: FontAwesomeIcons.microsoft,
    btnBgColor: Colors.blueAccent,
    provider: Provider.azure,
  ),
  bitbucket(
    iconData: FontAwesomeIcons.bitbucket,
    btnBgColor: Colors.blue,
    provider: Provider.bitbucket,
  ),
  discord(
    iconData: FontAwesomeIcons.discord,
    btnBgColor: Colors.purple,
    provider: Provider.discord,
  ),
  facebook(
    iconData: FontAwesomeIcons.facebook,
    btnBgColor: Color(0xFF3b5998),
    provider: Provider.facebook,
  ),
  github(
    iconData: FontAwesomeIcons.github,
    btnBgColor: Colors.black,
    provider: Provider.github,
  ),
  gitlab(
    iconData: FontAwesomeIcons.gitlab,
    btnBgColor: Colors.deepOrange,
    provider: Provider.gitlab,
  ),
  google(
    iconData: FontAwesomeIcons.google,
    btnBgColor: Colors.white,
    provider: Provider.google,
  ),
  slack(
    iconData: FontAwesomeIcons.slack,
    btnBgColor: Colors.deepPurple,
    provider: Provider.slack,
  ),
  spotify(
    iconData: FontAwesomeIcons.spotify,
    btnBgColor: Colors.green,
    provider: Provider.spotify,
  ),
  twitch(
    iconData: FontAwesomeIcons.twitch,
    btnBgColor: Colors.purpleAccent,
    provider: Provider.twitch,
  ),
  twitter(
    iconData: FontAwesomeIcons.twitter,
    btnBgColor: Color(0xFF1DA1F2),
    provider: Provider.twitter,
  );

  const SocialProviders({
    required IconData iconData,
    required Color btnBgColor,
    required this.provider,
  })  : _iconData = iconData,
        _btnBgColor = btnBgColor;

  final IconData _iconData;
  final Color _btnBgColor;
  final Provider provider;

  String get capitalizedName => name[0].toUpperCase() + name.substring(1);
}

enum SocialButtonVariant {
  /// Displays the social login buttons horizontally with icons.
  icon,

  /// Displays the social login buttons vertically with icons and text labels.
  iconAndText,
}

/// UI Component to create social login form
class AppwriteSocialsAuth extends StatefulWidget {
  /// List of social providers to show in the form
  final List<SocialProviders> socialProviders;

  /// Whether or not to color the social buttons in their respecful colors
  ///
  /// You can control the appearance through `ElevatedButtonTheme` when set to false.
  final bool colored;

  /// Whether or not to show the icon only or icon and text
  final SocialButtonVariant socialButtonVariant;

  /// `successUrl` to be passed to the `.signIn()` or `signUp()` methods
  ///
  /// Typically used to pass a DeepLink
  final String? successUrl;

  /// `failureUrl` to be passed to the `.signIn()` or `signUp()` methods
  ///
  /// Typically used to pass a DeepLink
  final String? failureUrl;

  /// Method to be called when the auth action is success
  final void Function(Session) onSuccess;

  /// Method to be called when the auth action threw an excepction
  final void Function(Object error)? onError;

  /// Whether to show a SnackBar after a successful sign in
  final bool showSuccessSnackBar;

  const AppwriteSocialsAuth({
    Key? key,
    required this.socialProviders,
    this.colored = true,
    this.successUrl,
    required this.onSuccess,
    this.onError,
    this.socialButtonVariant = SocialButtonVariant.iconAndText,
    this.showSuccessSnackBar = true,
    this.failureUrl,
  }) : super(key: key);

  @override
  State<AppwriteSocialsAuth> createState() => _AppwriteSocialsAuthState();
}

class _AppwriteSocialsAuthState extends State<AppwriteSocialsAuth> {
  @override
  Widget build(BuildContext context) {
    final providers = widget.socialProviders;
    final coloredBg = widget.colored == true;

    if (providers.isEmpty) {
      return ErrorWidget(Exception('Social provider list cannot be empty'));
    }

    final authButtons = List.generate(
      providers.length,
      (index) {
        final socialProvider = providers[index];

        Color? foregroundColor = coloredBg ? Colors.white : null;
        Color? backgroundColor = coloredBg ? socialProvider._btnBgColor : null;
        Color? overlayColor = coloredBg ? Colors.white10 : null;

        Color? iconColor = coloredBg ? Colors.white : null;

        Widget iconWidget = SizedBox(
          height: 48,
          width: 48,
          child: Icon(
            socialProvider._iconData,
            color: iconColor,
          ),
        );

        if (socialProvider == SocialProviders.google && coloredBg) {
          iconWidget = Image.asset(
            'assets/logos/google_light.png',
            package: 'appwrite_auth_ui',
            width: 48,
            height: 48,
          );

          foregroundColor = Colors.black;
          backgroundColor = Colors.white;
          overlayColor = Colors.white;
        }

        onAuthButtonPressed() async {
          try {
            var session = await Account(appwrite).createOAuth2Session(
              provider: socialProvider.provider.name,
              failure: widget.failureUrl,
              success: widget.successUrl,
            );

            if (session != null && mounted) {
              widget.onSuccess.call(session);
              if (widget.showSuccessSnackBar) {
                context.showSnackBar('Successfully signed in!');
              }
            }
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
        }

        final authButtonStyle = ButtonStyle(
          foregroundColor: MaterialStateProperty.all(foregroundColor),
          backgroundColor: MaterialStateProperty.all(backgroundColor),
          overlayColor: MaterialStateProperty.all(overlayColor),
          iconColor: MaterialStateProperty.all(iconColor),
        );

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: widget.socialButtonVariant == SocialButtonVariant.icon
              ? Material(
                  shape: const CircleBorder(),
                  elevation: 2,
                  color: backgroundColor,
                  child: InkResponse(
                    radius: 24,
                    onTap: onAuthButtonPressed,
                    child: iconWidget,
                  ),
                )
              : ElevatedButton.icon(
                  icon: iconWidget,
                  style: authButtonStyle,
                  onPressed: onAuthButtonPressed,
                  label: Text('Continue with ${socialProvider.capitalizedName}'),
                ),
        );
      },
    );

    return widget.socialButtonVariant == SocialButtonVariant.icon
        ? Wrap(
            alignment: WrapAlignment.spaceEvenly,
            children: authButtons,
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: authButtons,
          );
  }
}
