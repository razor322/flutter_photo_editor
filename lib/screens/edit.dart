// lib/views/image_editor_view.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:get/get.dart';

class Edit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Uint8List imageData = Get.arguments;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Image'),
      ),
      body: ImageEditor(
        image: imageData,
      ),
    );
  }
}
