// schdhulePage Screeen which should contain UI and Elements
//

// **** Pages ****
import 'package:clg_app/page/subPage//timetable.dart';

// **** Modules ****
import 'package:clg_app/modules/database.dart';

// **** PreModules ****
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// SchedulePage handler
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
            return ClassRoomSelectionButton(ClassRoomName: documents[index].id);
          },
        );
      },
    );
  }
}

class ClassRoomSelectionButton extends StatelessWidget {
  final String ClassRoomName;
  const ClassRoomSelectionButton({super.key, required this.ClassRoomName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TimetablePage(ClassName: ClassRoomName),
          ),
        );
      },
      child: Container(
        height: 100,
        width: 100,
        decoration: Elements.decoration,

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
          ],
        ),
      ),
    );
  }
}
