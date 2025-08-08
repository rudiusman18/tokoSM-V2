import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tokosm_v2/cubit/cabang_cubit.dart';
import 'package:tokosm_v2/shared/themes.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CabangCubit, CabangState>(
      builder: (context, state) {
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
                        'Keranjang',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () async {
                      final List<String> listCabangName =
                          (context.read<CabangCubit>().state.cabangModel.data ??
                                  [])
                              .map((e) => e.namaCabang ?? "")
                              .toList();

                      final result = await showMenu<String>(
                        context: context,
                        position: const RelativeRect.fromLTRB(
                            40, 100, 30, 0), // sesuaikan posisi
                        items: listCabangName.map((String cabang) {
                          return PopupMenuItem<String>(
                            value: cabang,
                            child: Text(cabang),
                          );
                        }).toList(),
                      );

                      if (result != null) {
                        setState(() {
                          context.read<CabangCubit>().selectCabang(
                                cabang: (context
                                            .read<CabangCubit>()
                                            .state
                                            .cabangModel
                                            .data ??
                                        [])
                                    .firstWhere(
                                  (e) =>
                                      (e.namaCabang ?? "").toLowerCase() ==
                                      result.toLowerCase(),
                                ),
                              );
                        });
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 10,
                      children: [
                        const Icon(
                          SolarIconsOutline.shopMinimalistic,
                          size: 24,
                        ),
                        Text(
                          "Cabang ${context.read<CabangCubit>().state.selectedCabangData.namaCabang?.replaceAll("Cab ", "")}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: bold,
                          ),
                        ),
                        const Icon(
                          SolarIconsBold.altArrowDown,
                          size: 15,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: [],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
