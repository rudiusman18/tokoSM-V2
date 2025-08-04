import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tokosm_v2/cubit/auth_cubit.dart';
import 'package:tokosm_v2/cubit/page_cubit.dart';
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
                  Row(
                    children: [
                      Text(
                        context
                                .read<AuthCubit>()
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
                      const Text(
                        " | ",
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        context
                                .read<AuthCubit>()
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
                    ],
                  ),
                  Row(
                    spacing: 5,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: colorWarning,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          "Saldo: Rp ${context.read<AuthCubit>().state.loginModel.data?.nominal ?? 0}",
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
                          color: colorSuccess,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          "Poin: ${context.read<AuthCubit>().state.loginModel.data?.nominal ?? 0}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: bold,
                          ),
                        ),
                      ),
                    ],
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

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is PChangeLoading) {
          Utils().loadingDialog(context: context);
        }
        if (state is PChangeSuccess) {
          Navigator.pop(context);
          Utils().scaffoldMessenger(context, "Password berhasil diubah");
        }
        if (state is PChangeFailure) {
          Navigator.pop(context);
          Utils().scaffoldMessenger(context, state.error);
        }
      },
      child: Scaffold(
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
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, 'setting-page/change-password');
                          },
                          child: _SettingPageExtension().settingItem(
                            icon: SolarIconsOutline.lockPassword,
                            title: "Ubah Kata Sandi",
                          ),
                        ),
                        _SettingPageExtension().settingItem(
                          icon: SolarIconsOutline.delivery,
                          title: "Daftar Alamat",
                        ),
                        GestureDetector(
                          onTap: () {
                            context.read<PageCubit>().setPage(3);
                            Navigator.pop(context);
                          },
                          child: _SettingPageExtension().settingItem(
                            icon: SolarIconsOutline.billList,
                            title: "Daftar Transaksi",
                          ),
                        ),
                        _SettingPageExtension().settingItem(
                          icon: Icons.star_border,
                          title: "Ulasan",
                        ),
                        GestureDetector(
                          onTap: () {
                            context.read<PageCubit>().setPage(2);
                            Navigator.pop(context);
                          },
                          child: _SettingPageExtension().settingItem(
                            icon: SolarIconsOutline.heart,
                            title: "Favorit",
                          ),
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
                    context.read<AuthCubit>().logout();
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
