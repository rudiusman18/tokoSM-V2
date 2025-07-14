import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tokosm_v2/cubit/transaction_cubit.dart';
import 'package:tokosm_v2/shared/themes.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  var tabFilter = [
    "Semua",
    "Belum bayar",
    "Diproses",
    "Dikirim",
    "Selesai",
    "Dibatalkan",
    "Pengembalian",
  ];

  @override
  Widget build(BuildContext context) {
    Widget header() {
      return Container(
        margin: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            // NOTE: search
            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: colorSecondary,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          size: 20,
                          color: colorSecondary,
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(
                              left: 10,
                            ),
                            child: TextFormField(
                              style: const TextStyle(fontSize: 12),
                              decoration: const InputDecoration.collapsed(
                                hintText: "Cari Transaksi",
                                hintStyle: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const Icon(
                  SolarIconsOutline.cartLarge2,
                  size: 24,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var i = 0; i < tabFilter.length; i++) ...{
                    GestureDetector(
                      onTap: () {
                        context
                            .read<TransactionTabFilterCubit>()
                            .setTabIndex(i);
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                            bottom: 5, left: 10, right: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: i ==
                                      context
                                          .read<TransactionTabFilterCubit>()
                                          .state
                                  ? Colors.black
                                  : colorSecondary, // Warna border
                              width: 2.0, // Ketebalan border
                            ),
                          ),
                        ),
                        child: Text(
                          tabFilter[i],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: i ==
                                    context
                                        .read<TransactionTabFilterCubit>()
                                        .state
                                ? Colors.black
                                : colorSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  },
                ],
              ),
            )
          ],
        ),
      );
    }

    return BlocBuilder<TransactionTabFilterCubit, int>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
              child: Column(
            children: [
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: header()),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView(
                  children: [
                    for (var i = 0; i < 20; i++) ...{
                      _TransactionPageExtension().transactionItemView(
                        context: context,
                        cabangName: "Cabang Pusat",
                        dateString: "8 Mar 25",
                        status: "Belum Dibayar",
                        productImageURL: "",
                        productName: "Wafer Tango",
                        productPrice: "Rp 12000",
                      ),
                    },
                    Container(
                      height: 5,
                      color: greyBase300,
                    ),
                  ],
                ),
              ),
            ],
          )),
        );
      },
    );
  }
}

class _TransactionPageExtension {
  Widget transactionItemView({
    required BuildContext context,
    required String cabangName,
    required String dateString,
    required String status,
    required String productImageURL,
    required String productName,
    required String productPrice,
  }) {
    return Column(
      spacing: 10,
      children: [
        Container(
          height: 5,
          color: greyBase300,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            spacing: 10,
            children: [
              Row(
                spacing: 5,
                children: [
                  const Icon(
                    SolarIconsOutline.shopMinimalistic,
                    size: 18,
                  ),
                  Text(
                    cabangName,
                    style: TextStyle(
                      fontWeight: bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    dateString,
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                    ),
                    decoration: BoxDecoration(
                      color: colorError.withAlpha(50),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: colorError,
                        fontSize: 12,
                      ),
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 5,
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          productName,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: bold,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              productPrice,
                              style: const TextStyle(fontSize: 12),
                            ),
                            const Text(
                              "x1",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ), // default style
                      children: [
                        TextSpan(text: 'Total (1 Produk): '),
                        TextSpan(
                          text: 'Rp 12000',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: colorSuccess,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text(
                      "Bayar",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        const SizedBox()
      ],
    );
  }
}
