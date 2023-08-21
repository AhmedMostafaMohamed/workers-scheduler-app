import 'package:firedart/firedart.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:workers_scheduler/data/models/user.dart';
import 'package:workers_scheduler/data/repositories/user/base_user_repository.dart';
import 'package:dartz/dartz.dart';

class UserRepository extends BaseUserRepository {
  final FirebaseAuth _auth;
  final CollectionReference _firebaseFirestore;
  final CollectionReference _firebaseFireStore2;
  
  UserRepository(
      {FirebaseAuth? auth,
      CollectionReference? firebaseFirestore,
      CollectionReference? firebaseFirestore2})
      : _auth = auth ?? FirebaseAuth.instance,
        _firebaseFirestore = firebaseFirestore ??
            Firestore('workersscheduler').collection('users'),
        _firebaseFireStore2 = firebaseFirestore2 ??
            Firestore('user-management-da458').collection('users');
  @override
  EitherUser<User> signInUser(String email, String password) async {
    try {
      await _auth.signIn(email, password);
      var doc = await _firebaseFirestore.document(_auth.userId).get();
      User currentUser = User.fromSnapshot(doc);
      return right(currentUser);
    } catch (e) {
      return left(
          kDebugMode ? e.toString() : 'error occurred, please try again later');
    }
  }

  @override
  EitherUser<String> signOutUser() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      googleSignIn.signOut();
      _auth.signOut();
      return right('signed out successfully');
    } catch (e) {
      return left(
          kDebugMode ? e.toString() : 'error occurred, please try again later');
    }
  }

// Initialize Firestore instance

  Future<User?> getUserByEmail(String email) async {
    try {
      // Perform the query to get the document(s) with the specified email
      final query = _firebaseFireStore2.where('user.email', isEqualTo: email);
      final querySnapshot = await query.get();

      if (querySnapshot.isNotEmpty) {
        // Get the first document found (assuming email is unique)
        final document = querySnapshot.first;
        return User.fromSnapshot(document);
      }

      // Return null if the email or "user" field is missing
      return null;
    } catch (e) {
      // Handle any errors that may occur during the query or data retrieval
      debugPrint('Error fetching user by email: $e');
      return null;
    }
  }

  Future<bool?> checkSystemAccess(String email, String accessKey) async {
    try {
      // Perform the query to get the document(s) with the specified email
      final query = _firebaseFireStore2.where('user.email', isEqualTo: email);
      final querySnapshot = await query.get();

      if (querySnapshot.isNotEmpty) {
        // Get the first document found (assuming email is unique)
        final document = querySnapshot.first;

        // Access the raw JSON data of the document as a Map
        final data = document.map;

        // Check if the "user" field exists and is a map
        if (data.containsKey('user') && data['user'] is Map) {
          final userMap = data['user'];

          // Check if the "systemAccess" field exists and is a map
          if (userMap.containsKey('systemAccess') &&
              userMap['systemAccess'] is Map) {
            final systemAccessMap = userMap['systemAccess'];

            // Check if the accessKey exists in the "systemAccess" map and return its value
            if (systemAccessMap.containsKey(accessKey) &&
                systemAccessMap[accessKey] is bool) {
              return systemAccessMap[accessKey];
            }
          }
        }
      }

      // Return null if the email, "user", or "systemAccess" fields are missing,
      // or if the accessKey is not found in the "systemAccess" map.
      return null;
    } catch (e) {
      // Handle any errors that may occur during the query or data retrieval
      debugPrint('Error checking system access: $e');
      return null;
    }
  }

  @override
  EitherUser<User> googleSignInUser() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        // Google sign-in successful
        // Retrieve the Google sign-in authentication details
        bool? accessValue =
            await checkSystemAccess(googleUser.email, 'Workers scheduler');
        if (accessValue == true) {
          User? user = await getUserByEmail(googleUser.email);
          if (user != null) {
            return right(user);
          } else {
            return left('User is not found');
          }
        } else if (accessValue == false) {
          return left(
              'the user: ${googleUser.email} does not have access for this system');
        } else {
          return left('User is not found');
        }
      } else {
        // Google sign-in canceled by the user
        return left('user cancelled authentication');
      }
    } catch (e) {
      return left(
          kDebugMode ? e.toString() : 'error occurred, please try again later');
    }
  }
}
