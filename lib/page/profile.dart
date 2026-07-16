// Profile page Screeen
//

// **** Pages ****
import 'package:clg_app/page/subPage/admin.dart';

// **** Modules ****
import 'package:clg_app/modules/database.dart';

// **** PreModules ****
import 'package:flutter/material.dart';

// Profile Screen HAndler
class profilePage extends StatefulWidget {
  profilePage({super.key});

  @override
  State<profilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<profilePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 20,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              height: 100,
              width: 380,
              decoration: Elements.glassDecoration,
              child: Text(
                " Senthil Velan JP ",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorPalette.creamBeige,
                  fontFamily: "Space_mono",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
