import 'package:flutter/material.dart';
import 'package:tokosm_v2/shared/themes.dart';
import 'package:intl/intl.dart';

String baseURL = "https://apitokosm.share.zrok.io/api/v1";
String imageURL = "http://10.10.10.98:3000/uploads/images";

class Utils {
  void scaffoldMessenger(
    BuildContext context,
    String text,
  ) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(
        content: Text(
          text,
        ),
      ),
    );
  }

  void alertDialog({
    required BuildContext context,
    required Function function,
    required String title,
    required String message,
  }) {
    showDialog(
      context: context,
      builder: (
        BuildContext context,
      ) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(
              fontWeight: bold,
            ),
          ),
          content: Text(message),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
              child: const Text("OK"),
              onPressed: () {
                function();
              },
            ),
          ],
        );
      },
    );
  }
}

String formatTanggal(String input) {
  DateTime dateTime = DateTime.parse(input);
  // Format: 18 April 2025 23:00
  return DateFormat("d MMMM y HH:mm", "id_ID").format(dateTime);
}
