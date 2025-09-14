import 'package:bitespot/models/restaurant_model.dart';
import 'package:hive/hive.dart';

class FavoriteLocalDataSource {
  static Box<RestaurantModel>? box;
  static Future openBox() async {
    box = await Hive.openBox("restaurant");
  }

  static read(RestaurantModel restaurant) {
    box!.get(restaurant.id);
  }

  static List<RestaurantModel?> readAll() {
    return box!.values.toList();
  }

  static Future add(RestaurantModel restaurant) async {
    await box!.put(restaurant.id, restaurant);
  }

  static Future delete(String id) async {
    await box!.delete(id);
  }

  static Future clear() async {
    await box!.clear();
  }
}
