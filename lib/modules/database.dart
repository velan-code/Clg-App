// DataBase Actual Handling

// **** PreModules ****
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Map<String, String> period(String subject, String time, String room) {
  return {"subject": subject, "time": time, "room": room};
}

Map<String, List<Map<String, String>>> dayOrder(
  String Day,
  List<Map<String, String>> Periods,
) {
  return {Day: Periods};
}

Map<String, List<Map<String, String>>> defaultData = {
  "Mon": [
    {"time": "00:00", "subject": "unknow", "room": " - "},
  ],
};

class ColorPalette {
  static const Color deepOrange = Color(0xFFEA6113);
  static const Color sunsetOrange = Color(0xFFF88F22);
  static const Color amberYellow = Color(0xFFFBB931);
  static const Color creamBeige = Color(0xFFFFE3B3);

  // You can also define your gradient here to reuse it
  static const LinearGradient sunsetGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [deepOrange, sunsetOrange, amberYellow],
  );

  static const LinearGradient sunriseGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomCenter,
    colors: [creamBeige, sunsetOrange, deepOrange],
  );
}

class Elements {
  static ShapeDecoration decoration = ShapeDecoration(
    gradient: ColorPalette.sunriseGradient,
    shape: ContinuousRectangleBorder(
      borderRadius: BorderRadius.circular(48), // High value = smoother squircle
    ),
    shadows: [
      BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
    ],
  );

  static BoxDecoration glassDecoration = BoxDecoration(
    color: Colors.white.withOpacity(0.2),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: Colors.white30),
  );
}

// The Singleton Class for Firebase Instance
class FirestoreDatabase {
  // Private constructor
  FirestoreDatabase._internal();

  // The single instance
  static final FirestoreDatabase instance = FirestoreDatabase._internal();

  // The private Firestore instance
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // WRITE-Methods
  // 1. Create or Overwrite a document (Set)
  // Use this when you have a specific ID (like a class name)
  static Future<void> setSchedule(
    String className,
    Map<String, dynamic> data,
  ) async {
    try {
      await _db.collection("timetable").doc(className).set(data);
    } catch (e) {
      print("Error writing document: $e");
    }
  }

  static Future<void> createClass(String className) async {
    try {
      await _db.collection("timetable").doc(className).set(defaultData);
    } catch (e) {
      print(e);
    }
  }

  // 2. Update specific fields
  // Use this to change one field without deleting the rest of the document
  static Future<void> updateSchedule(
    String className,
    Map<String, dynamic> data,
  ) async {
    await _db.collection("timetable").doc(className).update(data);
  }

  // 4. Delete a document
  static Future<void> removeClass(String className) async {
    await _db.collection("timetable").doc(className).delete();
  }

  // READ-Methods
  static Stream<DocumentSnapshot> getSchedule(String className) {
    return _db.collection("timetable").doc(className).snapshots();
  }

  static Stream<QuerySnapshot> getClassNames() {
    return _db.collection("timetable").snapshots();
  }
}
