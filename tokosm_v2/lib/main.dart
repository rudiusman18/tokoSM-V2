import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokosm_v2/cubit/page_cubit.dart';
import 'package:tokosm_v2/cubit/wishlist_cubit.dart';
import 'package:tokosm_v2/ui/main_page.dart';

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
          create: (context) => WishlistTabFilterCubit(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: 'Urbanist',
          splashColor: Colors.transparent,
        ),
        debugShowCheckedModeBanner: false,
        home: const Scaffold(
          body: MainPage(),
        ),
      ),
    );
  }
}
