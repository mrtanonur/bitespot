import 'package:bitespot/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class IsOpen extends StatelessWidget {
  final bool isOpen;
  const IsOpen({super.key, required this.isOpen});

  @override
  Widget build(BuildContext context) {
    return Text(
      isOpen
          ? AppLocalizations.of(context)!.open
          : AppLocalizations.of(context)!.close,
      style: TextStyle(
        color: isOpen
            ? Theme.of(context).colorScheme.outline
            : Theme.of(context).colorScheme.error,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
