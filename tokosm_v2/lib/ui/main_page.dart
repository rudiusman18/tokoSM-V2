import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tokosm_v2/cubit/page_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PageCubit, int>(
      builder: (context, state) {
        return Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  SolarIconsOutline.homeAngle,
                ),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(SolarIconsOutline.widget),
                label: "Kategori",
              ),
              BottomNavigationBarItem(
                icon: Icon(SolarIconsOutline.heartAngle),
                label: "Wishlist",
              ),
              BottomNavigationBarItem(
                icon: Icon(SolarIconsOutline.server),
                label: "Transaksi",
              ),
            ],
          ),
          body: SafeArea(
            child: Text(
              'Halo',
            ),
          ),
        );
      },
    );
  }
}
