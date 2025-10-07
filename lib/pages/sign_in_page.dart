import 'package:bitespot/l10n/app_localizations.dart';
import 'package:bitespot/local_data_source/main_local_data_source.dart';
import 'package:bitespot/pages/forgot_password.dart';
import 'package:bitespot/pages/home_page.dart';
import 'package:bitespot/pages/sign_up_page.dart';
import 'package:bitespot/providers/auth_provider.dart';
import 'package:bitespot/utils/constants/asset_constants.dart';
import 'package:bitespot/utils/constants/size_constants.dart';
import 'package:bitespot/widgets/bitespot_auth_button.dart';
import 'package:bitespot/widgets/bitespot_button.dart';
import 'package:bitespot/widgets/bitespot_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
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
    if (status == AuthStatus.loggedIn) {
      _provider!.getUserData();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else if (status == AuthStatus.failure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_provider!.error!),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } else if (status == AuthStatus.unverifiedEmail) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.pleaseVerifyYourEmail),
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
                width: SizeConstants.s150,
              ),
              const SizedBox(height: SizeConstants.s12),
              const SignInForm(),
              const SizedBox(height: SizeConstants.s48),
              const AuthSingIn(),
            ],
          ),
        ),
      ),
    );
  }
}

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    rememberMe = MainLocalDataSource.read('remember_me') ?? false;

    if (rememberMe) {
      _emailController.text = MainLocalDataSource.read('email');
      _passwordController.text = MainLocalDataSource.read('password');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
            obscureText: false,
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: SizeConstants.s24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Checkbox(
                  value: rememberMe,
                  onChanged: (value) {
                    setState(() {
                      rememberMe = value!;
                    });
                    MainLocalDataSource.add('remember_me', value);
                  },
                ),
                Text(AppLocalizations.of(context)!.rememberMe),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPassword(),
                      ),
                    );
                  },
                  child: Text(AppLocalizations.of(context)!.forgotPassword),
                ),
              ],
            ),
          ),
          const SizedBox(height: SizeConstants.s24),
          BitespotButton(
            onTap: () async {
              if (_globalKey.currentState!.validate()) {
                setState(() {
                  isLoading = true;
                });
                await context.read<AuthProvider>().signIn(
                  _emailController.text,
                  _passwordController.text,
                );
                if (MainLocalDataSource.read('remember_me') != null) {
                  if (MainLocalDataSource.read('remember_me')) {
                    MainLocalDataSource.add('email', _emailController.text);
                    MainLocalDataSource.add(
                      'password',
                      _passwordController.text,
                    );
                  } else {
                    MainLocalDataSource.delete('email');
                    MainLocalDataSource.delete('password');
                  }
                }
                setState(() {
                  isLoading = false;
                });
              }
            },
            isLoading: isLoading,
            text: AppLocalizations.of(context)!.signIn,
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
        const SizedBox(height: SizeConstants.s36),
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
        const SizedBox(height: SizeConstants.s36),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppLocalizations.of(context)!.notAMember),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpPage()),
                );
              },
              child: Text(AppLocalizations.of(context)!.signUpNow),
            ),
          ],
        ),
      ],
    );
  }
}
