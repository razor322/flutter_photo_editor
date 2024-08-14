import 'package:flutter/material.dart';
import 'package:flutter_photo_editor/screens/edit_screen.dart';

class StikersScreen extends StatefulWidget {
  const StikersScreen({Key? key}) : super(key: key);

  @override
  _StikersScreenState createState() => _StikersScreenState();
}

class _StikersScreenState extends State<StikersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StickerEditor Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditScreen()));
                },
                child: const Text('StickerEditingBox'))
          ],
        ),
      ),
    );
  }
}
