import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tokosm_v2/shared/themes.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        margin: const EdgeInsets.only(
          top: 10,
          left: 16,
          right: 16,
        ),
        child: Column(
          children: [
            Row(
              spacing: 10,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    SolarIconsOutline.arrowLeft,
                  ),
                ),
                Text(
                  'Edit Profil',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: bold,
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                children: [],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
