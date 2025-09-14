import 'package:hive/hive.dart';

part 'restaurant_model.g.dart';

@HiveType(typeId: 0)
class RestaurantModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String address;
  @HiveField(3)
  final double latitude;
  @HiveField(4)
  final double longitude;
  @HiveField(5)
  final List<dynamic> openingHours;
  @HiveField(6)
  final bool openNow;
  @HiveField(7)
  final String phoneNumber;
  @HiveField(8)
  final dynamic rating;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.openingHours,
    required this.openNow,
    required this.phoneNumber,
    required this.rating,
  });

  RestaurantModel copyWith({
    String? id,
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    List<dynamic>? openingHours,
    bool? openNow,
    String? phoneNumber,
    dynamic rating,
  }) {
    return RestaurantModel(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      openingHours: openingHours ?? this.openingHours,
      openNow: openNow ?? this.openNow,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      rating: rating ?? this.rating,
    );
  }

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json["id"],
      name: json["displayName"]["text"],
      address: json["formattedAddress"],
      latitude: json["location"]["latitude"],
      longitude: json["location"]["longitude"],
      openingHours: json["currentOpeningHours"]["weekdayDescriptions"],
      openNow: json["currentOpeningHours"]["openNow"],
      phoneNumber: json["internationalPhoneNumber"],
      rating: json["rating"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "address": address,
      "latitude": latitude,
      "longitude": longitude,
      "openingHours": openingHours,
      "openNow": openNow,
      "phoneNumber": phoneNumber,
      "rating": rating,
    };
  }

  factory RestaurantModel.fromFirestore(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      openingHours: List<String>.from(json['openingHours'] ?? []),
      openNow: json['openNow'] ?? false,
      phoneNumber: json['phoneNumber'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
    );
  }
}
