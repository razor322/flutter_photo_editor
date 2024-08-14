import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_photo_editor/routes/route.dart';
import 'package:flutter_photo_editor/services/models/image.dart';
import 'package:flutter_photo_editor/utils/db_helper.dart';
import 'package:get/get.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class ImageController extends GetxController {
  var images = <ImageModel>[].obs;
  Rx<XFile> imageFile = XFile('').obs;
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    loadImages();
  }

  getImage() async {
    final XFile? imagePicked =
        await picker.pickImage(source: ImageSource.gallery);

    final file = File(imagePicked.toString());
    final Uint8List bytes = await file.readAsBytes();

    if (imagePicked != null) {
      // var editImage = await Get.toNamed(AppRoutes.edit,
      //     parameters: {'image': imagePicked.path});
      // File afterEdit = await Get.to(() => ImageEditor(
      //       image: imagePicked,
      //     ));
      var afterEdit = await Get.to(() => ImageEditor(
            image: bytes,
          ));

      await saveImage(afterEdit);

      // saveImage(File(afterEdit));
      // saveImage(File(afterEdit?.path ?? imagePicked.path));
    } else {
      print('No image selected.');
    }
  }

  getImages() async {
    final XFile? imagePicked =
        await picker.pickImage(source: ImageSource.gallery);

    await editImage(imagePicked!);
    // if (imagePicked != null) {
    //   await Get.to(() => ImageEditor(
    //         image: imagePicked,
    //       ));
    //   print(imagePicked.path + " path 2 ");

    //   // saveImage(File(imagePicked.path));
    // } else {
    //   print('No image selected.');
    // }
  }

  pickImage() async {
    imageFile.value = (await picker.pickImage(
        source: ImageSource.gallery, imageQuality: 100))!;
    imageFile.refresh();
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

    // await saveImage(File(editedImage!));

    if (editedImage != null) {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'img_' + DateTime.now().second.toString() + '.png';
      final imagePath = '${directory.path}/$fileName';

      // Simpan array byte sebagai file
      final File imageFile = File(imagePath);
      await imageFile.writeAsBytes(editedImage);

      // Simpan file gambar ke database
      await saveImage(imageFile);
    }
  }

  saveImage(File imageFile) async {
    final image = ImageModel(path: imageFile.path);
    await _dbHelper.insertImage(image);
    loadImages(); // Ini memuat kembali daftar gambar setelah penyimpanan
  }

  // saveImage(File imageFile) async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   final path = directory.path;
  //   final fileName = DateTime.now().second.toString() + '.png';
  //   final File localImage = await imageFile.copy('$path/$fileName');
  //   final image = ImageModel(path: localImage.path);
  //   await _dbHelper.insertImage(image);
  //   loadImages();
  // }

  //  getImage() async {
  //   final picker = ImagePicker();
  //   final XFile? imagePicked =
  //       await picker.pickImage(source: ImageSource.gallery);

  //   if (imagePicked != null) {
  //     Uint8List imageBytes = await imagePicked.readAsBytes();
  //     Uint8List? editedImage = await Get.to(() => ImageEditor(
  //           image: imageBytes,
  //         ));
  //     if (editedImage != null) {
  //       await saveImage(editedImage);
  //       print('Edited image saved.');
  //     } else {
  //       print('No image edited.');
  //     }
  //   } else {
  //     print('No image selected.');
  //   }
  // }

  //  editImage(File imageData) async {
  //   Uint8List? imageData;
  //   var data = await rootBundle.load(imageData);
  // }

  loadImages() async {
    final imgList = await _dbHelper.getImages();
    images.assignAll(imgList);
  }

  editsImages(XFile imageData) async {
    final imageBytes = await imageData.readAsBytes();

    var editedImage = await Get.to(() => ImageEditor(
          image: imageBytes,
        ));

    await saveImage(File(editedImage.path));
  }

  //  saveImage(Uint8List imageBytes) async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   final path = directory.path;
  //   final fileName = DateTime.now().millisecondsSinceEpoch.toString() + '.png';
  //   final File imageFile = File('$path/$fileName');

  //   // Write image bytes to file
  //   await imageFile.writeAsBytes(imageBytes);

  //   // Simpan path ke database
  //   final image = ImageModel(path: imageFile.path);
  //   await _dbHelper.insertImage(image);

  //   // Memuat ulang gambar dari database
  //   loadImages();
  // }

  //  downloadImage(ImageModel image) async {
  //   final directory = await getExternalStorageDirectory();
  //   final newPath = '${directory!.path}/${path.basename(image.path)}';
  //   final File localImage = File(image.path);
  //   await localImage.copy(newPath);
  //   Get.snackbar('Download', 'Image downloaded to $newPath');
  // }

  deleteImage(int id) async {
    await _dbHelper.deleteImage(id);
    loadImages();
  }
}
