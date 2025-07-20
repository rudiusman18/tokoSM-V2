import 'package:flutter/material.dart';
import 'package:tokosm_v2/shared/themes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    Future.delayed(
      Duration(seconds: 3),
      () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          'login',
          (route) => false,
        );
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/logo-tokosm.png",
              width: 100,
              height: 100,
            ),
            SizedBox(
              width: 20,
              height: 20,
              child: FittedBox(
                fit: BoxFit.cover,
                child: CircularProgressIndicator(
                  color: colorSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
