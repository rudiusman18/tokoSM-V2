import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tokosm_v2/cubit/page_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokosm_v2/shared/themes.dart';
import 'package:tokosm_v2/ui/main%20page/category_page.dart';
import 'package:tokosm_v2/ui/main%20page/home_page.dart';
import 'package:tokosm_v2/ui/main%20page/transaction_page.dart';
import 'package:tokosm_v2/ui/main%20page/wishlist_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    Widget body() {
      int index = context.read<PageCubit>().state;
      switch (index) {
        case 0:
          return const HomePage();
        case 1:
          return const CategoryPage();
        case 2:
          return const WishlistPage();
        case 3:
          return const TransactionPage();
        default:
          return const HomePage();
      }
    }

    return BlocBuilder<PageCubit, int>(
      builder: (context, state) {
        return Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            onTap: (int index) {
              context.read<PageCubit>().setPage(index);
            },
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 10,
            unselectedFontSize: 10,
            currentIndex: context.read<PageCubit>().state,
            selectedItemColor: colorSuccess,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  SolarIconsOutline.homeAngle,
                ),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  SolarIconsOutline.widget,
                ),
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
          body: body(),
        );
      },
    );
  }
}
