import 'package:bitespot/l10n/app_localizations.dart';
import 'package:bitespot/providers/favorite_provider.dart';
import 'package:bitespot/utils/constants/constants.dart';
import 'package:bitespot/widgets/bitespot_restaurant_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  FavoriteProvider? _favoriteProvider;

  @override
  void initState() {
    super.initState();
    _favoriteProvider = context.read<FavoriteProvider>();
    _favoriteProvider!.getFavorites();
    _favoriteProvider!.addListener(favoriteListener);
  }

  @override
  void dispose() {
    _favoriteProvider!.removeListener(favoriteListener);
    super.dispose();
  }

  void favoriteListener() {
    FavoriteStatus status = _favoriteProvider!.status;
    if (status == FavoriteStatus.failure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_favoriteProvider!.error!),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceBright,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.favorites),
        backgroundColor: Theme.of(context).colorScheme.surfaceBright,
      ),
      body: Consumer<FavoriteProvider>(
        builder: (context, provider, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: SizeConstants.s24),
            child: ListView.separated(
              itemCount: provider.favoriteRestaurants.length,
              separatorBuilder: (context, index) {
                return const SizedBox(height: SizeConstants.s4);
              },
              itemBuilder: (context, index) {
                return BitespotRestaurantTile(
                  restaurant: provider.favoriteRestaurants[index]!,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
