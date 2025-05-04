import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CustomStorage extends StatefulWidget {
  const CustomStorage({super.key});

  @override
  State<CustomStorage> createState() => _CustomStorageState();
}

class _CustomStorageState extends State<CustomStorage> {
  final _ImagePicker = ImagePicker();
  File? imageFile;

  getImage() async {
    final pickedFile = await _ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      log(pickedFile.toString());
      setState(() {});
      print("Image Picked");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase Storage"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          imageFile != null
              ? Image.file(imageFile!)
              : ElevatedButton(
                onPressed: () {
                  getImage();
                },
                child: const Text("Pick Image"),
              ),
        ],
      ),
    );
  }
}
