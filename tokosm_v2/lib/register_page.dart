import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tokosm_v2/cubit/auth_cubit.dart';
import 'package:tokosm_v2/shared/themes.dart';
import 'package:tokosm_v2/shared/utils.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController fullNameController = TextEditingController(text: "");
  FocusNode fullNameFocusNode = FocusNode();

  TextEditingController phoneNumberController = TextEditingController(text: "");
  FocusNode phoneNumberFocusNode = FocusNode();

  TextEditingController emailController = TextEditingController(text: "");
  FocusNode emailFocusNode = FocusNode();

  TextEditingController passwordController = TextEditingController(text: "");
  FocusNode passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    fullNameFocusNode.addListener(() {
      setState(() {}); // Rebuild to reflect focus change
    });

    phoneNumberFocusNode.addListener(() {
      setState(() {}); // Rebuild to reflect focus change
    });

    emailFocusNode.addListener(() {
      setState(() {}); // Rebuild to reflect focus change
    });

    passwordFocusNode.addListener(() {
      setState(() {});
    });

    // _getCurrentLocation();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    fullNameFocusNode.dispose();

    phoneNumberController.dispose();
    phoneNumberFocusNode.dispose();

    emailController.dispose();
    emailFocusNode.dispose();

    passwordController.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  Position? position;

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // cek apakah service lokasi aktif
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // buka setting GPS
      await Geolocator.openLocationSettings();
      return;
    }

    // cek permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      Utils().alertDialog(
        context: context,
        function: () async {
          Navigator.pop(context);
          // arahkan ke pengaturan aplikasi
          await Geolocator.openAppSettings();
        },
        cancelFunction: () {
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, 'login');
        },
        title: "Perhatian",
        message: "Silahkan berikan izin untuk lokasi untuk melanjutkan",
      );
      return;
    } else {
      // Utils().loadingDialog(context: context);
      // ambil lokasi sekarang
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      // Navigator.pop(context);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          print("auth failure jalan");
          Utils().scaffoldMessenger(context, state.error);
        }

        if (state is AuthSuccess) {
          Utils().scaffoldMessenger(context, "Pendaftaran berhasil");
          Navigator.pushReplacementNamed(context, 'login');
        }
      },
      builder: (context, state) {
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
                      "Daftar",
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
                _RegisterPageExtension().loginItem(
                  title: "Nama Lengkap",
                  controller: fullNameController,
                  focus: fullNameFocusNode,
                  placeholder: 'Nama Lengkap',
                  icon: SolarIconsBold.user,
                ),
                const SizedBox(
                  height: 10,
                ),
                _RegisterPageExtension().loginItem(
                  title: "Nomor Hp",
                  controller: phoneNumberController,
                  focus: phoneNumberFocusNode,
                  placeholder: 'Nomor Hp',
                  icon: null,
                  textIcon: "+62",
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(
                  height: 10,
                ),
                _RegisterPageExtension().loginItem(
                  title: "Email",
                  controller: emailController,
                  focus: emailFocusNode,
                  placeholder: 'Email',
                  icon: SolarIconsOutline.letter,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 10,
                ),
                _RegisterPageExtension().loginItem(
                  title: "Password",
                  controller: passwordController,
                  focus: passwordFocusNode,
                  placeholder: 'Password',
                  icon: SolarIconsOutline.lock,
                  isPassword: true,
                ),
                const SizedBox(
                  height: 22,
                ),
                GestureDetector(
                  onTap: () async {
                    if (context.read<AuthCubit>().state is! AuthLoading) {
                      if (fullNameController.text != "" &&
                          phoneNumberController.text != "" &&
                          emailController.text != "" &&
                          passwordController.text != "") {
                        // NOTE: Mendapatkan data lokasi
                        Utils().loadingDialog(context: context);
                        await _getCurrentLocation();
                        Navigator.pop(context);
                        context.read<AuthCubit>().postRegister(
                              fullName: fullNameController.text,
                              phoneNumber: "+62${phoneNumberController.text}",
                              email: emailController.text,
                              password: passwordController.text,
                              lat: position?.latitude,
                              lng: position?.longitude,
                            );
                      } else {
                        Utils().scaffoldMessenger(
                          context,
                          "Silahkan lengkapi form terlebih dahulu",
                        );
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: colorSuccess,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: (context.read<AuthCubit>().state is AuthLoading)
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            "Daftar",
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
                  height: 16,
                ),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: "Sudah punya akun? ",
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: "Login",
                          style: TextStyle(
                            fontWeight: bold,
                            color: colorSuccess,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushReplacementNamed(context, 'login');
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RegisterPageExtension {
  bool isPasswordVisible = true;

  Widget loginItem({
    required String title,
    required TextEditingController controller,
    required FocusNode focus,
    required String placeholder,
    required IconData? icon,
    TextInputType keyboardType = TextInputType.text,
    String textIcon = "",
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
                  textIcon != ""
                      ? Text(
                          textIcon,
                          style: TextStyle(
                            fontWeight: bold,
                            color: Colors.black,
                          ),
                        )
                      : Icon(
                          icon,
                          size: 14,
                        ),
                  Expanded(
                    child: TextFormField(
                      keyboardType: keyboardType,
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
