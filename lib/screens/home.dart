import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_editor_plus/options.dart';

void main() {
  runApp(
    const MaterialApp(
      home: ImageEditorExample(),
    ),
  );
}

class ImageEditorExample extends StatefulWidget {
  const ImageEditorExample({
    super.key,
  });

  @override
  createState() => _ImageEditorExampleState();
}

class _ImageEditorExampleState extends State<ImageEditorExample> {
  Uint8List? imageData;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ImageEditor Example"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (imageData != null) Image.memory(imageData!),
          const SizedBox(height: 16),
          ElevatedButton(
            child: const Text("Pick and edit image"),
            onPressed: () async {
              // Pick an image from the gallery
              final XFile? image =
                  await _picker.pickImage(source: ImageSource.gallery);

              if (image != null) {
                // Load image data
                final imageBytes = await image.readAsBytes();

                // Open the image editor
                var editedImage = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageEditor(
                      image: imageBytes,
                      cropOption: const CropOption(
                        reversible: false,
                      ),
                    ),
                  ),
                );

                if (editedImage != null) {
                  setState(() {
                    imageData = editedImage;
                  });
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
