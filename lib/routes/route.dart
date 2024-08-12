import 'package:flutter_photo_editor/screens/home_screen2.dart';
import 'package:get/route_manager.dart';

class AppRoutes {
  static const String main = "/";
  static final routes = [
    GetPage(name: AppRoutes.main, page: () => HomeScreens()),
  ];
}
