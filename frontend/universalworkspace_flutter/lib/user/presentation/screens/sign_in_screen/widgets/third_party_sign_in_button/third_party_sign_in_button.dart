import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace_ui/universalworkspace_ui.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

enum ThirdPartySignInButtonType {
  apple,
  google,
  github,
  discord,
  anonymous;

  String get provider {
    switch (this) {
      case ThirdPartySignInButtonType.apple:
        return 'apple';
      case ThirdPartySignInButtonType.google:
        return 'google';
      case ThirdPartySignInButtonType.github:
        return 'github';
      case ThirdPartySignInButtonType.discord:
        return 'discord';
      case ThirdPartySignInButtonType.anonymous:
        throw UnsupportedError('Anonymous session does not have a provider');
    }
  }

  UniflowSvgData get icon {
    switch (this) {
      case ThirdPartySignInButtonType.apple:
        return UniflowSvgs.m_apple_icon_xl;
      case ThirdPartySignInButtonType.google:
        return UniflowSvgs.m_google_icon_xl;
      case ThirdPartySignInButtonType.github:
        return UniflowSvgs.m_github_icon_xl;
      case ThirdPartySignInButtonType.discord:
        return UniflowSvgs.m_discord_icon_xl;
      case ThirdPartySignInButtonType.anonymous:
        return UniflowSvgs.m_discord_icon_xl;
    }
  }

  String get labelText {
    switch (this) {
      case ThirdPartySignInButtonType.apple:
        return LocaleKeys.signIn_signInWithApple.tr();
      case ThirdPartySignInButtonType.google:
        return LocaleKeys.signIn_signInWithGoogle.tr();
      case ThirdPartySignInButtonType.github:
        return LocaleKeys.signIn_signInWithGithub.tr();
      case ThirdPartySignInButtonType.discord:
        return LocaleKeys.signIn_signInWithDiscord.tr();
      case ThirdPartySignInButtonType.anonymous:
        return 'Anonymous session';
    }
  }

  // https://developer.apple.com/design/human-interface-guidelines/sign-in-with-apple
  Color backgroundColor(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    switch (this) {
      case ThirdPartySignInButtonType.apple:
        return isDarkMode ? Colors.white : Colors.black;
      case ThirdPartySignInButtonType.google:
      case ThirdPartySignInButtonType.github:
      case ThirdPartySignInButtonType.discord:
      case ThirdPartySignInButtonType.anonymous:
        return isDarkMode ? Colors.black : Colors.grey.shade100;
    }
  }

  Color textColor(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    switch (this) {
      case ThirdPartySignInButtonType.apple:
        return isDarkMode ? Colors.black : Colors.white;
      case ThirdPartySignInButtonType.google:
      case ThirdPartySignInButtonType.github:
      case ThirdPartySignInButtonType.discord:
      case ThirdPartySignInButtonType.anonymous:
        return isDarkMode ? Colors.white : Colors.black;
    }
  }

  BlendMode? get blendMode {
    switch (this) {
      case ThirdPartySignInButtonType.apple:
      case ThirdPartySignInButtonType.github:
        return BlendMode.srcIn;
      default:
        return null;
    }
  }
}

class MobileThirdPartySignInButton extends StatelessWidget {
  const MobileThirdPartySignInButton({
    super.key,
    this.height = 38,
    this.fontSize = 14.0,
    required this.onTap,
    required this.type,
  });

  final VoidCallback onTap;
  final double height;
  final double fontSize;
  final ThirdPartySignInButtonType type;

  @override
  Widget build(BuildContext context) {
    return AFOutlinedIconTextButton.normal(
      text: type.labelText,
      onTap: onTap,
      size: AFButtonSize.l,
      iconBuilder: (context, isHovering, disabled) {
        return UniflowSvg(
          type.icon,
          size: Size.square(16),
          blendMode: type.blendMode,
        );
      },
    );
  }
}

class DesktopThirdPartySignInButton extends StatelessWidget {
  const DesktopThirdPartySignInButton({
    super.key,
    required this.type,
    required this.onTap,
  });

  final ThirdPartySignInButtonType type;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AFOutlinedIconTextButton.normal(
      text: type.labelText,
      onTap: onTap,
      size: AFButtonSize.l,
      iconBuilder: (context, isHovering, disabled) {
        return UniflowSvg(
          type.icon,
          size: Size.square(18),
          blendMode: type.blendMode,
        );
      },
    );
  }
}
