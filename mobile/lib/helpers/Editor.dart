import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as PartHelper;
import 'package:zefyr/zefyr.dart';

class GRZefyrImageDelegate implements ZefyrImageDelegate<ImageSource> {

  @override
  Future<String> pickImage(ImageSource source) async {
    // Copy Image from Album to App Storage
    final file = await ImagePicker.pickImage(source: source);
    final path = await getApplicationDocumentsDirectory();
    final newImage = await file.copy('${path.path}/${PartHelper.basename(file.path)}');
    if (file == null || newImage == null) return null;
    return newImage.uri.toString();
  }

  @override
  Widget buildImage(BuildContext context, String key) {
    final file = File.fromUri(Uri.parse(key));
    final image = FileImage(file);
    return Image(image: image);
  }

  @override
  ImageSource get cameraSource => ImageSource.camera;

  @override
  ImageSource get gallerySource => ImageSource.gallery;
}