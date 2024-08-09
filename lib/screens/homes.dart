// lib/views/home_view.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_photo_editor/controllers/imageController2.dart';
import 'package:get/get.dart';

void main() {
  runApp(
    MaterialApp(
      home: HomeView(),
    ),
  );
}

class HomeView extends StatelessWidget {
  final ImageController2 controller = Get.put(ImageController2());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Editor MVVM'),
      ),
      body: Obx(() {
        return ListView.builder(
          itemCount: controller.images.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Image.file(File(controller.images[index].path)),
              title: Text('Image ${controller.images[index].id}'),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () =>
                    controller.deleteImage(controller.images[index].id!),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.pickAndEditImage(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
