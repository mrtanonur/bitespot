import 'package:bitespot/l10n/app_localizations.dart';
import 'package:bitespot/pages/email_verification_page.dart';
import 'package:bitespot/pages/home_page.dart';
import 'package:bitespot/pages/sign_in_page.dart';
import 'package:bitespot/providers/auth_provider.dart';
import 'package:bitespot/widgets/bitespot_auth_button.dart';
import 'package:bitespot/widgets/bitespot_button.dart';
import 'package:bitespot/widgets/bitespot_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/constants/constants.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
    if (status == AuthStatus.verificationProcess) {
      _provider!.storeUserData();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const EmailVerificationPage()),
      );
    } else if (status == AuthStatus.failure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_provider!.error!),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceBright,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AssetConstants.bitespotTransparent,
                width: SizeConstants.s100,
              ),
              const SizedBox(height: SizeConstants.s36),
              const SignUpForm(),
              const SizedBox(height: SizeConstants.s48),
              const AuthSingIn(),
            ],
          ),
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
            controller: _emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.enterYourEmail;
              }
              return null;
            },
            hintText: AppLocalizations.of(context)!.email,
          ),
          const SizedBox(height: SizeConstants.s12),
          BitespotTextFormfield(
            controller: _passwordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.enterYourPassword;
              }
              return null;
            },
            hintText: AppLocalizations.of(context)!.password,
            obscureText: true,
          ),
          const SizedBox(height: SizeConstants.s12),
          BitespotTextFormfield(
            controller: _confirmPasswordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.repeatYourPassword;
              }
              return null;
            },
            hintText: AppLocalizations.of(context)!.confirmPassword,
            obscureText: true,
          ),
          const SizedBox(height: SizeConstants.s24),
          BitespotButton(
            onTap: () async {
              if (_globalKey.currentState!.validate()) {
                if (_confirmPasswordController.text ==
                    _passwordController.text) {
                  setState(() {
                    isLoading = true;
                  });
                  await context.read<AuthProvider>().signUp(
                    _emailController.text,
                    _passwordController.text,
                  );
                  setState(() {
                    isLoading = false;
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppLocalizations.of(
                          context,
                        )!.yourPasswordAndConfirmPasswordDontMatch,
                      ),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  );
                }
              }
            },

            isLoading: isLoading,
            text: AppLocalizations.of(context)!.signUp,
          ),
        ],
      ),
    );
  }
}

class AuthSingIn extends StatefulWidget {
  const AuthSingIn({super.key});

  @override
  State<AuthSingIn> createState() => _AuthSingInState();
}

class _AuthSingInState extends State<AuthSingIn> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: SizeConstants.s24),
          child: Row(
            children: [
              const Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: SizeConstants.s8,
                ),
                child: Text(AppLocalizations.of(context)!.orContinueWith),
              ),
              const Expanded(child: Divider()),
            ],
          ),
        ),
        const SizedBox(height: SizeConstants.s48),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BitespotAuthButton(
              imagePath: AssetConstants.googleLogo,
              height: 54,
              onTap: () async {
                await context.read<AuthProvider>().googleSignIn();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
            ),
            const SizedBox(width: SizeConstants.s4),
            BitespotAuthButton(
              imagePath: AssetConstants.appleLogo,
              height: 54,
              onTap: () async {
                await context.read<AuthProvider>().appleSignIn();
              },
            ),
          ],
        ),
        const SizedBox(height: SizeConstants.s48),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppLocalizations.of(context)!.notAMember),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInPage()),
                );
              },
              child: Text(AppLocalizations.of(context)!.signInNow),
            ),
          ],
        ),
      ],
    );
  }
}
