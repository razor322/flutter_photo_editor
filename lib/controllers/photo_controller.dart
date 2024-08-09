import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class photoController extends GetxController {
  Rx<XFile> img = XFile('').obs;
  final imagePicker = ImagePicker();

  pickImage() async {
    img.value = (await imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 100))!;

    img.refresh();
  }
}
