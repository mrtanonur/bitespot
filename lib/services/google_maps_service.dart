import 'package:bitespot/models/restaurant_model.dart';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsService {
  final Dio dio = Dio();
  String baseUrl = "https://places.googleapis.com/v1/places:searchNearby";

  Future<Either<Object, List<RestaurantModel>>> getNearbyResturants(
    double latitude,
    double longitude,
  ) async {
    try {
      final googleMapsKey = dotenv.env["GOOGLE_MAPS"];
      final response = await dio.post(
        baseUrl,
        options: Options(
          contentType: 'application/json',
          headers: {
            "X-Goog-Api-Key": googleMapsKey,
            "X-Goog-FieldMask":
                "places.id,places.displayName,places.formattedAddress,places.location,places.currentOpeningHours,places.internationalPhoneNumber,places.rating",
          },
        ),
        data: {
          "includedTypes": ["restaurant"],
          "maxResultCount": 10,
          "locationRestriction": {
            "circle": {
              "center": {"latitude": latitude, "longitude": longitude},
              "radius": 500.0,
            },
          },
        },
      );

      List data = response.data!["places"];
      List<RestaurantModel> restaurantList = data
          .map((restaurant) => RestaurantModel.fromJson(restaurant))
          .toList();
      return (Right(restaurantList));
    } catch (exception) {
      return Left(exception);
    }
  }

  Future<List<LatLng>> getRouteCoordinates(
    LatLng origin,
    LatLng destination,
  ) async {
    final googleMapsKey = dotenv.env["GOOGLE_MAPS"];
    final response = await dio.get(
      'https://maps.googleapis.com/maps/api/directions/json',
      queryParameters: {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
        'mode': 'walking',
        'key': googleMapsKey,
      },
    );

    if (response.statusCode == 200 && response.data['routes'].isNotEmpty) {
      final encodedPolyline =
          response.data['routes'][0]['overview_polyline']['points'];
      final points = PolylinePoints.decodePolyline(encodedPolyline);
      return points.map((p) => LatLng(p.latitude, p.longitude)).toList();
    }

    throw Exception("Failed to fetch route");
  }
}
