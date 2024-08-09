import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_photo_editor/controllers/ImageController.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? image;
  double _rotationAngle = 0.0;
  // XFile? imageFile;
  // Future<void> _onClick() async {
  //   imageFile = await ImageService().pickCropImage(
  //       cropAspectRatio: CropAspectRatio(ratioX: 16, ratioY: 9),
  //       imageSource: ImageSource.gallery);

  //   setState(() {});
  // }

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final XFile? imagePicked =
        await picker.pickImage(source: ImageSource.gallery);

    image = File(imagePicked!.path);
    setState(() {
      if (imagePicked != null) {
        image = File(imagePicked.path);
        _rotationAngle = 0.0;
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _getImage2() async {
    final picker = ImagePicker();
    final XFile? imagePicked =
        await picker.pickImage(source: ImageSource.gallery);

    // if (imagePicked != null) {
    //   ImageController.saveImage(File(imagePicked.path));
    // } else {
    //   print('No image selected.');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Photo Editor',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: image == null
                // ? Text('No image selected')
                ? Image.asset('./lib/resources/placeholder.png',
                    width: 300, height: 300)
                : Image.file(image!, width: 300, height: 300),
          ),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(onPressed: () {}, child: Text("SAVE"))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _getImage();
        },
        child: const Icon(Icons.camera_enhance),
      ),
    );
  }
}
