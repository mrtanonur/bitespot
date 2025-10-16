import 'package:bitespot/l10n/app_localizations.dart';
import 'package:bitespot/pages/sign_in_page.dart';
import 'package:bitespot/providers/auth_provider.dart';
import 'package:bitespot/utils/constants/size_constants.dart';
import 'package:bitespot/widgets/bitespot_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmailVerificationPage extends StatelessWidget {
  const EmailVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: SizeConstants.s24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(
                  context,
                )!.weHaveSentYouAnEmailForVerificationPleaseCheckYourEmail,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: SizeConstants.s20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.haventYouReceievedAnEmail,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      await context
                          .read<AuthProvider>()
                          .sendEmailVerificationLink();
                    },
                    child: Text(
                      AppLocalizations.of(context)!.sendAgain,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: SizeConstants.s20),
              BitespotButton(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const SignInPage()),
                    (route) => false,
                  );
                },
                text: AppLocalizations.of(context)!.signIn,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
