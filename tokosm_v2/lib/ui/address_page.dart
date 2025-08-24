import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tokosm_v2/cubit/address_cubit.dart';
import 'package:tokosm_v2/model/address_model.dart';
import 'package:tokosm_v2/shared/themes.dart';

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
                          );
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
                          _AddressPageExtension().addressItemView(
                            context,
                            context
                                .read<AddressCubit>()
                                .state
                                .addressModel
                                ?.data?[index],
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
                    ));
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
                          controller: addressNameTextController,
                          focus: FocusNode(),
                          placeholder: "Nama Penerima",
                          icon: null,
                        ),
                        _AddressFormPageExtension().formItem(
                          title: "Nomor Hp",
                          controller: addressNameTextController,
                          focus: FocusNode(),
                          placeholder: "Nomor Hp",
                          icon: null,
                          textIcon: "+62",
                        ),
                        _AddressFormPageExtension().formItem(
                          title: "Alamat Lengkap",
                          controller: addressNameTextController,
                          focus: FocusNode(),
                          placeholder: "Alamat Lengkap",
                          icon: null,
                          descriptionForm: true,
                        ),
                        _AddressFormPageExtension().formItem(
                          title: "Provinsi, Kota",
                          controller: addressNameTextController,
                          focus: FocusNode(),
                          placeholder: "Provinsi, Kota",
                          rightIcon: SolarIconsBold.altArrowDown,
                          icon: null,
                        ),
                        _AddressFormPageExtension().formItem(
                          title: "Kecamatan, Kelurahan",
                          controller: addressNameTextController,
                          focus: FocusNode(),
                          placeholder: "Kecamatan, Kelurahan",
                          rightIcon: SolarIconsBold.altArrowDown,
                          icon: null,
                        ),
                        _AddressFormPageExtension().formItem(
                          title: "Catatan",
                          controller: addressNameTextController,
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
                              color: colorError,
                            ),
                          ),
                        ),
                        child: Text(
                          "Hapus",
                          style: TextStyle(
                            color: colorError,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
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
