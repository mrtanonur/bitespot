import 'package:bitespot/pages/favorites_page.dart';
import 'package:bitespot/pages/maps_page.dart';
import 'package:bitespot/pages/settings_page.dart';
import 'package:bitespot/providers/main_provider.dart';
import 'package:bitespot/widgets/bitespot_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: context.watch<MainProvider>().navigationIndex,
        children: [
          const MapsPage(),
          const FavoritesPage(),
          const SettingsPage(),
        ],
      ),
      bottomNavigationBar: const BitespotBottomNavigationBar(),
    );
  }
}
