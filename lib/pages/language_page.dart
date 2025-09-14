import 'package:bitespot/l10n/app_localizations.dart';
import 'package:bitespot/providers/main_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/constants/constants.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceBright,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.language),
        backgroundColor: Theme.of(context).colorScheme.surfaceBright,
      ),
      body: Padding(
        padding: const EdgeInsets.all(SizeConstants.s24),
        child: Column(
          children: [
            Row(
              children: [
                Checkbox.adaptive(
                  value: context.watch<MainProvider>().language == Languages.en,
                  onChanged: (value) {
                    context.read<MainProvider>().changeLanguage(Languages.en);
                  },
                ),
                const SizedBox(width: SizeConstants.s8),
                const Text(
                  "English",
                  style: TextStyle(fontSize: SizeConstants.s24),
                ),
              ],
            ),
            Row(
              children: [
                Checkbox.adaptive(
                  value: context.watch<MainProvider>().language == Languages.tr,
                  onChanged: (value) {
                    context.read<MainProvider>().changeLanguage(Languages.tr);
                  },
                ),
                const SizedBox(width: SizeConstants.s8),
                const Text(
                  "Turkish",
                  style: TextStyle(fontSize: SizeConstants.s24),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
