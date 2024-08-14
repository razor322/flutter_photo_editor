import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_photo_editor/components/detail_popup.dart';
import 'package:flutter_photo_editor/config/app_const.dart';
import 'package:flutter_photo_editor/controllers/ImageController.dart';
import 'package:flutter_photo_editor/routes/route.dart';
import 'package:flutter_photo_editor/services/models/image.dart';
import 'package:get/get.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:path/path.dart';

class HomeScreens extends StatelessWidget {
  HomeScreens({super.key});

  // final ImageController imageViewModel = Get.find<ImageController>();
  final ImageController imageViewModel = Get.put(ImageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
          title: const Text(
            AppConst.TITLE_MAIN_PAGE,
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FloatingActionButton(
              heroTag: "btn1",
              onPressed: () => imageViewModel.getImages(),
              child: const Icon(Icons.camera_enhance),
            ),
            FloatingActionButton(
              heroTag: "btn2",
              onPressed: () => Get.toNamed(AppRoutes.combine),
              child: const Icon(Icons.plus_one),
            ),
          ],
        ),
        body: SafeArea(child: _BuildBody()));
  }

  Widget _BuildBody() {
    return _BuildContent();
  }

  Widget _BuildContent() {
    return Column(
      children: [
        Expanded(
          child: Obx(() {
            if (imageViewModel.images.isEmpty) {
              return const Center(child: Text('No images'));
            } else {
              return ListView.builder(
                itemCount: imageViewModel.images.length,
                itemBuilder: (context, index) {
                  final image = imageViewModel.images[index];

                  return _BuildData(image, context);
                },
              );
            }
          }),
        ),
      ],
    );
  }

  Widget _BuildData(ImageModel image, BuildContext c) {
    return ListTile(
      onTap: () {
        showDialog(context: c, builder: (context) => DetailPopup(image));
      },
      leading: InstaImageViewer(
          child: Image.file(File(image.path), width: 50, height: 50)),
      title: Text(image.path.split('/').last),
      trailing: IconButton(
        icon: const Icon(
          Icons.delete,
        ),
        onPressed: () {
          imageViewModel.deleteImage(image.id!);
        },
      ),
    );
  }
}
