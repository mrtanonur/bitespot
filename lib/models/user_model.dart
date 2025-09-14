class UserModel {
  final String id;
  final String? fullName;
  final String email;
  final String? signInMethod;

  UserModel({
    required this.id,
    this.fullName,
    required this.email,
    this.signInMethod,
  });

  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? signInMethod,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      signInMethod: signInMethod ?? this.signInMethod,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      fullName: json["full_name"],
      email: json["email"],
      signInMethod: json["sign_in_method"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "full_name": fullName,
      "email": email,
      "sign_in_method": signInMethod,
    };
  }
}
