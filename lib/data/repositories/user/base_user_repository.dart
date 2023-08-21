import 'package:dartz/dartz.dart';
import 'package:workers_scheduler/data/models/user.dart';

typedef EitherUser<T> = Future<Either<String, T>>;

abstract class BaseUserRepository {
  EitherUser<User> signInUser(String email, String password);
  EitherUser<User> googleSignInUser();
  EitherUser<String> signOutUser();
}
