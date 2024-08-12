// lib/controllers/image_controller.dart
import 'dart:typed_data';
import 'package:flutter_photo_editor/services/models/image.dart';
import 'package:flutter_photo_editor/utils/db.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImageController2 extends GetxController {
  var images = <ImageModel>[].obs;
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    loadImages();
    super.onInit();
  }

  void loadImages() async {
    images.value = await DBService.db.getImages();
    update();
  }

  Future<void> pickAndEditImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      Uint8List? editedImage =
          await Get.toNamed('/editor', arguments: pickedFile);
      if (editedImage != null) {
        String path = pickedFile.path;
        await DBService.db.insertImage(ImageModel(path: path));
        loadImages();
      }
    }
  }

  void deleteImage(int id) async {
    await DBService.db.deleteImage(id);
    loadImages();
  }
}
