import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tokosm_v2/cubit/auth_cubit.dart';
import 'package:tokosm_v2/shared/themes.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController tglLahirController = TextEditingController(text: "");
  FocusNode tglLahirFocusNode = FocusNode();

  TextEditingController genderController = TextEditingController(text: "");
  FocusNode genderFocusNode = FocusNode();

  TextEditingController emailController = TextEditingController(text: "");
  FocusNode emailFocusNode = FocusNode();

  TextEditingController phoneNumberController = TextEditingController(text: "");
  FocusNode phoneNumberFocusNode = FocusNode();

  TextEditingController addressController = TextEditingController(text: "");
  FocusNode addressFocusNode = FocusNode();

  TextEditingController cityProvinceController =
      TextEditingController(text: "");
  FocusNode cityProvinceFocusNode = FocusNode();

  TextEditingController districtSubDistrictController =
      TextEditingController(text: "");
  FocusNode districtSubDistrictFocusNode = FocusNode();

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
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    spacing: 10,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            print("kalender ditekan");
                          },
                          child: _EditProfilePageExtension().formItem(
                            title: "Tanggal Lahir",
                            controller: tglLahirController,
                            focus: tglLahirFocusNode,
                            placeholder: 'dd/mm/yyyy',
                            icon: SolarIconsOutline.calendar,
                            enableForm: false,
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            print("gender ditekan");
                          },
                          child: _EditProfilePageExtension().formItem(
                            title: "Jenis Kelamin",
                            controller: genderController,
                            focus: genderFocusNode,
                            placeholder: 'Jenis Kelamin',
                            icon: null,
                            rightIcon: SolarIconsBold.altArrowDown,
                            enableForm: false,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _EditProfilePageExtension().formItem(
                    title: "Email",
                    controller: emailController,
                    focus: emailFocusNode,
                    placeholder: 'Email',
                    icon: null,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _EditProfilePageExtension().formItem(
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
                  _EditProfilePageExtension().formItem(
                    title: "Alamat",
                    controller: addressController,
                    focus: addressFocusNode,
                    placeholder: 'Alamat',
                    icon: null,
                    descriptionForm: true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      print("provinsi kota ditekan");
                    },
                    child: _EditProfilePageExtension().formItem(
                      title: "Provinsi, Kota",
                      controller: cityProvinceController,
                      focus: cityProvinceFocusNode,
                      placeholder: 'Provinsi, Kota',
                      icon: null,
                      rightIcon: SolarIconsBold.altArrowDown,
                      enableForm: false,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      print("Kecamatan kelurahan ditekan");
                    },
                    child: _EditProfilePageExtension().formItem(
                      title: "Kecamatan, Kelurahan",
                      controller: districtSubDistrictController,
                      focus: districtSubDistrictFocusNode,
                      placeholder: 'Kecamatan, Kelurahan',
                      icon: null,
                      rightIcon: SolarIconsBold.altArrowDown,
                      enableForm: false,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: colorSuccess,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "Simpan",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}

class _EditProfilePageExtension {
  Widget formItem({
    required String title,
    required TextEditingController controller,
    required FocusNode focus,
    required String placeholder,
    required IconData? icon,
    TextInputType keyboardType = TextInputType.text,
    bool descriptionForm = false,
    bool enableForm = true,
    String? textIcon,
    IconData? rightIcon,
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
                spacing: icon == null && textIcon == null ? 0 : 10,
                children: [
                  icon == null && textIcon != null
                      ? Text(
                          textIcon,
                          style: TextStyle(
                            fontWeight: bold,
                          ),
                        )
                      : Icon(
                          icon,
                          size: 14,
                        ),
                  Expanded(
                    child: SizedBox(
                      height: descriptionForm ? 100 : null,
                      child: TextFormField(
                        keyboardType: keyboardType,
                        enabled: enableForm,
                        maxLines: descriptionForm ? 5 : null,
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
                  if (rightIcon != null) ...{
                    Icon(
                      rightIcon,
                      size: 14,
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
