import 'package:firedart/auth/exceptions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../domain/bloc/user/user_bloc.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      loginProviders: [
        LoginProvider(
          icon: FontAwesomeIcons.google,
          label: 'Google',
          callback: () async {
            debugPrint('start google sign in');
            final userBloc = BlocProvider.of<UserBloc>(context);
            try {
              // Dispatch the SignInUser event to the authentication Bloc
              userBloc.add(GoogleSignInUser());

              await for (final state in userBloc.stream) {
                if (state is UserErrorState) {
                  return state.errorMessage;
                } else if (state is UserSignedIn) {
                  return null;
                }
              }
            } on AuthException catch (e) {
              debugPrint('errors: $e');
              return e.message;
            }

            return null;
          },
        ),
      ],
      onLogin: (LoginData data) async {
        final userBloc = BlocProvider.of<UserBloc>(context);
        try {
          // Dispatch the SignInUser event to the authentication Bloc
          userBloc.add(SignInUser(email: data.name, password: data.password));

          await for (final state in userBloc.stream) {
            if (state is UserErrorState) {
              return state.errorMessage;
            } else if (state is UserSignedIn) {
              return null;
            }
          }
        } on AuthException catch (e) {
          debugPrint('errors: $e');
          return e.message;
        }

        return null;
      },
      onRecoverPassword: (p0) {
        return null;
      },
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacementNamed('/home');
      },
    );
  }
}
