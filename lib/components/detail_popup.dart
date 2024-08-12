import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_photo_editor/controllers/ImageController.dart';
import 'package:flutter_photo_editor/services/models/image.dart';
import 'package:get/get.dart';

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
        children: <Widget>[
          Center(
            child: Container(
              height: 180,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
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
          const SizedBox(height: 10),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
