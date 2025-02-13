import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '/profile/profile.dart';
import '/profile/profile_about.dart';
import '/profile/profile_edit.dart';
import '/profile/profile_login.dart';
import '/profile/profile_register.dart';
import '/route_builder.dart';

class ProfileNavigator extends StatelessWidget {
  ProfileNavigator({super.key});

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  bool isLoggedIn() {
    final box = Hive.box('loginBox');
    return box.get('isLoggedIn', defaultValue: false);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: '/',
      onGenerateInitialRoutes: (NavigatorState navigator, String initialRoute) {
        if (isLoggedIn()) {
          return [SlideRightRoute(page: const ProfileView())];
        } else {
          return [SlideRightRoute(page: const ProfileLoginView())];
        }
      },
      onGenerateRoute: (RouteSettings settings) {
        Widget page;
        switch (settings.name) {
          case '/profile':
            page = const ProfileView();
            break;
          case '/':
            page = const ProfileLoginView();
            break;
          case '/register':
            page = const ProfileRegisterView();
            break;
          case '/about':
            page = const ProfileAboutView();
            break;
          case '/edit-profile':
            page = const ProfileEditView();
            return SlideRightRoute<bool>(page: page);
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return SlideRightRoute(page: page);
      },
    );
  }
}
