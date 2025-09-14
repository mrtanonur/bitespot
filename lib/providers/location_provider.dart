import 'package:bitespot/models/restaurant_model.dart';
import 'package:bitespot/services/google_maps_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum LocationStatus {
  initial,
  loading,
  locationPermissionAllowed,
  locationLoaded,
  restaurantsLoaded,
  resturantDetail,
  failure,
}

class LocationProvider extends ChangeNotifier {
  final GoogleMapsService _googleMapsService = GoogleMapsService();
  List<RestaurantModel> restaurants = [];
  Position? position;
  LocationStatus status = LocationStatus.initial;
  List<LatLng> points = [];
  String? selectedResturant;

  void setSelectedResturant(String id) {
    selectedResturant = id;
  }

  Future requestPermissionAccess() async {
    status = LocationStatus.loading;
    final permission = await Geolocator.checkPermission();
    if (permission != LocationPermission.always ||
        permission != LocationPermission.whileInUse) {
      await Geolocator.requestPermission();
    }
    status = LocationStatus.locationPermissionAllowed;
    notifyListeners();
  }

  Future getUserLocation() async {
    status = LocationStatus.loading;
    position = await Geolocator.getCurrentPosition();
    status = LocationStatus.locationLoaded;
    notifyListeners();
  }

  Future getNearbyResturants() async {
    final response = await _googleMapsService.getNearbyResturants(
      position!.latitude,
      position!.longitude,
    );
    response.fold((Object errorMessage) {}, (List<RestaurantModel> list) {
      restaurants = list;
      status = LocationStatus.restaurantsLoaded;
    });
    notifyListeners();
  }
}
