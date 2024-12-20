import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
class CreateProfileScreen1 extends StatefulWidget{
  @override
  CreateProfileScreenState1 createState() => CreateProfileScreenState1(); 
}

class CreateProfileScreenState1 extends State<CreateProfileScreen1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget> [
          PictureWidget(),

        ],
      ),
    );
  }
}

class PictureWidget extends StatefulWidget {
  @override
  _PictureWidgetState createState() => _PictureWidgetState();
}

class _PictureWidgetState extends State<PictureWidget> {
  File? _image;

  final picker = ImagePicker();

  // Function to pick image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
    Widget build(BuildContext context) {
      return Center( // Center the entire Column
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Vertically center the children
          crossAxisAlignment: CrossAxisAlignment.center, // Horizontally center the children
          children: <Widget>[
            GestureDetector(
              onTap: _pickImage, // Trigger the image picker when tapped
              child: Stack(
                alignment: Alignment.center, // Center the icon inside the CircleAvatar
                children: [
                  _image == null
                      ? CircleAvatar(
                          radius: 100,
                          backgroundImage: AssetImage('assets/images/profile_placeholder.png'),
                        )
                      : CircleAvatar(
                          radius: 100,
                          backgroundImage: FileImage(_image!),
                        ),
                  Positioned(
                    // center: 10, // Adjust the position of the icon (you can change this value)
                    child: Icon(
                      Icons.camera_alt,
                      size: 30, // Icon size
                      color: Colors.white, // Icon color
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      );
    }


}