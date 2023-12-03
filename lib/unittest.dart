import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ouevre/screens/edit_screen.dart';
import 'package:ouevre/screens/home_screen.dart';
import 'package:ouevre/screens/image_description.dart';

void main() {
  group('ImageDescriptionScreen Widget Tests', () {
    testWidgets('ImageDescriptionScreen displays details correctly',
        (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        MaterialApp(
          home: ImageDescriptionScreen(
            imagePath: 'path/to/image.jpg',
            title: 'Test Title',
            date: 'Test Date',
            medium: 'Test Medium',
            description: 'Test Description',
          ),
        ),
      );

      // Verify that the ImageDescriptionScreen displays the correct details.
      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test Date'), findsOneWidget);
      expect(find.text('Test Medium'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
    });

    testWidgets('ImageDescriptionScreen navigates to FullScreenImage',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ImageDescriptionScreen(
            imagePath: 'path/to/image.jpg',
            title: 'Test Title',
            date: 'Test Date',
            medium: 'Test Medium',
            description: 'Test Description',
          ),
        ),
      );

      // Tap on the image to navigate to FullScreenImage
      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle();

      // Verify that FullScreenImage is displayed after tapping the image.
      expect(find.byType(FullScreenImage), findsOneWidget);
    });
  });

  group('HomeScreen Widget Tests', () {
    testWidgets('HomeScreen displays "My Art Journal"',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HomeScreen(),
        ),
      );

      // Verify that HomeScreen displays the title.
      expect(find.text('My Art Journal'), findsOneWidget);
    });

    testWidgets('HomeScreen displays images correctly',
        (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        MaterialApp(
          home: HomeScreen(),
        ),
      );

      // Assuming there are images displayed, verify that images are shown.
      expect(find.byType(Image), findsWidgets);
    });
  });

  group('EditScreen Widget Tests', () {
    testWidgets('EditScreen displays "New Entry"', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EditScreen(
            imagePath: '',
            title: '',
            date: '',
            medium: '',
            description: '',
            isNewEntry: true,
          ),
        ),
      );

      // Verify that EditScreen displays "New Entry" when creating a new entry.
      expect(find.text('New Entry'), findsOneWidget);
    });

    testWidgets('EditScreen allows image upload', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EditScreen(
            imagePath: '',
            title: '',
            date: '',
            medium: '',
            description: '',
            isNewEntry: true,
          ),
        ),
      );

      // Tap on the icon to simulate image upload.
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Verify that the image is displayed after upload.
      expect(find.byType(Image), findsOneWidget);
    });
  });
}
