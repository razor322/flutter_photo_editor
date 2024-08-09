import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_photo_editor/components/detail_popup.dart';
import 'package:flutter_photo_editor/controllers/ImageController.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreens extends StatefulWidget {
  HomeScreens({super.key});

  @override
  State<HomeScreens> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  final ImageController imageViewModel = Get.put(ImageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
          title: const Text(
            'Image Picker Example',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => imageViewModel.getImages(),
          child: const Icon(Icons.camera_enhance),
        ),
        body: SafeArea(child: _BuildBody()));
  }

  Widget _BuildBody() {
    return _BuildContent();
  }

  Widget _BuildContent() {
    return Column(
      children: [
        // ElevatedButton(
        //   onPressed: () => imageViewModel.getImages(),
        //   child: const Text('Pick Image'),
        // ),
        Expanded(
          child: Obx(() {
            if (imageViewModel.images.isEmpty) {
              return const Center(child: Text('No images'));
            } else {
              return ListView.builder(
                itemCount: imageViewModel.images.length,
                itemBuilder: (context, index) {
                  final image = imageViewModel.images[index];
                  return ListTile(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => DetailPopup(image));
                    },
                    leading:
                        Image.file(File(image.path), width: 50, height: 50),
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
                },
              );
            }
          }),
        ),
      ],
    );
  }
}
