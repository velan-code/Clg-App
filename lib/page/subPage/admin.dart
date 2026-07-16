import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clg_app/modules/database.dart';

dynamic addSection(String CLassname) {
  FirestoreDatabase.createClass(CLassname);
  print("Section Added");
}

class adminPage extends StatefulWidget {
  adminPage({super.key});

  @override
  State<adminPage> createState() => _AdminPage();
}

class _AdminPage extends State<adminPage> {
  // purpose-function
  // 1. add new section_class
  // 2. add, new , change orderr of timetable
  // 3. sort button to , system sync timetable

  @override
  Widget build(BuildContext Context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,

      // APP BAR
      appBar: AppBar(
        title: Text("ADMIN PAGE"),
        backgroundColor: ColorPalette.creamBeige,
        elevation: 10,
      ),

      // Body at hold schedulePage Scroller
      body: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.zero),
          gradient: ColorPalette.sunsetGradient,
        ),
        height: double.infinity,
        width: double.infinity,
        child: schedulePage(),
      ),

      // Add Section button
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final TextEditingController nameController = TextEditingController();

          final String? className = await showDialog<String>(
            context: context,
            barrierColor: Colors.black.withOpacity(
              0.3,
            ), // Lighter barrier = less "dim"
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.transparent, // Let your decoration show
                contentPadding:
                    EdgeInsets.zero, // We handle padding in the Container
                content: Container(
                  width:
                      MediaQuery.of(context).size.width * 0.8, // Center width
                  decoration: Elements.glassDecoration, // Your glass style
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Wrap content height
                    children: [
                      // 1. Title (Centered)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          "NEW SECTION",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),

                      // 2. Center Straight Line (Divider)
                      Container(
                        height: 1,
                        width: double.infinity,
                        color: Colors.white.withOpacity(0.3),
                      ),

                      // 3. Below Input Field
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
                        child: TextField(
                          controller: nameController,
                          autofocus: true,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Enter Name",
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.05),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),

                      // 4. Add Button (Bottom Right)
                      Padding(
                        padding: const EdgeInsets.only(right: 16, bottom: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                "CANCEL",
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.2),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () => Navigator.pop(
                                context,
                                nameController.text.trim(),
                              ),
                              child: const Text("ADD"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );

          if (className != null && className.isNotEmpty) {
            addSection(className);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class schedulePage extends StatefulWidget {
  schedulePage({super.key});

  @override
  State<schedulePage> createState() => _SchedulePage();
}

class _SchedulePage extends State<schedulePage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      // 1. tell database to give package in stream
      stream: FirestoreDatabase.getClassNames(),

      // 2. Going verify data and build buttons
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none)
          return const Center(child: Text("CHeck internetConnection !!"));
        if (snapshot.hasError)
          return const Center(child: Text("Something Wrong"));
        if (snapshot.connectionState == ConnectionState.waiting)
          return CircularProgressIndicator();
        if (snapshot.data!.docs.length == 0)
          return const Center(child: Text("No section detail Available"));
        // 3. Extract Document_data form package
        final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
        return GridView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.only(
            top: 100, // Space for the AppBar area
            left: 25,
            right: 25,
            bottom: 100, // Space for the CurvedNavigationBar
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 25,
            mainAxisSpacing: 20,
          ),
          itemCount: documents.length,
          itemBuilder: (context, index) {
            return ClassRoomEditButton(ClassRoomName: documents[index].id);
          },
        );
      },
    );
  }
}

class ClassRoomEditButton extends StatelessWidget {
  final String ClassRoomName;
  const ClassRoomEditButton({super.key, required this.ClassRoomName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // ONTap open TimeTable for given Section
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TimetablePage(ClassName: ClassRoomName),
          ),
        );
      },

      // Body
      child: Container(
        height: 100,
        width: 100,
        decoration: Elements.decoration,
        // Use Stack to layer the button over the text
        child: Stack(
          children: [
            // 1. The Main Content (Centered)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Class Rooms", style: TextStyle(fontSize: 12)),
                  Text(
                    ClassRoomName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            // 2. The Cancel Button (Positioned at the top)
            Positioned(
              top: 0,
              right: 0, // Change to left: 0 if you prefer
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => FirestoreDatabase.removeClass(ClassRoomName),
                icon: const Icon(
                  Icons.cancel,
                  size: 20,
                  color: ColorPalette.creamBeige,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Create a StateFullPage for Referenceness
class TimetablePage extends StatefulWidget {
  String ClassName;
  TimetablePage({required this.ClassName});
  @override
  _TimetablePageState createState() =>
      _TimetablePageState(CLassname: ClassName);
}

// Create PageState for TImeTablePAge
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

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),

        onPressed: () {
          print("hello");
        },
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
