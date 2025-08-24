import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tokosm_v2/cubit/address_cubit.dart';
import 'package:tokosm_v2/cubit/auth_cubit.dart';
import 'package:tokosm_v2/cubit/setting_cubit.dart';
import 'package:tokosm_v2/model/address_model.dart';
import 'package:tokosm_v2/shared/themes.dart';
import 'package:tokosm_v2/shared/utils.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddressCubit, AddressState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
              child: Container(
            margin: const EdgeInsets.only(
              top: 10,
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Row(
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
                      Expanded(
                        child: Text(
                          'Pilih Alamat',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: bold,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeft,
                              childCurrent: context.currentRoute,
                              child: AddressFormPage(),
                            ),
                          ).then((_) async {
                            Utils().loadingDialog(context: context);
                            await context.read<AddressCubit>().getAddress(
                                token: context
                                        .read<AuthCubit>()
                                        .state
                                        .loginModel
                                        .token ??
                                    "");
                            if (context.read<AddressCubit>().state
                                is AddressSuccess) {
                              Navigator.pop(context);
                            } else if (context.read<AddressCubit>().state
                                is AddressFailure) {
                              Navigator.pop(context);
                              Utils().scaffoldMessenger(
                                  context,
                                  (context.read<AddressCubit>().state
                                              as AddressFailure)
                                          .error ??
                                      "");
                            }
                          });
                        },
                        child: const Icon(
                          SolarIconsOutline.addSquare,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        for (var index = 0;
                            index <
                                (context
                                            .read<AddressCubit>()
                                            .state
                                            .addressModel
                                            ?.data ??
                                        [])
                                    .length;
                            index++) ...{
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              context.read<AddressCubit>().selectAddress(
                                  addressData: (context
                                          .read<AddressCubit>()
                                          .state
                                          .addressModel
                                          ?.data ??
                                      [])[index]);
                            },
                            child: _AddressPageExtension().addressItemView(
                              context,
                              context
                                  .read<AddressCubit>()
                                  .state
                                  .addressModel
                                  ?.data?[index],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        }
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
        );
      },
    );
  }
}

