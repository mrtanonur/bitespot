import 'package:bitespot/l10n/app_localizations.dart';
import 'package:bitespot/providers/auth_provider.dart';
import 'package:bitespot/utils/constants/asset_constants.dart';
import 'package:bitespot/widgets/bitespot_button.dart';
import 'package:bitespot/widgets/bitespot_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/constants/size_constants.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
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
    AuthStatus status = _provider!.status;
    if (status == AuthStatus.resetPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "Password reset link has been sent to your e-mail",
          ),
          backgroundColor: Theme.of(context).colorScheme.outline,
        ),
      );
    } else if (status == AuthStatus.failure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Something went wrong."),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.resetPassword),
        backgroundColor: Theme.of(context).colorScheme.surfaceBright,
      ),
      backgroundColor: Theme.of(context).colorScheme.surfaceBright,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            AssetConstants.bitespotTransparent,
            width: SizeConstants.s150,
          ),
          const SizedBox(height: SizeConstants.s24),
          const Text("Enter your e-mail to send you a password reset email"),
          const SizedBox(height: SizeConstants.s24),
          const ForgotPasswordForm(),
        ],
      ),
    );
  }
}

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.onUnfocus,
      key: _globalKey,
      child: Column(
        children: [
          BitespotTextFormfield(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.enterYourEmail;
              }
              return null;
            },
            controller: _emailController,
            hintText: AppLocalizations.of(context)!.email,
          ),
          const SizedBox(height: SizeConstants.s24),
          BitespotButton(
            onTap: () async {
              if (_globalKey.currentState!.validate()) {
                setState(() {
                  isLoading = true;
                });
                context.read<AuthProvider>().sendPasswordResetLink(
                  _emailController.text,
                );
                setState(() {
                  isLoading = false;
                });
              }
            },
            isLoading: isLoading,
            text: AppLocalizations.of(context)!.sendEmail,
          ),
        ],
      ),
    );
  }
}
