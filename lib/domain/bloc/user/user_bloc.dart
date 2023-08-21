import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/user.dart';
import '../../../data/repositories/user/user_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository;
  UserBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(UserState.initial()) {
    on<SignInUser>(_onSignInUser);
    on<SignOutUser>(_onSignOutUser);
    on<GoogleSignInUser>(_onGoogleSignInUser);
  }

  FutureOr<void> _onSignInUser(
      SignInUser event, Emitter<UserState> emit) async {
    try {
      final response =
          await _userRepository.signInUser(event.email, event.password);
      response.fold(
          (errorMessage) => emit(UserErrorState(
              errorMessage: errorMessage, currentUser: state.currentUser)),
          (user) => emit(UserSignedIn(user)));
    } catch (e) {
      emit(UserErrorState(
          errorMessage: 'Error fetching users: $e',
          currentUser: state.currentUser));
    }
  }

  FutureOr<void> _onSignOutUser(
      SignOutUser event, Emitter<UserState> emit) async {
    try {
      final response = await _userRepository.signOutUser();
      response.fold(
          (errorMessage) => emit(UserErrorState(
              errorMessage: errorMessage, currentUser: state.currentUser)),
          (user) => emit(UserSignedOut(currentUser: User.empty())));
    } catch (e) {
      emit(UserErrorState(
          errorMessage: 'Error fetching users: $e',
          currentUser: state.currentUser));
    }
  }

  FutureOr<void> _onGoogleSignInUser(
      GoogleSignInUser event, Emitter<UserState> emit) async {
    try {
      final response = await _userRepository.googleSignInUser();
      response.fold(
          (errorMessage) => emit(UserErrorState(
              errorMessage: errorMessage, currentUser: state.currentUser)),
          (user) => emit(UserSignedIn(user)));
    } catch (e) {
      emit(UserErrorState(
          errorMessage: 'Error fetching users: $e',
          currentUser: state.currentUser));
    }
  }
}
