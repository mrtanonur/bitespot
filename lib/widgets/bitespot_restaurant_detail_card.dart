import 'package:bitespot/l10n/app_localizations.dart';
import 'package:bitespot/models/restaurant_model.dart';
import 'package:bitespot/providers/favorite_provider.dart';
import 'package:bitespot/providers/location_provider.dart';
import 'package:bitespot/utils/constants/size_constants.dart';
import 'package:bitespot/widgets/bitespot_is_open.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BitespotRestaurantDetailCard extends StatelessWidget {
  const BitespotRestaurantDetailCard({super.key});

  @override
  Widget build(BuildContext context) {
    LocationProvider provider = context.read<LocationProvider>();
    String? selectedResturantId = provider.selectedResturant;
    RestaurantModel restaurant = provider.restaurants.firstWhere(
      (resturant) => resturant.id == selectedResturantId,
    );
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 1,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(SizeConstants.s20),
              topRight: Radius.circular(SizeConstants.s20),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: SizeConstants.s12,
            vertical: SizeConstants.s12,
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            controller: scrollController,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            'restaurantListPage',
                          );
                        },
                        icon: const Icon(
                          Icons.chevron_left,
                          size: SizeConstants.s30,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          restaurant.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: SizeConstants.s18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      IconButton(
                        onPressed: () {
                          context.read<FavoriteProvider>().favorite(restaurant);
                        },
                        icon:
                            context.watch<FavoriteProvider>().isFavorite(
                              restaurant,
                            )
                            ? const Icon(Icons.bookmark)
                            : const Icon(Icons.bookmark_outline),
                      ),
                    ],
                  ),
                  const SizedBox(height: SizeConstants.s4),

                  Text(restaurant.address),
                  const SizedBox(height: SizeConstants.s4),

                  Text(restaurant.phoneNumber),
                  const SizedBox(height: SizeConstants.s4),

                  Row(
                    children: [
                      IsOpen(isOpen: restaurant.openNow),
                      const Spacer(),
                      Row(
                        children: [
                          Text(restaurant.rating.toString()),
                          const Icon(Icons.star, color: Colors.yellow),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: SizeConstants.s4),
                  Text(
                    AppLocalizations.of(context)!.workingHours,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: SizeConstants.s8),
                  ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    padding: EdgeInsets.zero,
                    itemCount: restaurant.openingHours.length,
                    itemBuilder: (context, index) {
                      return Text(restaurant.openingHours[index]);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
