import 'package:flutter/material.dart';
import 'package:tokosm_v2/shared/themes.dart';
import 'package:intl/intl.dart';

String baseURL = "https://apitokosm.share.zrok.io/api/v1";
//"http://10.10.10.98:3001/api/v1"; //"https://apitokosm.share.zrok.io/api/v1";

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

  void alertDialog(
      {required BuildContext context,
      required Function function,
      required String title,
      required String message,
      String cancelTitle = "Cancel",
      String confirmTitle = "Ok"}) {
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
              child: Text(cancelTitle),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
              child: Text(confirmTitle),
              onPressed: () {
                function();
              },
            ),
          ],
        );
      },
    );
  }

  void customAlertDialog(
      {required BuildContext context,
      required Function confirmationFunction,
      required Widget content,
      required String title,
      String cancelTitle = "Cancel",
      String confirmTitle = "Ok"}) {
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
          content: content,
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
              child: Text(cancelTitle),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
              child: Text(confirmTitle),
              onPressed: () {
                confirmationFunction();
              },
            ),
          ],
        );
      },
    );
  }

  void loadingDialog({
    required BuildContext context,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: Center(
            // Ensures the dialog is centered and sized exactly
            child: Container(
              width: 60,
              height: 60,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const CircularProgressIndicator(
                color: Colors.green, // replace with colorSuccess if needed
                strokeWidth: 3,
              ),
            ),
          ),
        );
      },
    );
  }

  String formatTanggal(String input) {
    DateTime dateTime = DateTime.parse(input);
    // Format: 18 April 2025 23:00
    return DateFormat("d MMMM y HH:mm", "id_ID").format(dateTime);
  }

  DateTime? normalizeToDateTime(String dateString) {
    final List<String> knownFormats = [
      "dd/MM/yyyy",
      "MM/dd/yyyy",
      "yyyy-MM-dd",
      "dd-MM-yyyy",
      "d MMM yyyy",
      "MMM d, yyyy",
      "d/M/yyyy",
      "d-MM-yyyy",
    ];

    for (var format in knownFormats) {
      try {
        final date = DateFormat(format).parseStrict(dateString);
        return date;
      } catch (_) {
        // Coba format selanjutnya
      }
    }

    return null; // Tidak ada format cocok
  }
}

String formatNumber(num number) {
  final formatter = NumberFormat.decimalPattern('id');
  return formatter.format(number);
}
