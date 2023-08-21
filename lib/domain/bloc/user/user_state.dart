part of 'user_bloc.dart';

class UserState extends Equatable {
  final User currentUser;
  const UserState({required this.currentUser});

  @override
  List<Object> get props => [currentUser];
  factory UserState.initial() {
    return UserState(
      currentUser: User.empty(),
    );
  }
}

class UserSignedIn extends UserState {
  final User user;

  const UserSignedIn(this.user) : super(currentUser: user);

  @override
  List<Object> get props => [user];
}

class UserErrorState extends UserState {
  final String errorMessage;

  const UserErrorState(
      {required this.errorMessage, required super.currentUser});
  @override
  List<Object> get props => [errorMessage];
}

class UserSignedOut extends UserState {
  const UserSignedOut({required super.currentUser});

  @override
  List<Object> get props => [];
}
