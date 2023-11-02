import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ouevre/screens/edit_screen.dart';
import 'package:ouevre/screens/home_screen.dart';
import 'package:ouevre/screens/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageDescriptionScreen extends StatefulWidget {
  final String imagePath;
  final String title;
  final String date;
  final String medium;
  final String description;

  ImageDescriptionScreen({
    required this.imagePath,
    required this.title,
    required this.date,
    required this.medium,
    required this.description,
  });

  @override
  _ImageDescriptionScreenState createState() => _ImageDescriptionScreenState();
}

class _ImageDescriptionScreenState extends State<ImageDescriptionScreen> {
  late String title;
  late String date;
  late String medium;
  late String description;
  late String imagePath;
  String searchQuery = "";
  List<String> savedImages = [];
  List<String> filteredImages = [];

  @override
  void initState() {
    super.initState();
    title = widget.title;
    date = widget.date;
    medium = widget.medium;
    description = widget.description;
    imagePath = widget.imagePath;
    fetchImages();
  }

  Future<void> fetchImages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> images = prefs.getStringList("savedImages") ?? [];
    setState(() {
      savedImages = images;
      filteredImages = images; // Initially display all images
    });
  }

  void filterImages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> filtered = savedImages.where((imagePath) {
      String title = prefs.getString("${imagePath}-title") ?? "";
      String date = prefs.getString("${imagePath}-date") ?? "";
      String medium = prefs.getString("${imagePath}-medium") ?? "";

      return title.contains(searchQuery) ||
          date.contains(searchQuery) ||
          medium.contains(searchQuery);
    }).toList();

    setState(() {
      filteredImages = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => FullScreenImage(imagePath),
                ));
              },
              child: Image.file(
                File(imagePath),
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40.0,
                  color: Colors.grey[700],
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 1),
              child: Row(
                children: [
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.grey[400],
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    "•",
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                  SizedBox(width: 8),
                  Text(
                    medium,
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                description,
                style: TextStyle(
                  fontSize: 17.0,
                  color: Color.fromARGB(255, 155, 155, 155),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GestureDetector(
                onTap: () async {
                  final result =
                      await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EditScreen(
                      imagePath: imagePath,
                      title: title,
                      date: date,
                      medium: medium,
                      description: description,
                    ),
                  ));

                  if (result != null) {
                    setState(() {
                      title = result['title'];
                      date = result['date'];
                      medium = result['medium'];
                      description = result['description'];
                      imagePath = result['imagePath'];
                    });
                  }
                },
                child: Row(
                  children: [
                    Icon(Icons.edit, color: Colors.purple),
                    SizedBox(width: 5),
                    Text(
                      'Edit entry',
                      style: TextStyle(
                        color: Colors.purple,
                        fontSize: 17.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.search, color: Colors.grey),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      color: Colors.black.withOpacity(0.2),
                      padding: EdgeInsets.all(20),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                          filterImages();
                        },
                        decoration: InputDecoration(
                          hintText: 'Search titles, tags, dates, media...',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.search, color: Colors.purple),
                            onPressed: () {
                              filterImages();
                            },
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.home, color: Colors.purple),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.logout, color: Colors.grey),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
            ),
          ],
        ),
        color: Colors.white,
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imagePath;

  FullScreenImage(this.imagePath);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Image.file(File(imagePath)),
          ),
          Positioned(
            right: 10,
            top: 10,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
