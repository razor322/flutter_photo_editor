import 'package:flutter/material.dart';
import 'package:sticker_editor_plus/sticker_editor_plus.dart';

class EditScreen extends StatelessWidget {
  const EditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          StickerEditingView(
            height: 300,
            width: 300,
            fonts: [],
            assetList: [],
            child: Container(
              height: 300,
              width: 300,
              color: Colors.blue,
              child: Stack(
                children: [
                  StickerEditingBox(
                      boundHeight: 200,
                      boundWidth: 200,
                      pictureModel: PictureModel(
                        isNetwork: true,
                        isSelected: false,
                        left: 50,
                        top: 50,
                        scale: 1,
                        stringUrl:
                            'https://raw.githubusercontent.com/Harsh-Radadiya/sticker_editor/master/example/assets/t-shirt.jpeg',
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
