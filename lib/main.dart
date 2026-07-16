// Author : velan
// Description : making application for my college
// Date : 20 march 2026

// Main is the Main Page holder got instance of page and show in it

// **** Pages ****
import 'package:clg_app/page/schedule.dart';
import 'package:clg_app/page/home.dart';
import 'package:clg_app/page/profile.dart';

// **** Modules ****
import 'package:clg_app/modules/database.dart';

// **** Resource ****
import 'package:clg_app/resource/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

// **** PreModules ****
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

// initializeApp And database(FireBase)
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

// MaterialApp Entity
class MyApp extends StatelessWidget {
  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TextTheme(
          displayMedium: TextStyle(
            color: ColorPalette.creamBeige,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: "Space-Mono",
          ),
        ),
      ),
      home: MainScreen(),
    );
  }
}

// Main Screen which is going to handle many pages inside
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _scenes = [
    homePage(), // Index 0
    schedulePage(),
    profilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Changes the scene and rebuilds the UI
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      // 1.Body of page decide by index for navigation bar
      body: Container(
        // CUstomize Container for gradient background
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(gradient: ColorPalette.sunsetGradient),

        // Actual Body
        child: _scenes[_selectedIndex],
      ),

      // 2. Navigation Bar customize
      bottomNavigationBar: CurvedNavigationBar(
        items: [
          Icon(Icons.home, size: 30),
          Icon(Icons.calendar_month, size: 30),
          Icon(Icons.person_2, size: 30),
        ],

        animationCurve: Curves.easeInOutSine,
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Colors.transparent,
        color: ColorPalette.creamBeige,

        onTap: (index) {
          _onItemTapped(index);
        },
      ),
    );
  }
}
