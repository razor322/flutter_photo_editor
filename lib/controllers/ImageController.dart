import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_photo_editor/components/custom_snackbar.dart';
import 'package:flutter_photo_editor/config/app_const.dart';
import 'package:flutter_photo_editor/services/models/image.dart';
import 'package:flutter_photo_editor/utils/db_helper.dart';
import 'package:get/get.dart';
// import 'package:image_downloader/image_downloader.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';

import 'package:path_provider/path_provider.dart';

class ImageController extends GetxController {
  var images = <ImageModel>[].obs;
  final imageFile = XFile('').obs;
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final picker = ImagePicker();
  Uint8List? imageData;

  @override
  void onInit() {
    super.onInit();
    loadImages();
  }

  void updateImage(Uint8List newImageData) {
    imageData = newImageData;
    update();
  }

  pickAndEditImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // Load image data
      final imageBytes = await image.readAsBytes();

      // Open the image editor
      var editedImage = await Get.to(() => ImageEditor(
            image: imageBytes,
          ));

      if (editedImage != null) {
        updateImage(editedImage);
      }

      Get.snackbar("Edit Image", "Berhasil mengedit gambar");
      saveImage(File(editedImage.path));
    }
  }

  pickImage() async {
    imageFile.value = (await picker.pickImage(
        source: ImageSource.gallery, imageQuality: 100))!;
    imageFile.refresh();
  }

  getImages() async {
    final XFile? imagePicked =
        await picker.pickImage(source: ImageSource.gallery);
    await editImage(imagePicked!);
  }

  editsImage(XFile imageData) async {
    final imageBytes = await imageData.readAsBytes();

    var editedImage = await Get.to(() => ImageEditor(
          image: imageBytes,
        ));

    await saveImage(File(editedImage.path));
  }

  editImage(XFile imageData) async {
    final imageBytes = await imageData.readAsBytes();

    var editedImage = await Get.to(() => ImageEditor(
          image: imageBytes,
        ));
    if (editedImage != null) {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'img_${DateTime.now().microsecond}.png';
      final imagePath = '${directory.path}/$fileName';

      // Simpan array byte sebagai file
      final File imageFile = File(imagePath);
      await imageFile.writeAsBytes(editedImage);

      // Simpan file gambar ke database
      // Get.snackbar(
      //   AppConst.MESSAGE_TITLE,
      //   AppConst.MESSAGE_SUCCESS,
      //   backgroundColor: Colors.purpleAccent,
      //   duration: const Duration(seconds: 5),
      //   icon: const Icon(Icons.image, color: Colors.white),
      // );
      CustomSnackbar.show(
        title: AppConst.MESSAGE_TITLE_SUCCESS,
        message: AppConst.MESSAGE_SUCCESS_EDIT,
        icon: const Icon(
          Icons.image,
          color: Colors.white,
        ),
      );
      await saveImage(imageFile);
    }
  }

  saveImage(File imageFile) async {
    final image = ImageModel(path: imageFile.path);
    await _dbHelper.insertImage(image);
    loadImages();
  }

  loadImages() async {
    final imgList = await _dbHelper.getImages();
    images.assignAll(imgList);
    update();
  }

  deleteImage(int id) async {
    Get.defaultDialog(
      title: "Delete Image ?",
      cancelTextColor: Colors.red,
      confirmTextColor: Colors.white,
      middleText: " ",
      contentPadding: const EdgeInsets.all(10),
      onCancel: () {
        Get.back();
      },
      onConfirm: () async {
        Get.back();
        await _dbHelper.deleteImage(id);

        CustomSnackbar.show(
          title: AppConst.MESSAGE_TITLE_SUCCESS,
          message: AppConst.MESSAGE_SUCCESS_DELETE,
          icon: const Icon(
            Icons.image,
            color: Colors.white,
          ),
        );
        loadImages();
      },
    );
  }
}
