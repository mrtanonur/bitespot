import 'package:bitespot/l10n/app_localizations.dart';
import 'package:bitespot/providers/auth_provider.dart';
import 'package:bitespot/utils/constants/size_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.profile)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: SizeConstants.s48),
        child: Column(
          children: [
            const SizedBox(height: SizeConstants.s36),
            const Icon(Icons.person, size: SizeConstants.s100),
            const SizedBox(height: SizeConstants.s48),
            profileInformation(
              "Email:",
              context.read<AuthProvider>().userData!.email,
            ),
          ],
        ),
      ),
    );
  }
}

Widget profileInformation(String left, String right) {
  return Row(
    children: [
      Text(
        left,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: SizeConstants.s16,
        ),
      ),
      const Spacer(),
      Text(right),
    ],
  );
}
