import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tokosm_v2/cubit/login_cubit.dart';
import 'package:tokosm_v2/shared/themes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    initLogin();

    super.initState();
  }

  void initLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final userCredential = prefs.getString('user credential');
    context.read<LoginCubit>().postLogin(
        email: (userCredential ?? "").split("||").first,
        password: (userCredential ?? "").split("||").last);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            'login',
            (route) => false,
          );
        }

        if (state is LoginSuccess) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            'main-page',
            (route) => false,
          );
        }
      },
      child: Scaffold(
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
      ),
    );
  }
}
