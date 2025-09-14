import 'package:bitespot/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

extension ThemeExtension on ThemeMode {
  String localizedText(BuildContext context) {
    switch (this) {
      case ThemeMode.system:
        return AppLocalizations.of(context)!.system;
      case ThemeMode.light:
        return AppLocalizations.of(context)!.light;
      case ThemeMode.dark:
        return AppLocalizations.of(context)!.dark;
    }
  }
}