class _AddressPageExtension {
  Widget addressItemView(
    BuildContext context,
    AddressData? addressData,
  ) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          const Icon(
            SolarIconsOutline.mapPoint,
            size: 24,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 5,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "${addressData?.namaAlamat}",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: bold,
                            ),
                          ),
                          TextSpan(
                            text: " | ${addressData?.telpPenerima}",
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    if (addressData?.isUtama == 1)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: colorSuccess,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 2,
                          children: [
                            Icon(
                              SolarIconsBold.checkCircle,
                              size: 12,
                              color: Colors.white,
                            ),
                            Text(
                              "Utama",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                  ],
                ),
                Text(
                  "${addressData?.alamatLengkap ?? ""}, ${addressData?.kelurahan ?? ""}, ${addressData?.kecamatan ?? ""}, ${addressData?.kabkota ?? ""}, ${addressData?.provinsi ?? ""}\n${addressData?.kodepos ?? ""}",
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      childCurrent: context.currentRoute,
                      child: AddressFormPage(
                        addressData: addressData,
                      ),
                    )).then((_) async {
                  Utils().loadingDialog(context: context);
                  await context.read<AddressCubit>().getAddress(
                      token: context.read<AuthCubit>().state.loginModel.token ??
                          "");
                  if (context.read<AddressCubit>().state is AddressSuccess) {
                    Navigator.pop(context);
                  } else if (context.read<AddressCubit>().state
                      is AddressFailure) {
                    Navigator.pop(context);
                    Utils().scaffoldMessenger(
                        context,
                        (context.read<AddressCubit>().state as AddressFailure)
                                .error ??
                            "");
                  }
                });
                ;
              },
              child: const Icon(
                SolarIconsOutline.pen2,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// NOTE: Untuk Form buat dan edit address
class AddressFormPage extends StatefulWidget {
  AddressData? addressData;
  AddressFormPage({super.key, this.addressData});

  @override
  State<AddressFormPage> createState() => AddressFormPageState();
}

class AddressFormPageState extends State<AddressFormPage> {
  TextEditingController addressNameTextController =
      TextEditingController(text: "");
  TextEditingController receiverNameTextController =
      TextEditingController(text: "");
  TextEditingController phoneNumberTextController =
      TextEditingController(text: "");
  TextEditingController addressTextController = TextEditingController(text: "");
  TextEditingController cityProvinceController =
      TextEditingController(text: "");
  TextEditingController districtSubDistrictController =
      TextEditingController(text: "");
  TextEditingController noteTextController = TextEditingController(text: "");
  TextEditingController pinpointTextController =
      TextEditingController(text: "");

  @override
  void initState() {
    initAddressData();
    super.initState();
  }

  initAddressData() {
    addressNameTextController.text = widget.addressData?.namaAlamat ?? "";
    receiverNameTextController.text = widget.addressData?.namaPenerima ?? "";
    phoneNumberTextController.text = (widget.addressData?.telpPenerima ?? "")
        .replaceFirst(RegExp(r'^0'), '');
    cityProvinceController.text = widget.addressData?.kabkota ?? "";
    districtSubDistrictController
        .text = (widget.addressData?.kecamatan ?? "") == "" &&
            (widget.addressData?.kelurahan ?? "") == ""
        ? ""
        : "${widget.addressData?.kecamatan ?? ""}, ${widget.addressData?.kelurahan ?? ""}";
    noteTextController.text = widget.addressData?.catatan ?? "";
    pinpointTextController.text =
        "${widget.addressData?.lat ?? ""}, ${widget.addressData?.lng ?? ""}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(
            top: 10,
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Row(
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
                    Expanded(
                      child: Text(
                        widget.addressData == null
                            ? 'Tambah Alamat'
                            : 'Edit Alamat',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: Column(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _AddressFormPageExtension().formItem(
                          title: "Nama Alamat",
                          controller: addressNameTextController,
                          focus: FocusNode(),
                          placeholder: "Nama Alamat",
                          icon: null,
                        ),
                        _AddressFormPageExtension().formItem(
                          title: "Nama Penerima",
                          controller: receiverNameTextController,
                          focus: FocusNode(),
                          placeholder: "Nama Penerima",
                          icon: null,
                        ),
                        _AddressFormPageExtension().formItem(
                          title: "Nomor Hp",
                          controller: phoneNumberTextController,
                          focus: FocusNode(),
                          placeholder: "Nomor Hp",
                          icon: null,
                          textIcon: "+62",
                        ),
                        _AddressFormPageExtension().formItem(
                          title: "Alamat Lengkap",
                          controller: addressTextController,
                          focus: FocusNode(),
                          placeholder: "Alamat Lengkap",
                          icon: null,
                          descriptionForm: true,
                        ),
                        _AddressFormPageExtension().formItem(
                          title: "Provinsi, Kota",
                          controller: cityProvinceController,
                          focus: FocusNode(),
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
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.8,
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
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    vertical: 5,
                                                    horizontal: 10,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: selectedCity ==
                                                            "${context.read<AreaSettingCubit>().state.areaModel?.data?[i].provinsi ?? ""}, ${context.read<AreaSettingCubit>().state.areaModel?.data?[i].kota ?? ""}"
                                                        ? colorSuccess
                                                        : greyBase300,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
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
                        _AddressFormPageExtension().formItem(
                          title: "Kecamatan, Kelurahan",
                          controller: districtSubDistrictController,
                          focus: FocusNode(),
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
                                  kabKota: cityProvinceController.text
                                      .split(", ")
                                      .last,
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
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.8,
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
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    vertical: 5,
                                                    horizontal: 10,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: selectedDistrict ==
                                                            "${context.read<AreaSettingCubit>().state.areaModel?.data?[i].kecamatan ?? ""}, ${context.read<AreaSettingCubit>().state.areaModel?.data?[i].kelurahan ?? ""}"
                                                        ? colorSuccess
                                                        : greyBase300,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
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
                                  title: "Pilih Kecamatan, Kelurahan");
                            });
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        _AddressFormPageExtension().formItem(
                          title: "Catatan",
                          controller: noteTextController,
                          focus: FocusNode(),
                          placeholder: "Catatan",
                          icon: null,
                        ),
                        // NOTE: Lokasi
                        Text(
                          "Lokasi",
                          style: TextStyle(
                            fontWeight: bold,
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadiusGeometry.circular(10))),
                            child: const Text(
                              "Pinpoint",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                child: Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(
                              10,
                            ),
                            side: BorderSide(
                              color: widget.addressData == null
                                  ? colorSuccess
                                  : colorError,
                            ),
                          ),
                        ),
                        child: Text(
                          widget.addressData == null ? "Batal" : "Hapus",
                          style: TextStyle(
                            color: widget.addressData == null
                                ? colorSuccess
                                : colorError,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (widget.addressData == null) {
                            Utils().loadingDialog(context: context);
                            await context.read<AddressCubit>().postAddress(
                                  token: context
                                          .read<AuthCubit>()
                                          .state
                                          .loginModel
                                          .token ??
                                      "",
                                  addressName: addressNameTextController.text,
                                  receiverName: receiverNameTextController.text,
                                  phoneNumber: phoneNumberTextController.text ==
                                          ""
                                      ? ""
                                      : "+62${phoneNumberTextController.text}",
                                  address: addressTextController.text,
                                  province: cityProvinceController.text
                                      .split(", ")
                                      .first,
                                  city: cityProvinceController.text
                                      .split(", ")
                                      .last,
                                  district: districtSubDistrictController.text
                                      .split(", ")
                                      .first,
                                  subdistrict: districtSubDistrictController
                                      .text
                                      .split(", ")
                                      .last,
                                  postCode: "0000",
                                  note: noteTextController.text,
                                  lat: "0",
                                  lng: "0",
                                  // lat: pinpointTextController.text
                                  //     .split(", ")
                                  //     .first,
                                  // lng: pinpointTextController.text
                                  //     .split(", ")
                                  //     .last,
                                );
                            if (context.read<AddressCubit>().state
                                is AddressSuccess) {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            } else if (context.read<AddressCubit>().state
                                is AddressFailure) {
                              Navigator.pop(context);
                              Utils().scaffoldMessenger(
                                  context,
                                  (context.read<AddressCubit>().state
                                              as AddressFailure)
                                          .error ??
                                      "");
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorSuccess,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(
                              10,
                            ),
                          ),
                        ),
                        child: const Text(
                          "Simpan",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _AddressFormPageExtension {
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
}
