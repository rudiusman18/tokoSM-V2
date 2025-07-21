import 'package:flutter/material.dart';

String baseURL = "https://apitokosm.share.zrok.io/api/v1";

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
}
