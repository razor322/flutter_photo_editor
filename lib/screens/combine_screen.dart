import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

class MergeImagesPage extends StatefulWidget {
  @override
  _MergeImagesPageState createState() => _MergeImagesPageState();
}

class _MergeImagesPageState extends State<MergeImagesPage> {
  File? _image1;
  File? _image2;
  File? _mergedImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage1() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image1 = File(pickedFile.path);
      }
    });
  }

  Future<void> _mergeImages() async {
    if (_image1 != null && _image2 != null) {
      final img.Image image1 = img.decodeImage(_image1!.readAsBytesSync())!;
      final img.Image image2 = img.decodeImage(_image2!.readAsBytesSync())!;

      // Create a base image with the dimensions of the larger image.
      // final img.Image baseImage = img.Image(
      //   width: image1.width > image2.width ? image1.width : image2.width,
      //   height: image1.height > image2.height ? image1.height : image2.height,
      // );
      final img.Image baseImage = img.Image(width: 50, height: 50);

      // Composite the two images on top of each other.
      img.compositeImage(baseImage, image1);
      img.compositeImage(baseImage, image2, blend: img.BlendMode.overlay);

      // Save the merged image.
      final mergedImageFile = File('${_image1!.parent.path}/merged_image.png')
        ..writeAsBytesSync(img.encodePng(baseImage));

      setState(() {
        _mergedImage = mergedImageFile;
      });
    }
  }

  Future<void> _pickImage2() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image2 = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Merge Images'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_image1 != null)
              Image.file(
                _image1!,
                width: 100,
              ),
            SizedBox(height: 20),
            if (_image2 != null) Image.file(_image2!, width: 100),
            SizedBox(height: 20),
            if (_mergedImage != null) Image.file(_mergedImage!, width: 100),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage1,
              child: Text('Pick First Image'),
            ),
            ElevatedButton(
              onPressed: _pickImage2,
              child: Text('Pick Second Image'),
            ),
            ElevatedButton(
              onPressed: () {
                // Uncomment untuk mengaktifkan fungsi penggabungan gambar
                _mergeImages();
              },
              child: Text('Merge Images'),
            ),
          ],
        ),
      ),
    );
  }
}
