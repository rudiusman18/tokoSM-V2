import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tokosm_v2/cubit/category_cubit.dart';
import 'package:tokosm_v2/cubit/login_cubit.dart';
import 'package:tokosm_v2/cubit/page_cubit.dart';
import 'package:tokosm_v2/cubit/product_cubit.dart';
import 'package:tokosm_v2/cubit/transaction_cubit.dart';
import 'package:tokosm_v2/cubit/wishlist_cubit.dart';
import 'package:tokosm_v2/login_page.dart';
import 'package:tokosm_v2/splash_page.dart';
import 'package:tokosm_v2/ui/main_page.dart';
import 'package:tokosm_v2/ui/product%20page/detail_product_page.dart';
import 'package:tokosm_v2/ui/product_page.dart';
import 'package:tokosm_v2/ui/setting_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Portrait mode
    DeviceOrientation.portraitDown, // Upside-down portrait mode
  ]);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PageCubit(),
        ),
        BlocProvider(
          create: (context) => LoginCubit(),
        ),
        BlocProvider(
          create: (context) => WishlistCubit(),
        ),
        BlocProvider(
          create: (context) => TransactionTabFilterCubit(),
        ),
        BlocProvider(
          create: (context) => ProductCubit(),
        ),
        BlocProvider(
          create: (context) => CategoryCubit(),
        ),
      ],
      child: MaterialApp(
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case 'login':
              return PageTransition(
                type: PageTransitionType.rightToLeft,
                childCurrent: context.currentRoute,
                settings: settings,
                child: const LoginPage(),
              );

            case 'home-page/setting':
              return PageTransition(
                type: PageTransitionType.rightToLeft,
                childCurrent: context.currentRoute,
                settings: settings,
                child: const SettingPage(),
              );

            case 'product-page':
              return PageTransition(
                type: PageTransitionType.rightToLeft,
                childCurrent: context.currentRoute,
                settings: settings,
                child: const ProductPage(),
              );

            case 'product/detail-product':
              return PageTransition(
                type: PageTransitionType.rightToLeft,
                childCurrent: context.currentRoute,
                child: const DetailProductPage(),
                settings: settings,
              );

            case 'main-page':
              return PageTransition(
                type: PageTransitionType.rightToLeft,
                childCurrent: context.currentRoute,
                child: const MainPage(),
                settings: settings,
              );
          }
          return null;
        },
        theme: ThemeData(
          fontFamily: 'Urbanist',
          splashColor: Colors.transparent,
        ),
        debugShowCheckedModeBanner: false,
        home: const Scaffold(
          body: SplashPage(),
        ),
      ),
    );
  }
}
