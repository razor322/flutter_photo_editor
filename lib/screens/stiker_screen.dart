import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_photo_editor/components/custom_button_icon.dart';
import 'package:get/get.dart';
import 'package:flutter_photo_editor/config/app_const.dart';
import 'package:flutter_photo_editor/controllers/ImageController.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lindi_sticker_widget/lindi_controller.dart';
import 'package:lindi_sticker_widget/lindi_sticker_widget.dart';

class StikerScreen extends StatelessWidget {
  // final ImageController imageController =
  //     Get.put(ImageController(LindiController(
  //   borderColor: Colors.white,
  //   iconColor: Colors.black,
  // )));

  final ImageController imageController = Get.find<ImageController>();
  final LindiController controller = LindiController(
    borderColor: Colors.white,
    iconColor: Colors.black,
  );
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(AppConst.TITLE_SECOND_PAGE),
      ),
      body: Column(
        children: [
          Obx(
            () => LindiStickerWidget(
              controller: controller,
              child: SizedBox(
                width: 500,
                height: 500,
                child: imageController.selectedImagePath.isEmpty
                    ? const Center(child: Text('No image selected'))
                    : Image.file(
                        File(imageController.selectedImagePath.value),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(child: Icon(Icons.error));
                        },
                      ),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomButtonicon(
                label: "Save Image",
                icon: Icons.save,
                backgroundColor: Colors.deepPurple,
                onPressed: () async {
                  Uint8List? image = await controller.saveAsUint8List();
                  if (image != null) {
                    File imageFile = await imageController.saveUint8ListAsFile(
                        image, 'img_${DateTime.now().microsecond}.png');
                    imageController.editImage(imageFile);
                  }
                  Get.back();
                },
              ),
              CustomButtonicon(
                label: "Add Stiker",
                icon: Icons.add,
                backgroundColor: Colors.deepPurple,
                onPressed: () async {
                  // final XFile? image =
                  //     await picker.pickImage(source: ImageSource.gallery);

                  XFile? imagePicked = await imageController.getStiker();

                  if (imagePicked != null) {
                    controller.addWidget(
                      Container(
                        padding: const EdgeInsets.all(5),
                        child: Image.file(
                          File(
                            imagePicked.path,
                          ),
                          width: 50,
                          height: 50,
                        ),
                      ),
                    );
                  }

                  // imageController.addStikers();
                  // imageController.onAddStikerPressed();
                },
              )
            ],
          ),
          CustomButtonicon(
            label: "Add Image",
            icon: Icons.camera,
            backgroundColor: Colors.deepPurple,
            onPressed: () {
              // imageController.onAddImagePressed();
              imageController.pickStikerImage().then((_) {
                if (imageController.selectedImagePath.isNotEmpty) {
                  controller.addWidget(
                    Container(
                      padding: const EdgeInsets.all(5),
                      child: Image.file(
                        File(imageController.selectedImagePath.value),
                        width: 50,
                        height: 50,
                      ),
                    ),
                  );
                }
              });
            },
          )
        ],
      ),
    );
  }
}
