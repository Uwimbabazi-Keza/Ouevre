import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class EditScreen extends StatefulWidget {
  final String imagePath;
  final String title;
  final String date;
  final String medium;
  final String description;
  final bool isNewEntry;

  EditScreen({
    required this.imagePath,
    required this.title,
    required this.date,
    required this.medium,
    required this.description,
    this.isNewEntry = false,
  });

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final titleController = TextEditingController();
  final dateController = TextEditingController();
  final mediumController = TextEditingController();
  final descriptionController = TextEditingController();
  File? _image;

  @override
  void initState() {
    super.initState();
    titleController.text = widget.title;
    dateController.text = widget.date;
    mediumController.text = widget.medium;
    descriptionController.text = widget.description;

    if (widget.isNewEntry) {
      getImage();
    }
  }

  Future getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File file = File(pickedFile.path);
      setState(() {
        _image = file;
      });
    }
  }

  Future<String> compressAndSaveImage(File imageFile) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath =
        directory.path + "/${DateTime.now().millisecondsSinceEpoch}.jpg";
    var result = await FlutterImageCompress.compressAndGetFile(
      imageFile.path,
      filePath,
      quality: 85,
    );
    return result!.path;
  }

  Future<void> saveEntry() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String finalImagePath = _image?.path ?? widget.imagePath;

    // If it's a new entry or a new image is selected, compress, save and store the new image path
    if (widget.isNewEntry || _image != null) {
      finalImagePath = await compressAndSaveImage(_image!);
      List<String> savedImages = prefs.getStringList("savedImages") ?? [];
      savedImages.add(finalImagePath);
      await prefs.setStringList("savedImages", savedImages);
    }

    // Save the edited details
    await prefs.setString("$finalImagePath-title", titleController.text);
    await prefs.setString("$finalImagePath-date", dateController.text);
    await prefs.setString("$finalImagePath-medium", mediumController.text);
    await prefs.setString(
        "$finalImagePath-description", descriptionController.text);

    Navigator.pop(context, {
      'title': titleController.text,
      'date': dateController.text,
      'medium': mediumController.text,
      'description': descriptionController.text,
      'imagePath': finalImagePath,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    widget.isNewEntry ? "New Entry" : "Edit Entry",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 50) // For alignment purposes
                ],
              ),
              SizedBox(height: 40),
              Center(
                child: IconButton(
                  iconSize: 70.0,
                  color: Colors.purple,
                  icon: widget.isNewEntry
                      ? Icon(Icons.add)
                      : Icon(
                          Icons.upload_file), // Change icon if it's a new entry
                  onPressed: getImage,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Title')),
              SizedBox(height: 20),
              TextField(
                  controller: dateController,
                  decoration: InputDecoration(labelText: 'Date')),
              SizedBox(height: 20),
              TextField(
                  controller: mediumController,
                  decoration: InputDecoration(labelText: 'Medium')),
              SizedBox(height: 20),
              TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description')),
              SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.purple,
                ),
                child: Text('Save Changes'),
                onPressed: saveEntry,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    dateController.dispose();
    mediumController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
