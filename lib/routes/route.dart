import 'package:flutter_photo_editor/screens/home_screen2.dart';
import 'package:flutter_photo_editor/screens/stiker_screen.dart';
import 'package:get/route_manager.dart';

class AppRoutes {
  static const String main = "/";
  static const String combine = "/combine";

  static final routes = [
    GetPage(name: AppRoutes.main, page: () => HomeScreens()),
    GetPage(
      name: AppRoutes.combine,
      page: () => StikerScreen(),
    ),
  ];
}
