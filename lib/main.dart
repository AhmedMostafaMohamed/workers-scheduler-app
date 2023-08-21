import 'dart:io';

import 'package:firedart/firedart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:workers_scheduler/data/models/shift_page_arguments.dart';
import 'package:workers_scheduler/data/repositories/shift/shift_repository.dart';
import 'package:workers_scheduler/data/repositories/user/user_repository.dart';
import 'package:workers_scheduler/domain/bloc/shift/shift_bloc.dart';
import 'package:workers_scheduler/domain/bloc/side_navigation/side_navigation_bloc.dart';
import 'package:workers_scheduler/domain/bloc/user/user_bloc.dart';
import 'package:workers_scheduler/modules/shift_editing_page/shift_editing_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'modules/authentication/authentication_page.dart';
import 'modules/home/home_page.dart';
import 'package:google_sign_in_dartio/google_sign_in_dartio.dart';

void main() {
  if (Platform.isWindows) {
    GoogleSignInDart.register(
        clientId:
            '11927002349-3067ljel5n1hg5g0pdl749dj05hfsp3r.apps.googleusercontent.com');
  }

  FirebaseAuth.initialize(
      'AIzaSyBfJrhWk5N0KixA7r0RBfsA4J6c1jVfWqU', VolatileStore());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ButtonStyle(
      padding: MaterialStateProperty.all(const EdgeInsets.all(12)),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
      ),
    );
    return MultiBlocProvider(
      providers: [
        BlocProvider<ShiftBloc>(
          create: (context) => ShiftBloc(shiftRepository: ShiftRepository()),
        ),
        BlocProvider<SideNavigationBloc>(
          create: (context) => SideNavigationBloc(),
        ),
        BlocProvider<UserBloc>(
          create: (context) => UserBloc(userRepository: UserRepository()),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(
                  builder: (context) => const AuthenticationPage());
            case '/home':
              return MaterialPageRoute(builder: (context) => const HomePage());
            case '/shift-details':
              final args = settings.arguments as ShiftPageArgumets?;
              final dateTime = args!.date;
              final shift = args.shift;

              return MaterialPageRoute(
                  builder: (context) => ShiftEditingPage(
                        date: dateTime ?? DateTime.now(),
                        shift: shift,
                      ));
          }
          return null;
        },
        theme: ThemeData(
          brightness: Brightness.light,
          visualDensity: VisualDensity.standard,
          useMaterial3: true,
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(style: buttonStyle),
          textButtonTheme: TextButtonThemeData(style: buttonStyle),
          outlinedButtonTheme: OutlinedButtonThemeData(style: buttonStyle),
          textTheme: const TextTheme(
            titleLarge: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
