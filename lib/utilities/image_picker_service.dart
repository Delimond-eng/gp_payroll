import 'package:image_picker/image_picker.dart';

Future<XFile> takePhoto() async {
  final ImagePicker _picker = ImagePicker();
  final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 200,
      maxWidth: 200,
      imageQuality: 50);

  if (pickedFile != null) {
    return pickedFile;
  }
}
