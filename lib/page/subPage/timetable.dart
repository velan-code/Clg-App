// TimeTable Page which contain and handle of timetable
//

// **** Modules ****
import 'package:clg_app/modules/database.dart';

// **** PreModules ****
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// TimeTable Page HAndler
class TimetablePage extends StatefulWidget {
  String ClassName;
  TimetablePage({required this.ClassName});
  @override
  _TimetablePageState createState() =>
      _TimetablePageState(CLassname: ClassName);
}

class _TimetablePageState extends State<TimetablePage> {
  // Basic variable and data is mentioned here
  final List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  String selectedDay = 'Mon';
  String CLassname;

  _TimetablePageState({required this.CLassname});

  // Ovveride Function to build UI of TimeTablePage using WIdgets
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Prefered Page Color and Appbar
      backgroundColor: ColorPalette.creamBeige,
      appBar: AppBar(
        title: const Text('Class Timetable'),
        backgroundColor: ColorPalette.creamBeige,
        elevation: 0,
      ),

      // Actual Body
      body: Column(
        children: [
          // 1. Horizontal SLideBAr for choose Days
          Container(
            height: 80,
            color: ColorPalette.deepOrange,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: days.length,
              itemBuilder: (context, index) {
                bool isSelected = selectedDay == days[index];
                return GestureDetector(
                  onTap: () => setState(() => selectedDay = days[index]),
                  child: Container(
                    width: 70,
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.white24,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        days[index],
                        style: TextStyle(
                          color: isSelected ? Colors.blueAccent : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // 2. Period LIST SHow here below
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              // StreamBuilderObject to HAndle Data PAckage
              stream: FirestoreDatabase.getSchedule(
                CLassname,
              ), // 1. CArd Area, MAke Card of peroid by StreamData
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("Something went wrong"));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(
                    child: Text("No schedule found for this class."),
                  );
                }

                // 2. Extract Data form PAckage
                final data = snapshot.data!.data() as Map<String, dynamic>?;

                // Verify data is not empty and handle it
                if (data == null)
                  return const Center(child: Text("Data is empty"));

                // 3. Model our data in fullDoc
                // We cast as Map because a Document is always a Map in Firestore
                final Map<String, dynamic> fullDoc =
                    snapshot.data!.data() as Map<String, dynamic>;

                // 4. Day-Specific Extraction
                // We use your 'selectedDay' variable to grab the right List
                final List<dynamic> daySchedule = fullDoc[selectedDay] ?? [];

                if (daySchedule.isEmpty) {
                  return const Center(
                    child: Text("No classes scheduled for today!"),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: daySchedule.length,
                  itemBuilder: (context, index) {
                    var period = daySchedule[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: SizedBox(
                          width: 70, // Fixed width for alignment
                          child: Center(
                            child: Text(
                              period['time'] ?? '',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          period['subject'] ?? 'Unknown',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(period['room'] ?? 'No Room'),
                        trailing: const Icon(
                          Icons.class_outlined,
                          color: Colors.blueAccent,
                        ),
                        onTap: () {
                          // Navigate to detail page
                          /* Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SubjectDetailPage(
                                subjectName: period["subject"] ?? "Subject",
                              ),
                            ),
                          );
                          */
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SubjectDetailPage extends StatelessWidget {
  final String subjectName;

  SubjectDetailPage({required this.subjectName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(subjectName)),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context), // Go back
          child: Text('Go Back'),
        ),
      ),
    );
  }
}
