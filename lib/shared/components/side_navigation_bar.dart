import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/bloc/side_navigation/side_navigation_bloc.dart';
import '../../domain/bloc/user/user_bloc.dart';

class SideNavigationBar extends StatelessWidget {
  final SideNavigationBloc navigationBloc;

  const SideNavigationBar({Key? key, required this.navigationBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SideNavigationBloc, SideNavigationState>(
      bloc: navigationBloc,
      builder: (context, state) {
        return Drawer(
          backgroundColor: Theme.of(context).drawerTheme.backgroundColor,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              if (MediaQuery.of(context).size.width < 600)
                DrawerHeader(
                  decoration:
                      BoxDecoration(color: Theme.of(context).primaryColor),
                  child: const Text('Workers scheduler'),
                ),
              ListTile(
                title: const Text('Available times'),
                onTap: () {
                  BlocProvider.of<SideNavigationBloc>(context).add(
                      const SelectNavigationItem(
                          navigationItem: NavigationItem.availablity));
                  if (MediaQuery.of(context).size.width < 600) {
                    Navigator.pop(context);
                  }
                },
                selected: state is NavigationItemSelected &&
                    state.currentItemDestination == NavigationItem.availablity,
              ),
              ListTile(
                title: const Text('Completed shifts'),
                onTap: () {
                  BlocProvider.of<SideNavigationBloc>(context).add(
                      const SelectNavigationItem(
                          navigationItem: NavigationItem.compeletedShifts));
                  if (MediaQuery.of(context).size.width < 600) {
                    Navigator.pop(context);
                  }
                },
                selected: state is NavigationItemSelected &&
                    state.currentItemDestination ==
                        NavigationItem.compeletedShifts,
              ),
              ListTile(
                title: const Text('My upcoming shifts'),
                onTap: () {
                  BlocProvider.of<SideNavigationBloc>(context).add(
                      const SelectNavigationItem(
                          navigationItem: NavigationItem.upcomingShifts));
                  if (MediaQuery.of(context).size.width < 600) {
                    Navigator.pop(context);
                  }
                },
                selected: state is NavigationItemSelected &&
                    state.currentItemDestination ==
                        NavigationItem.upcomingShifts,
              ),
              const Divider(),
              ListTile(
                title: const Text('Sign Out'),
                onTap: () async {
                  final userBloc = context.read<UserBloc>();
                  try {
                    // Dispatch the SignInUser event to the authentication Bloc
                    userBloc.add(SignOutUser());
                    await for (final state in userBloc.stream) {
                      if (state is UserErrorState) {
                        debugPrint(state.errorMessage);
                      } else if (state is UserSignedOut) {
                        Navigator.pushReplacementNamed(context, '/');
                      }
                    }
                  } catch (e) {
                    debugPrint('errors: $e');
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
