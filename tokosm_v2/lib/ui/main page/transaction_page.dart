import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tokosm_v2/cubit/cabang_cubit.dart';
import 'package:tokosm_v2/cubit/login_cubit.dart';
import 'package:tokosm_v2/cubit/transaction_cubit.dart';
import 'package:tokosm_v2/model/transaction_model.dart';
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
    "Diterima",
    "Selesai",
    "Dibatalkan",
    "Dikembalikan",
  ];

  @override
  void initState() {
    initTransactionData();
    super.initState();
  }

  void initTransactionData() {
    context.read<TransactionCubit>().getTransactionData(
          token: context.read<AuthCubit>().state.loginModel.token ?? "",
          status:
              "${(context.read<TransactionCubit>().state.transactionTabIndex - 1) == -1 ? "" : context.read<TransactionCubit>().state.transactionTabIndex - 1}",
          cabangId:
              "${context.read<CabangCubit>().state.selectedCabangData.id ?? 0}",
          page: 1,
          limit: 999999999,
        );
  }

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
                        context.read<TransactionCubit>().setTabIndex(i);
                        initTransactionData();
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                            bottom: 5, left: 10, right: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: i ==
                                      context
                                          .read<TransactionCubit>()
                                          .state
                                          .transactionTabIndex
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
                                        .read<TransactionCubit>()
                                        .state
                                        .transactionTabIndex
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

    return BlocBuilder<TransactionCubit, TransactionState>(
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
                    for (var i = 0;
                        i <
                            (context
                                        .read<TransactionCubit>()
                                        .state
                                        .transactionModel
                                        ?.data ??
                                    [])
                                .length;
                        i++) ...{
                      _TransactionPageExtension().transactionItemView(
                        context: context,
                        transactionModel: context
                                .read<TransactionCubit>()
                                .state
                                .transactionModel
                                ?.data?[i] ??
                            TransactionData(),
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
    required TransactionData transactionModel,
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
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    "Cabang ${transactionModel.namaCabang ?? "-"}",
                    style: TextStyle(
                      fontWeight: bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    transactionModel.tglJatuhTempo ?? "",
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
                      transactionModel.keteranganStatus ??
                          "Status tidak ditemukan",
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
                          transactionModel.namaProduk?.first ?? "-",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: bold,
                          ),
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Rp Belum ada harganya",
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              "x Belum jumlah satuannya",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              (transactionModel.jumlahProduk ?? 0) - 1 < 1
                  ? const SizedBox()
                  : Text(
                      "+${(transactionModel.jumlahProduk ?? 0) - 1} produk lainnya",
                      style: const TextStyle(fontSize: 12),
                    ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ), // default style
                      children: [
                        TextSpan(
                            text:
                                'Total (${transactionModel.jumlahProduk} Produk): '),
                        TextSpan(
                          text: 'Rp ${transactionModel.total}',
                          style: const TextStyle(
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
