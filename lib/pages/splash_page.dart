import 'dart:async';

import 'package:bitespot/pages/home_page.dart';
import 'package:bitespot/pages/sign_up_page.dart';
import 'package:bitespot/providers/auth_provider.dart';
import 'package:bitespot/utils/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _timer;
  AuthProvider? _provider;
  @override
  void initState() {
    super.initState();
    AuthProvider provider = AuthProvider();
    _timer = Timer(const Duration(seconds: 2), () async {
      if (await authCheck()) {
        provider.getUserData();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SignUpPage()),
          (route) => false,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<bool> authCheck() async {
    return await context.read<AuthProvider>().authCheck();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceBright,
      body: Center(child: Image.asset(AssetConstants.bitespotTransparent)),
    );
  }
}
