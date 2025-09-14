import 'package:bitespot/models/restaurant_model.dart';
import 'package:bitespot/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseFirestoreService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final String _userCollection = "user";
  final String _favoriteCollection = "favorite";

  // store user data to firebase database
  Future<Either<String, void>> storeUserData(UserModel userModel) async {
    try {
      await _firebaseFirestore
          .collection(_userCollection)
          .doc(userModel.id)
          .set(userModel.toJson());
      return const Right(null);
    } on FirebaseException catch (exception) {
      return Left(exception.message!);
    }
  }

  // get user data from firebase database
  Future<Either<String, UserModel>> getUserData() async {
    try {
      String id = _firebaseAuth.currentUser!.uid;
      final response = await _firebaseFirestore
          .collection(_userCollection)
          .doc(id)
          .get();
      final UserModel userModel = UserModel.fromJson(response.data()!);
      return Right(userModel);
    } on FirebaseException catch (exception) {
      return Left(exception.message!);
    }
  }

  Future<Either<String, void>> addFavorite(
    RestaurantModel restaurantModel,
  ) async {
    try {
      String id = _firebaseAuth.currentUser!.uid;
      await _firebaseFirestore
          .collection(_userCollection)
          .doc(id)
          .collection(_favoriteCollection)
          .doc(restaurantModel.id)
          .set(restaurantModel.toJson());
      return const Right(null);
    } on FirebaseException catch (exception) {
      return Left(exception.message!);
    }
  }

  Future<Either<String, void>> removeFavorite(String restaurantId) async {
    try {
      String id = _firebaseAuth.currentUser!.uid;
      await _firebaseFirestore
          .collection(_userCollection)
          .doc(id)
          .collection(_favoriteCollection)
          .doc(restaurantId)
          .delete();
      return const Right(null);
    } on FirebaseException catch (exception) {
      return Left(exception.message!);
    }
  }

  Future<Either<String, List<RestaurantModel>>> getFavorites() async {
    try {
      String id = _firebaseAuth.currentUser!.uid;
      final snapshot = await _firebaseFirestore
          .collection(_userCollection)
          .doc(id)
          .collection(_favoriteCollection)
          .get();

      List<RestaurantModel> list = snapshot.docs
          .map((doc) => RestaurantModel.fromFirestore(doc.data()))
          .toList();
      return Right(list);
    } on FirebaseException catch (exception) {
      return Left(exception.message!);
    }
  }
}
