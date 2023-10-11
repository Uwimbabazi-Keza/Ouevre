import 'package:flutter/material.dart';
import 'package:ouevre/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: AppColors.primaryColor, // Use primary color as background
            padding: EdgeInsets.all(16),
            child: Center(
              child: Text(
                'My Journal',
                style: TextStyle(
                  color: AppColors.normaltextColor, // Use normal text color
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                _selectImage(context); // Call function to select image
              },
              style: ElevatedButton.styleFrom(
                primary: AppColors.primaryColor, // Use primary color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                child: Center(
                  child: Text(
                    'Add +',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: _buildImageGrid(), // Build the image grid
          ),
        ],
      ),
    );
  }

  // Function to select image using image_picker
  Future<void> _selectImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Handle the selected image, e.g., save it to your data or display it in the grid
    }
  }

  // Function to build the image grid
  Widget _buildImageGrid() {
    // Replace this with your logic to display user uploads in a masonry grid
    return StaggeredGridView.countBuilder(
      crossAxisCount: 2, // Number of columns in the grid
      mainAxisSpacing: 4.0, // Spacing between columns
      crossAxisSpacing: 4.0, // Spacing between rows
      itemCount: 10, // Replace with the actual number of user uploads
      itemBuilder: (BuildContext context, int index) {
        // Replace this with code to display user uploads in a grid
        return Card(
          color: Colors.white, // Background color of the card
          child: Center(
            child: Text('User Upload $index'),
          ),
        );
      },
      staggeredTileBuilder: (int index) => StaggeredTile.count(
          1, index.isEven ? 1.2 : 1.8), // Adjust tile sizes as needed
    );
  }
}
