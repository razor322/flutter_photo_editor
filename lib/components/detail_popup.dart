import 'dart:io';
import 'package:cross_file/src/types/interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_photo_editor/controllers/ImageController.dart';
import 'package:flutter_photo_editor/services/models/image.dart';
import 'package:get/get.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';

class DetailPopup extends StatelessWidget {
  final ImageModel data;
  final controller = Get.put(ImageController());

  DetailPopup(this.data);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: SizedBox(
              height: 180,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: InstaImageViewer(
                  child: Image.file(
                    File(data.path),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(child: Icon(Icons.error));
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: TextButton.icon(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white54)),
                onPressed: () {
                  print("diklik");
                  controller.getImages();
                  print("selesai");
                },
                icon: const Icon(Icons.image_rounded),
                label: const Text("Edit Image")),
          )
        ],
      ),
    );
  }
}
