import 'package:bitespot/local_data_source/favorite_local_data_source.dart';
import 'package:bitespot/models/restaurant_model.dart';
import 'package:bitespot/services/firebase_firestore_service.dart';
import 'package:flutter/widgets.dart';

enum FavoriteStatus { initial, favoritesLoaded, failure }

class FavoriteProvider extends ChangeNotifier {
  final FirebaseFirestoreService _firestoreService = FirebaseFirestoreService();
  List<RestaurantModel?> favoriteRestaurants = [];
  String? error;
  FavoriteStatus status = FavoriteStatus.initial;

  Future getFavorites() async {
    final response = await _firestoreService.getFavorites();
    response.fold(
      (String errorMessage) {
        favoriteRestaurants = FavoriteLocalDataSource.readAll();
        error = errorMessage;
        status = FavoriteStatus.failure;
      },
      (List<RestaurantModel> favorites) {
        favoriteRestaurants = favorites;
        status = FavoriteStatus.favoritesLoaded;
      },
    );
    notifyListeners();
  }

  Future favorite(RestaurantModel restaurantModel) async {
    if (favoriteRestaurants.any(
      (restaurant) => restaurant?.id == restaurantModel.id,
    )) {
      favoriteRestaurants.removeWhere((item) => item?.id == restaurantModel.id);

      await FavoriteLocalDataSource.delete(restaurantModel.id);

      await _firestoreService.removeFavorite(restaurantModel.id);
    } else {
      favoriteRestaurants.add(restaurantModel);
      await FavoriteLocalDataSource.add(restaurantModel);
      await _firestoreService.addFavorite(restaurantModel);
    }
    notifyListeners();
  }

  bool isFavorite(RestaurantModel restaurantModel) {
    if (favoriteRestaurants.any(
      (restaurant) => restaurant?.id == restaurantModel.id,
    )) {
      return true;
    } else {
      return false;
    }
  }
}
