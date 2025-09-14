import 'package:bitespot/models/restaurant_model.dart';
import 'package:bitespot/providers/favorite_provider.dart';
import 'package:bitespot/utils/constants/size_constants.dart';
import 'package:bitespot/widgets/bitespot_is_open.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BitespotRestaurantTile extends StatelessWidget {
  final RestaurantModel restaurant;
  const BitespotRestaurantTile({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                restaurant.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConstants.s18,
                ),
              ),
            ),

            IconButton(
              onPressed: () {
                context.read<FavoriteProvider>().favorite(restaurant);
              },
              icon: context.watch<FavoriteProvider>().isFavorite(restaurant)
                  ? const Icon(Icons.bookmark)
                  : const Icon(Icons.bookmark_outline),
            ),
          ],
        ),
        Text(
          restaurant.address,
          style: const TextStyle(fontSize: SizeConstants.s14),
        ),
        const SizedBox(height: SizeConstants.s4),
        Text(
          restaurant.phoneNumber,
          style: const TextStyle(fontSize: SizeConstants.s14),
        ),
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
      ],
    );
  }
}
