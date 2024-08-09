import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_photo_editor/screens/home.dart';
import 'package:flutter_photo_editor/screens/home_screen2.dart';
import 'package:flutter_photo_editor/screens/homes.dart';

// import 'package:flutter_photo_editor/screens/home_screen2.dart';
import 'package:get/route_manager.dart';
import 'package:image_editor_plus/image_editor_plus.dart';

class AppRoutes {
  static const String main = "/";
  static const String edit = "/edit";

  static final routes = [
    GetPage(name: AppRoutes.main, page: () => HomeScreens()),
    GetPage(
        name: AppRoutes.edit,
        page: () {
          final imagePath = Get.parameters['image'];
          final imageFile = File(imagePath!);
          return ImageEditor(
            image: imageFile.readAsBytesSync(),
            savePath: imageFile.path,
          );
        }),
    // GetPage(
    //     name: AppRoutes.edit,
    //     page: () {
    //       final imagePath = Get.parameters['image'];
    //       if (imagePath != null) {
    //         final imageFile = File(imagePath);
    //         return ImageEditor(
    //           image: imageFile.readAsBytesSync(),
    //           savePath: imageFile.path,
    //         );
    //       } else {
    //         return const Scaffold(
    //           body: Center(
    //             child: Text('No image selected'),
    //           ),
    //         );
    //       }
    //     }),
  ];
}
