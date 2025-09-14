import 'dart:io';

import 'package:bitespot/l10n/app_localizations.dart';
import 'package:bitespot/providers/main_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BitespotBottomNavigationBar extends StatefulWidget {
  const BitespotBottomNavigationBar({super.key});

  @override
  State<BitespotBottomNavigationBar> createState() =>
      _BitespotBottomNavigationBarState();
}

class _BitespotBottomNavigationBarState
    extends State<BitespotBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return BottomNavigationBar(
        currentIndex: context.watch<MainProvider>().navigationIndex,
        onTap: (index) {
          context.read<MainProvider>().changeNavigationIndex(index);
        },
        items: [
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.maps,
            icon: const Icon(Icons.map),
          ),
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.favorites,
            icon: const Icon(Icons.favorite),
          ),
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.settings,
            icon: const Icon(Icons.settings),
          ),
        ],
      );
    } else {
      return CupertinoTabBar(
        currentIndex: context.watch<MainProvider>().navigationIndex,
        onTap: (index) {
          context.read<MainProvider>().changeNavigationIndex(index);
        },
        items: [
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.maps,
            icon: const Icon(Icons.map),
          ),
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.favorites,
            icon: const Icon(Icons.favorite),
          ),
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.settings,
            icon: const Icon(Icons.settings),
          ),
        ],
      );
    }
  }
}
