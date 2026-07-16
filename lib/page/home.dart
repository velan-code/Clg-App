// HomePage contain UI and Element of homePage
//

// **** Module ****
import 'package:clg_app/modules/database.dart';

// **** PreModules ****
import 'package:flutter/material.dart';
import 'dart:ui';

// HomePage class State Handler
class homePage extends StatefulWidget {
  homePage({super.key});
  @override
  State<homePage> createState() => _HomePage();
}

class _HomePage extends State<homePage> {
  // Inside _HomePage State
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello, Velan!",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text("Thursday, 20 March", style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 30),

            // Next Class Card
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white30),
              ),
              child: Row(
                children: [
                  Icon(Icons.auto_awesome, color: Colors.amber, size: 40),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "NEXT CLASS",
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 1.2,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        "Data Structures",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Room 402 • 10:30 AM",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
            Text(
              "Quick Actions",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Grid of actions
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: [
                  _buildMenuCard(Icons.book, "Materials"),
                  _buildMenuCard(Icons.event_note, "Events"),
                  _buildMenuCard(Icons.notifications, "Notices"),
                  _buildMenuCard(Icons.percent, "Attendance"),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 10,
                        sigmaY: 10,
                      ), // The frost effect
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1.5,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Icon(Icons.nineteen_mp),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildMenuCard(IconData icon, String title) {
  return Container(
    decoration: Elements.glassDecoration,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 40, color: ColorPalette.deepOrange),
        SizedBox(height: 10),
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    ),
  );
}
