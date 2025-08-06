import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:tokosm_v2/cubit/auth_cubit.dart';
import 'package:tokosm_v2/cubit/cabang_cubit.dart';
import 'package:tokosm_v2/cubit/setting_cubit.dart';
import 'package:tokosm_v2/shared/themes.dart';
import 'package:tokosm_v2/shared/utils.dart';

final GlobalKey _genderFieldKey = GlobalKey(); // Buat di luar widget tree

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
    var userData = context.read<AuthCubit>().state.loginModel.data;
    tglLahirController.text = userData?.tglLahirPelanggan ?? "";
    genderController.text = userData?.jenisKelaminPelanggan ?? "";
    emailController.text = userData?.emailPelanggan ?? "";
    addressController.text = userData?.alamatPelanggan ?? "";
    cityProvinceController.text = userData?.provinsi ?? "";
    districtSubDistrictController.text = userData?.kabkota ?? "";
    phoneNumberController.text =
        (userData?.telpPelanggan ?? "").replaceAll("+62", "");

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
                        child: _EditProfilePageExtension().formItem(
                            title: "Tanggal Lahir",
                            controller: tglLahirController,
                            focus: tglLahirFocusNode,
                            placeholder: 'dd/mm/yyyy',
                            icon: SolarIconsOutline.calendar,
                            enableForm: false,
                            onItemTapped: () {
                              var datetime = DateTime.now();
                              Utils().customAlertDialog(
                                context: context,
                                title: 'Tanggal Lahir',
                                content: SizedBox(
                                  height: 400,
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: SfDateRangePicker(
                                    todayHighlightColor: colorSuccess,
                                    selectionColor: colorSuccess,
                                    startRangeSelectionColor: colorSuccess,
                                    endRangeSelectionColor: colorSuccess,
                                    rangeSelectionColor: colorSuccess,
                                    selectionMode:
                                        DateRangePickerSelectionMode.single,
                                    onSelectionChanged: (args) {
                                      datetime = args.value;
                                    },
                                    initialSelectedDate:
                                        tglLahirController.text == ""
                                            ? null
                                            : Utils().normalizeToDateTime(
                                                tglLahirController.text,
                                              ),
                                    maxDate: DateTime.now(),
                                  ),
                                ),
                                confirmationFunction: () {
                                  Navigator.pop(context);
                                  String formatted =
                                      DateFormat('yyyy-MM-dd').format(datetime);
                                  tglLahirController.text =
                                      formatted.toString();
                                },
                              );
                            }),
                      ),
                      Expanded(
                        child: _EditProfilePageExtension().formItem(
                          title: "Jenis Kelamin",
                          controller: genderController,
                          focus: genderFocusNode,
                          placeholder: 'Jenis Kelamin',
                          icon: null,
                          rightIcon: SolarIconsBold.altArrowDown,
                          enableForm: false,
                          onItemTapped: () {
                            _EditProfilePageExtension()._showDropdownMenu(
                                context, genderController, _genderFieldKey);
                          },
                          key: _genderFieldKey,
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
                  _EditProfilePageExtension().formItem(
                    title: "Provinsi, Kota",
                    controller: cityProvinceController,
                    focus: cityProvinceFocusNode,
                    placeholder: 'Provinsi, Kota',
                    icon: null,
                    rightIcon: SolarIconsBold.altArrowDown,
                    enableForm: false,
                    onItemTapped: () {
                      String selectedCity = cityProvinceController.text;
                      Utils().loadingDialog(context: context);
                      context
                          .read<AreaSettingCubit>()
                          .getAreaData(
                              token: context
                                      .read<AuthCubit>()
                                      .state
                                      .loginModel
                                      .token ??
                                  "")
                          .then((_) {
                        Navigator.pop(context);
                        Utils().customAlertDialog(
                            context: context,
                            confirmationFunction: () {
                              Navigator.pop(context);
                              districtSubDistrictController.text = "";
                              cityProvinceController.text = selectedCity;
                            },
                            content: SizedBox(
                              height: 300,
                              width: MediaQuery.sizeOf(context).width * 0.8,
                              child: StatefulBuilder(
                                builder: (context, setState) {
                                  return ListView(
                                    children: [
                                      for (var i = 0;
                                          i <
                                              (context
                                                          .read<
                                                              AreaSettingCubit>()
                                                          .state
                                                          .areaModel
                                                          ?.data ??
                                                      [])
                                                  .length;
                                          i++) ...{
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedCity =
                                                  "${context.read<AreaSettingCubit>().state.areaModel?.data?[i].provinsi ?? ""}, ${context.read<AreaSettingCubit>().state.areaModel?.data?[i].kota ?? ""}";
                                            });
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                              bottom: 10,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 5,
                                              horizontal: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              color: selectedCity ==
                                                      "${context.read<AreaSettingCubit>().state.areaModel?.data?[i].provinsi ?? ""}, ${context.read<AreaSettingCubit>().state.areaModel?.data?[i].kota ?? ""}"
                                                  ? colorSuccess
                                                  : greyBase300,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              "${context.read<AreaSettingCubit>().state.areaModel?.data?[i].provinsi ?? ""}, ${context.read<AreaSettingCubit>().state.areaModel?.data?[i].kota ?? ""}",
                                              style: TextStyle(
                                                color: selectedCity ==
                                                        "${context.read<AreaSettingCubit>().state.areaModel?.data?[i].provinsi ?? ""}, ${context.read<AreaSettingCubit>().state.areaModel?.data?[i].kota ?? ""}"
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      }
                                    ],
                                  );
                                },
                              ),
                            ),
                            title: "Pilih Provinsi, Kota");
                      });
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _EditProfilePageExtension().formItem(
                    title: "Kecamatan, Kelurahan",
                    controller: districtSubDistrictController,
                    focus: districtSubDistrictFocusNode,
                    placeholder: 'Kecamatan, Kelurahan',
                    icon: null,
                    rightIcon: SolarIconsBold.altArrowDown,
                    enableForm: false,
                    onItemTapped: () {
                      String selectedDistrict =
                          districtSubDistrictController.text;
                      Utils().loadingDialog(context: context);
                      context
                          .read<AreaSettingCubit>()
                          .getAreaData(
                            token: context
                                    .read<AuthCubit>()
                                    .state
                                    .loginModel
                                    .token ??
                                "",
                            kabKota:
                                cityProvinceController.text.split(", ").last,
                          )
                          .then((_) {
                        Navigator.pop(context);
                        Utils().customAlertDialog(
                            context: context,
                            confirmationFunction: () {
                              Navigator.pop(context);
                              districtSubDistrictController.text =
                                  selectedDistrict;
                            },
                            content: SizedBox(
                              height: 300,
                              width: MediaQuery.sizeOf(context).width * 0.8,
                              child: StatefulBuilder(
                                builder: (context, setState) {
                                  return ListView(
                                    children: [
                                      for (var i = 0;
                                          i <
                                              (context
                                                          .read<
                                                              AreaSettingCubit>()
                                                          .state
                                                          .areaModel
                                                          ?.data ??
                                                      [])
                                                  .length;
                                          i++) ...{
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedDistrict =
                                                  "${context.read<AreaSettingCubit>().state.areaModel?.data?[i].kecamatan ?? ""}, ${context.read<AreaSettingCubit>().state.areaModel?.data?[i].kelurahan ?? ""}";
                                            });
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                              bottom: 10,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 5,
                                              horizontal: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              color: selectedDistrict ==
                                                      "${context.read<AreaSettingCubit>().state.areaModel?.data?[i].kecamatan ?? ""}, ${context.read<AreaSettingCubit>().state.areaModel?.data?[i].kelurahan ?? ""}"
                                                  ? colorSuccess
                                                  : greyBase300,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              "${context.read<AreaSettingCubit>().state.areaModel?.data?[i].kecamatan ?? ""}, ${context.read<AreaSettingCubit>().state.areaModel?.data?[i].kelurahan ?? ""}",
                                              style: TextStyle(
                                                color: selectedDistrict ==
                                                        "${context.read<AreaSettingCubit>().state.areaModel?.data?[i].kecamatan ?? ""}, ${context.read<AreaSettingCubit>().state.areaModel?.data?[i].kelurahan ?? ""}"
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      }
                                    ],
                                  );
                                },
                              ),
                            ),
                            title: "Pilih Provinsi, Kota");
                      });
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                context
                    .read<AuthCubit>()
                    .updateProfile(
                      token: context.read<AuthCubit>().state.loginModel.token ??
                          "",
                      cabangID:
                          "${context.read<CabangCubit>().state.selectedCabangData.id}",
                      username: context
                              .read<AuthCubit>()
                              .state
                              .loginModel
                              .data
                              ?.username ??
                          "",
                      email: emailController.text,
                      phoneNumber: phoneNumberController.text == ""
                          ? ""
                          : "+62${phoneNumberController.text}",
                      address: addressController.text,
                      area:
                          "${cityProvinceController.text}, ${districtSubDistrictController.text}",
                      birthDate: tglLahirController.text,
                      gender: genderController.text,
                    )
                    .then((_) {
                  if (context.read<AuthCubit>().state is AuthSuccess) {
                    Navigator.pop(context);
                  } else {
                    Utils().scaffoldMessenger(
                      context,
                      (context.read<AuthCubit>().state as AuthFailure).error,
                    );
                  }
                });
              },
              child: Container(
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
    Function? onItemTapped,
    Key? key,
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
            GestureDetector(
              child: Container(
                key: key,
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
                          readOnly: !enableForm,
                          onTap: () {
                            if (onItemTapped != null) {
                              onItemTapped();
                            }
                          },
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
            ),
          ],
        );
      },
    );
  }

// Dropdown laki laki perempuan
  void _showDropdownMenu(BuildContext context, TextEditingController controller,
      GlobalKey key) async {
    final RenderBox renderBox =
        key.currentContext!.findRenderObject() as RenderBox;
    final Offset position = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    final String? result = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + size.height,
        position.dx + size.width,
        position.dy,
      ),
      items: ['Laki-laki', 'Perempuan'].map((String value) {
        return PopupMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );

    if (result != null) {
      controller.text = result;
    }
  }
}
