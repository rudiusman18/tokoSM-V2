import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tokosm_v2/cubit/login_cubit.dart';
import 'package:tokosm_v2/shared/themes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController(text: "");
  FocusNode emailFocusNode = FocusNode();

  TextEditingController passwordController = TextEditingController(text: "");
  FocusNode passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    emailFocusNode.addListener(() {
      setState(() {}); // Rebuild to reflect focus change
    });

    passwordFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    emailFocusNode.dispose();

    passwordController.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        padding: const EdgeInsets.only(
          top: 50,
        ),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Masuk",
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Image.asset(
                  'assets/logo-tokosm.png',
                  width: 48,
                  height: 48,
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            _LoginPageExtension().loginItem(
              title: "Email",
              controller: emailController,
              focus: emailFocusNode,
              placeholder: 'Email',
              icon: SolarIconsOutline.letter,
            ),
            const SizedBox(
              height: 10,
            ),
            _LoginPageExtension().loginItem(
              title: "Password",
              controller: passwordController,
              focus: passwordFocusNode,
              placeholder: 'Password',
              icon: SolarIconsOutline.lock,
              isPassword: true,
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                print("Login ditekan");
                context.read<LoginCubit>().postLogin(
                    email: emailController.text,
                    password: passwordController.text);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: colorSuccess,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: RichText(
                text: TextSpan(
                  text: "Belum punya akun? ",
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: "Daftar Sekarang",
                      style: TextStyle(
                        fontWeight: bold,
                        color: colorSuccess,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginPageExtension {
  bool isPasswordVisible = true;

  Widget loginItem({
    required String title,
    required TextEditingController controller,
    required FocusNode focus,
    required String placeholder,
    required IconData icon,
    bool isPassword = false,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          spacing: 5,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: bold,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: focus.hasFocus ? Colors.black : greyBase300,
                  width: 1,
                ),
              ),
              child: Row(
                spacing: 10,
                children: [
                  Icon(
                    icon,
                    size: 14,
                  ),
                  Expanded(
                    child: TextFormField(
                      autocorrect: false,
                      controller: controller,
                      cursorColor: Colors.black,
                      obscureText:
                          isPassword && isPasswordVisible ? true : false,
                      focusNode: focus,
                      decoration: InputDecoration.collapsed(
                        hintText: placeholder,
                        focusColor: Colors.black,
                        hintStyle: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  if (isPassword) ...{
                    GestureDetector(
                      onTap: () {
                        setState(
                          () {
                            isPasswordVisible = !isPasswordVisible;
                          },
                        );
                      },
                      child: Icon(
                        isPasswordVisible
                            ? SolarIconsOutline.eye
                            : SolarIconsOutline.eyeClosed,
                        size: 20,
                      ),
                    ),
                  },
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
