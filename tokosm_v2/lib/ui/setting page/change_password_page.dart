import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tokosm_v2/cubit/auth_cubit.dart';
import 'package:tokosm_v2/shared/themes.dart';
import 'package:tokosm_v2/shared/utils.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  TextEditingController oldPasswordController = TextEditingController(text: "");
  TextEditingController newPasswordController = TextEditingController(text: "");
  TextEditingController confirmationNewPasswordController =
      TextEditingController(text: "");

  FocusNode oldPasswordFocusNode = FocusNode();
  FocusNode newPasswordFocusNode = FocusNode();
  FocusNode confirmationNewPasswordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    oldPasswordController.addListener(() {
      setState(() {}); // Rebuild to reflect focus change
    });

    newPasswordController.addListener(() {
      setState(() {});
    });

    confirmationNewPasswordController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
    oldPasswordFocusNode.dispose();

    newPasswordController.dispose();
    newPasswordFocusNode.dispose();

    confirmationNewPasswordController.dispose();
    confirmationNewPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is PChangeLoading) {
          Utils().loadingDialog(context: context);
        }

        if (state is PChangeSuccess) {
          Utils().scaffoldMessenger(context, "Pasword Anda berhasil diubah");
          Navigator.pop(context);
          Navigator.pop(context);
        }

        if (state is PChangeFailure) {
          Utils().scaffoldMessenger(context, state.error);
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
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
                        'Ubah Password',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: bold,
                        ),
                      ),
                    ],
                  ),
                  
                  Expanded(
                    child: ListView(
                      children: [
                        Container(
                          height: 64,
                          width: 64,
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Text(
                            context
                                    .read<AuthCubit>()
                                    .state
                                    .loginModel
                                    .data
                                    ?.namaPelanggan ??
                                "",
                            style: TextStyle(
                              fontWeight: bold,
                            ),
                          ),
                        ),
                        _ChangePasswordPageExtension().formItem(
                          title: "Password Lama",
                          controller: oldPasswordController,
                          focus: oldPasswordFocusNode,
                          placeholder: 'password lama',
                          icon: SolarIconsOutline.lockPassword,
                          isPassword: true,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        _ChangePasswordPageExtension().formItem(
                          title: "Password Baru",
                          controller: newPasswordController,
                          focus: newPasswordFocusNode,
                          placeholder: 'password Baru',
                          icon: SolarIconsOutline.lockPassword,
                          isPassword: true,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        _ChangePasswordPageExtension().formItem(
                          title: "Konfirmasi Password Baru",
                          controller: confirmationNewPasswordController,
                          focus: confirmationNewPasswordFocusNode,
                          placeholder: 'Konfirmasi Password Baru',
                          icon: SolarIconsOutline.lockPassword,
                          isPassword: true,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (newPasswordController.text ==
                                    confirmationNewPasswordController.text &&
                                newPasswordController.text != "") {
                              context.read<AuthCubit>().postChangePassword(
                                    token: context
                                            .read<AuthCubit>()
                                            .state
                                            .loginModel
                                            .token ??
                                        "",
                                    oldPassword: oldPasswordController.text,
                                    newPassword: newPasswordController.text,
                                  );
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: colorSuccess,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Text(
                              "Simpan",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ChangePasswordPageExtension {
  Widget formItem({
    required String title,
    required TextEditingController controller,
    required FocusNode focus,
    required String placeholder,
    required IconData icon,
    bool isPassword = false,
  }) {
    bool isPasswordVisible = true;
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
                  color: focus.hasFocus ? Colors.black : Colors.grey,
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
