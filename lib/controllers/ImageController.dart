// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lindi_sticker_widget/lindi_controller.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter_photo_editor/components/custom_snackbar.dart';
import 'package:flutter_photo_editor/config/app_const.dart';
import 'package:flutter_photo_editor/services/models/image.dart';
import 'package:flutter_photo_editor/utils/db_helper.dart';

class ImageController extends GetxController {
  var images = <ImageModel>[].obs;
  final imageFile = XFile('').obs;
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final picker = ImagePicker();
  Uint8List? imageData;
  var selectedImagePath = ''.obs;
  final LindiController controller = LindiController(
    borderColor: Colors.white,
    iconColor: Colors.black,
  );
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

  getStiker() async {
    final XFile? imagePicked =
        await picker.pickImage(source: ImageSource.gallery);
    return imagePicked;
  }

  onAddStikerPressed() async {
    XFile? imagePicked = await getStiker();
    if (imagePicked != null) {
      print(imagePicked.path);
      controller.addWidget(
        Container(
          padding: const EdgeInsets.all(5),
          child: Image.file(
            File(imagePicked.path),
            width: 50,
            height: 50,
          ),
        ),
      );
      update();
    }
  }

  editsImage(XFile imageData) async {
    final imageBytes = await imageData.readAsBytes();

    var editedImage = await Get.to(() => ImageEditor(
          image: imageBytes,
        ));

    await saveImage(File(editedImage.path));
  }

  editImage(dynamic imageData) async {
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

  Future<File> saveUint8ListAsFile(Uint8List uint8List, String fileName) async {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$fileName');
    return await file.writeAsBytes(uint8List);
  }

  pickStikerImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImagePath.value = pickedFile.path;
    } else {
      print('No image selected.');
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

  addStikers() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      controller?.addWidget(
        Container(
          padding: const EdgeInsets.all(5),
          child: Image.file(
            File(image.path),
            width: 50,
            height: 50,
          ),
        ),
      );
    }
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
