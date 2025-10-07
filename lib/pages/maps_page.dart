import 'dart:io';

import 'package:bitespot/l10n/app_localizations.dart';
import 'package:bitespot/providers/favorite_provider.dart';
import 'package:bitespot/providers/location_provider.dart';
import 'package:bitespot/utils/constants/size_constants.dart';
import 'package:bitespot/widgets/bitespot_restaurant_detail_card.dart';
import 'package:bitespot/widgets/bitespot_restaurant_tile.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  final GlobalKey<_RestaurantListPageState> restaurantListKey =
      GlobalKey<_RestaurantListPageState>();
  LocationProvider? _locationProvider;
  FavoriteProvider? _favoriteProvider;

  @override
  void initState() {
    super.initState();
    _locationProvider = context.read<LocationProvider>();
    _locationProvider!.addListener(locationListener);
    checkPermission();
    _favoriteProvider = context.read<FavoriteProvider>();
    _favoriteProvider!.addListener(favoriteListener);
  }

  Future checkPermission() async {
    await context.read<LocationProvider>().requestPermissionAccess();
  }

  void locationListener() {
    LocationStatus status = _locationProvider!.status;
    if (status == LocationStatus.locationPermissionAllowed) {
      _locationProvider!.getUserLocation();
    } else if (status == LocationStatus.failure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.somethingWentWrong),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  void favoriteListener() {
    FavoriteStatus status = _favoriteProvider!.status;
    if (status == FavoriteStatus.failure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.somethingWentWrong),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  void dispose() {
    _locationProvider!.removeListener(locationListener);
    _favoriteProvider!.removeListener(favoriteListener);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(
      builder: (BuildContext context, provider, Widget? child) {
        Set<Marker> markers = {};
        Set<Polyline> polylines = {};

        if (provider.status == LocationStatus.restaurantsLoaded &&
            markers.isEmpty) {
          markers = provider.restaurants
              .map(
                (restaurant) => Marker(
                  markerId: MarkerId(restaurant.name),
                  position: LatLng(restaurant.latitude, restaurant.longitude),
                  onTap: () {
                    provider.setSelectedResturant(restaurant.id);
                    restaurantListKey.currentState?.openDetail();
                  },
                ),
              )
              .toSet();
        }
        switch (provider.status) {
          case LocationStatus.loading:
            return const Center(child: CircularProgressIndicator());
          default:
            return Scaffold(
              floatingActionButton:
                  provider.status != LocationStatus.restaurantsLoaded
                  ? Padding(
                      padding: Platform.isAndroid
                          ? const EdgeInsetsGeometry.only(
                              bottom: SizeConstants.s96,
                            )
                          : const EdgeInsets.only(bottom: SizeConstants.s60),
                      child: FloatingActionButton(
                        child: const Icon(Icons.search),
                        onPressed: () async {
                          await provider.getNearbyResturants();
                        },
                      ),
                    )
                  : null,
              body: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  GoogleMap(
                    markers: markers,
                    myLocationEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        provider.position!.latitude,
                        provider.position!.longitude,
                      ),
                      zoom: SizeConstants.s18,
                    ),
                  ),
                  if (provider.status == LocationStatus.restaurantsLoaded)
                    RestaurantListPage(key: restaurantListKey),
                ],
              ),
            );
        }
      },
    );
  }
}

class RestaurantListPage extends StatefulWidget {
  const RestaurantListPage({super.key});

  @override
  State<RestaurantListPage> createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  final GlobalKey<NavigatorState> _innerNavigatorKey =
      GlobalKey<NavigatorState>();

  void openDetail() {
    _innerNavigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => const BitespotRestaurantDetailCard(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    LocationProvider provider = context.read<LocationProvider>();

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.2,
      maxChildSize: 0.9,
      expand: false,

      builder: (context, scrollController) {
        return Navigator(
          key: _innerNavigatorKey,
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) => Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(SizeConstants.s20),
                    topRight: Radius.circular(SizeConstants.s20),
                  ),
                ),
                padding: const EdgeInsets.all(SizeConstants.s8),
                child: ListView.separated(
                  controller: scrollController,
                  padding: EdgeInsets.zero,
                  itemCount: provider.restaurants.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: SizeConstants.s12);
                  },
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: BitespotRestaurantTile(
                        restaurant: provider.restaurants[index],
                      ),
                      onTap: () {
                        provider.setSelectedResturant(
                          provider.restaurants[index].id,
                        );
                        openDetail();
                      },
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
