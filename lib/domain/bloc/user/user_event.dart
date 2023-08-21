part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class SignInUser extends UserEvent {
  final String email;
  final String password;

  const SignInUser({required this.email, required this.password});
  @override
  List<Object> get props => [email, password];
}

class GoogleSignInUser extends UserEvent {}

class SignOutUser extends UserEvent {
  @override
  List<Object> get props => [];
}
