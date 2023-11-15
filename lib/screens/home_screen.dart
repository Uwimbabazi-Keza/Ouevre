import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ouevre/screens/edit_screen.dart';
import 'package:ouevre/screens/image_description.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ouevre/screens/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> savedImages = [];
  List<String> filteredImages = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  Future<void> fetchImages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //fetch images from user's device
    List<String> images = prefs.getStringList("savedImages") ?? [];
    setState(() {
      savedImages = images;
      filteredImages = images; // Initially display all images
    });

    // Fetch images from Firebase
    FirebaseFirestore.instance
        .collection('journal_entries')
        .get()
        .then((querySnapshot) {
      List<String> firebaseImages = [];
      querySnapshot.docs.forEach((doc) {
        firebaseImages.add(doc['imagePath']);
      });

      setState(() {
        savedImages.addAll(firebaseImages);
        filteredImages = savedImages; // Initially display all images
      });
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
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(80.0),
              child: Text(
                'My Art Journal',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 33,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: filteredImages.isNotEmpty
                    ? GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 5.0,
                          mainAxisSpacing: 10.0,
                        ),
                        itemCount: filteredImages.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              String title = prefs.getString(
                                      "${filteredImages[index]}-title") ??
                                  "";
                              String date = prefs.getString(
                                      "${filteredImages[index]}-date") ??
                                  "";
                              String medium = prefs.getString(
                                      "${filteredImages[index]}-medium") ??
                                  "";
                              String description = prefs.getString(
                                      "${filteredImages[index]}-description") ??
                                  "";

                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ImageDescriptionScreen(
                                    imagePath: filteredImages[index],
                                    title: title,
                                    date: date,
                                    medium: medium,
                                    description: description,
                                  ),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(7.0),
                              child: AspectRatio(
                                aspectRatio: 2 / 3,
                                child: Image.file(
                                  File(filteredImages[index]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          'No images matched your search.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 228, 74, 255),
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditScreen(
                imagePath: "",
                title: "",
                date: "",
                medium: "",
                description: "",
              ),
            ),
          );
          fetchImages();
        },
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
