import 'package:flutter/material.dart';
import 'package:ouevre/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class EditScreen extends StatefulWidget {
  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController mediumController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  File? selectedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveEntry() async {
    final prefs = await SharedPreferences.getInstance();
    final imageKey = 'entry_image_path';
    final title = titleController.text;
    final date = dateController.text;
    final medium = mediumController.text;
    final description = descriptionController.text;

    if (selectedImage != null) {
      await prefs.setString(imageKey, selectedImage!.path);
    }

    // Save other entry details to SharedPreferences
    // ...

    Navigator.pop(context); // Return to the home screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add an entry"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20),
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(75),
                  ),
                  child: selectedImage != null
                      ? Image.file(selectedImage!, fit: BoxFit.cover)
                      : Icon(
                          Icons.cloud_upload,
                          color: AppColors.primaryColor,
                          size: 48.0,
                        ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                "Tap to upload",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14.0,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Title",
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: "Enter title",
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Date",
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            TextField(
              controller: dateController,
              decoration: InputDecoration(
                hintText: "Enter date",
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Medium",
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            TextField(
              controller: mediumController,
              decoration: InputDecoration(
                hintText: "Enter medium",
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Description",
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                hintText: "Enter description",
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _saveEntry,
                style: ElevatedButton.styleFrom(
                  primary: AppColors.primaryColor,
                ),
                child: Text("Add Entry", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
