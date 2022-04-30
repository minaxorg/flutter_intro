import 'package:flutter/material.dart';
import 'package:flutter_intro/flutter_intro.dart';
import 'package:intro/advanced_guide_page.dart';
import 'package:intro/simple_use.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const StartPage(),
    );
  }
}

class StartPage extends StatelessWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Intro'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => Intro(
                      buttonTextBuilder: (order) =>
                          order == 3 ? 'Custom Button Text' : 'Next',
                      child: const SimpleUse(),
                    ),
                  ),
                );
              },
              child: const Text('Simple Use'),
            ),
            ElevatedButton(
              child: const Text('Advanced Use'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => Intro(
                      child: const AdvancedGuidePage(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
