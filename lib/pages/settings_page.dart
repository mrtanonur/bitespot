import 'package:bitespot/l10n/app_localizations.dart';
import 'package:bitespot/pages/language_page.dart';
import 'package:bitespot/pages/profile_page.dart';
import 'package:bitespot/pages/sign_in_page.dart';
import 'package:bitespot/pages/theme_page.dart';
import 'package:bitespot/providers/auth_provider.dart';
import 'package:bitespot/providers/main_provider.dart';
import 'package:bitespot/utils/constants/size_constants.dart';
import 'package:bitespot/widgets/bitespot_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  AuthProvider? _provider;
  @override
  void initState() {
    super.initState();
    _provider = context.read<AuthProvider>();
    _provider!.addListener(_authListener);
  }

  @override
  void dispose() {
    _provider!.removeListener(_authListener);
    super.dispose();
  }

  void _authListener() {
    final status = context.read<AuthProvider>().status;
    if (status == AuthStatus.signOut) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignInPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceBright,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
        backgroundColor: Theme.of(context).colorScheme.surfaceBright,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: SizeConstants.s24),
        child: Column(
          children: [
            settingsTile(
              context,
              const ProfilePage(),
              Icons.person,
              AppLocalizations.of(context)!.profile,
            ),
            settingsTile(
              context,
              const ThemePage(),
              Icons.contrast,
              AppLocalizations.of(context)!.theme,
            ),
            settingsTile(
              context,
              const LanguagePage(),
              Icons.language,
              AppLocalizations.of(context)!.language,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: SizeConstants.s24),
              child: BitespotButton(
                onTap: () {
                  context.read<AuthProvider>().signOut();
                  context.read<MainProvider>().resetNavigationIndex();
                },
                text: AppLocalizations.of(context)!.signOut,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget settingsTile(
  BuildContext context,
  Widget page,
  IconData leadingIcon,
  String title,
) {
  return ListTile(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => page));
    },
    leading: Icon(leadingIcon),
    title: Text(title),
    trailing: const Icon(Icons.chevron_right),
  );
}
