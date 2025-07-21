import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tokosm_v2/cubit/login_cubit.dart';
import 'package:tokosm_v2/shared/themes.dart';
import 'package:tokosm_v2/shared/utils.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    Widget header() {
      return Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
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
              width: 10,
            ),
            //NOTE: Informasi pengguna
            Expanded(
              child: Column(
                spacing: 5,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context
                            .read<LoginCubit>()
                            .state
                            .loginModel
                            .data
                            ?.namaPelanggan ??
                        "",
                    style: TextStyle(
                      fontWeight: bold,
                    ),
                  ),
                  Text(
                    context
                            .read<LoginCubit>()
                            .state
                            .loginModel
                            .data
                            ?.emailPelanggan ??
                        "",
                    style: const TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    context
                            .read<LoginCubit>()
                            .state
                            .loginModel
                            .data
                            ?.telpPelanggan ??
                        "",
                    style: const TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 12,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: colorWarning,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      "Saldo: Rp ${context.read<LoginCubit>().state.loginModel.data?.nominal ?? 0}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: colorWarning,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      "Poin: ${context.read<LoginCubit>().state.loginModel.data?.nominal ?? 0}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              SolarIconsOutline.pen2,
              size: 20,
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pengaturan',
          style: TextStyle(
            fontSize: 14,
            fontWeight: bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                header(),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Container(
                    height: 5,
                    color: greyBase300,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Column(
                    spacing: 10,
                    children: [
                      _SettingPageExtension().settingItem(
                        icon: SolarIconsOutline.lockPassword,
                        title: "Ubah Kata Sandi",
                      ),
                      _SettingPageExtension().settingItem(
                        icon: SolarIconsOutline.delivery,
                        title: "Daftar Alamat",
                      ),
                      _SettingPageExtension().settingItem(
                        icon: SolarIconsOutline.billList,
                        title: "Daftar Transaksi",
                      ),
                      _SettingPageExtension().settingItem(
                        icon: Icons.star_border,
                        title: "Ulasan",
                      ),
                      _SettingPageExtension().settingItem(
                        icon: SolarIconsOutline.heart,
                        title: "Favorit",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Utils().alertDialog(
                context: context,
                function: () {
                  Navigator.pop(context);
                  context.read<LoginCubit>().logout();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    'login',
                    (route) => false,
                  );
                },
                title: "Logout",
                message: "Anda yakin untuk melanjutkan logout?",
              );
            },
            child: Container(
              margin: const EdgeInsets.only(
                bottom: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    SolarIconsOutline.power,
                    size: 30,
                    color: colorSuccess,
                  ),
                  Text(
                    "Logout",
                    style: TextStyle(
                      fontSize: 14,
                      color: colorSuccess,
                      fontWeight: bold,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _SettingPageExtension {
  Widget settingItem({
    required IconData icon,
    required String title,
  }) {
    return Column(
      children: [
        Row(
          spacing: 10,
          children: [
            Icon(
              icon,
              size: 24,
            ),
            Text(
              title,
            ),
            const Spacer(),
            const Icon(
              Icons.chevron_right,
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        const Divider(
          color: Colors.grey,
          height: 5,
        ),
      ],
    );
  }
}
