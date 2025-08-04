import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tokosm_v2/cubit/auth_cubit.dart';
import 'package:tokosm_v2/cubit/transaction_cubit.dart';
import 'package:tokosm_v2/model/transaction_model.dart';
import 'package:tokosm_v2/shared/themes.dart';
import 'package:tokosm_v2/shared/utils.dart';

class DetailTransactionPage extends StatefulWidget {
  const DetailTransactionPage({super.key});

  @override
  State<DetailTransactionPage> createState() => _DetailTransactionPageState();
}

class _DetailTransactionPageState extends State<DetailTransactionPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initDetailTransaction();
    });
    super.initState();
  }

  void initDetailTransaction() {
    context.read<DetailTransactionCubit>().getDetailTransactionData(
        token: context.read<AuthCubit>().state.loginModel.token ?? "",
        noInvoice: context
                .read<TransactionCubit>()
                .state
                .selectedTransaction
                ?.noInvoice ??
            "");
  }

  @override
  Widget build(BuildContext context) {
    Widget header() {
      return Container(
        margin: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            // NOTE: Header
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
                  "Detail Pesanan",
                  style: TextStyle(
                    // fontSize: 24,
                    fontWeight: bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return BlocConsumer<DetailTransactionCubit, DetailTransactionState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: header(),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 5,
                  width: double.infinity,
                  color: greyBase300,
                ),
                Expanded(
                  child: ListView(
                    children: [
                      // NOTE: status
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: Column(
                          spacing: 5,
                          children: [
                            Row(
                              spacing: 5,
                              children: [
                                Text(
                                  "|",
                                  style: TextStyle(
                                    fontWeight: bold,
                                    color: colorError,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    context
                                            .read<DetailTransactionCubit>()
                                            .state
                                            .detailTransactionModel
                                            ?.data
                                            ?.first
                                            .keteranganStatus ??
                                        "",
                                    style: TextStyle(
                                      fontWeight: bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  "Cara Bayar",
                                  style: TextStyle(
                                    color: colorSuccess,
                                    fontWeight: bold,
                                  ),
                                ),
                              ],
                            ),
                            _DetailTransactionPageExtension().itemView(
                              title: "No Pelanggan",
                              value:
                                  "${context.read<DetailTransactionCubit>().state.detailTransactionModel?.data?.first.noInvoice}",
                            ),
                            _DetailTransactionPageExtension().itemView(
                              title: "Tanggal Pembelian",
                              value: (context
                                              .read<DetailTransactionCubit>()
                                              .state
                                              .detailTransactionModel
                                              ?.data
                                              ?.first
                                              .createdAt ??
                                          "") ==
                                      ""
                                  ? "Tidak ada data"
                                  : Utils().formatTanggal(
                                      "${context.read<DetailTransactionCubit>().state.detailTransactionModel?.data?.first.createdAt}",
                                    ),
                            ),
                            _DetailTransactionPageExtension().itemView(
                              title: "Metode Pembayaran",
                              value:
                                  "${context.read<DetailTransactionCubit>().state.detailTransactionModel?.data?.first.metodePembayaran}",
                            ),
                            _DetailTransactionPageExtension().itemView(
                              title: "Status Pembayaran",
                              value:
                                  "${context.read<DetailTransactionCubit>().state.detailTransactionModel?.data?.first.keteranganStatus}",
                              color: context
                                          .read<DetailTransactionCubit>()
                                          .state
                                          .detailTransactionModel
                                          ?.data
                                          ?.first
                                          .keteranganStatus
                                          ?.toLowerCase() ==
                                      'belum dibayar'
                                  ? colorError
                                  : context
                                              .read<DetailTransactionCubit>()
                                              .state
                                              .detailTransactionModel
                                              ?.data
                                              ?.first
                                              .keteranganStatus
                                              ?.toLowerCase() ==
                                          'diproses'
                                      ? Colors.orange
                                      : context
                                                  .read<
                                                      DetailTransactionCubit>()
                                                  .state
                                                  .detailTransactionModel
                                                  ?.data
                                                  ?.first
                                                  .keteranganStatus
                                                  ?.toLowerCase() ==
                                              'dikirim'
                                          ? colorInfo
                                          : context
                                                      .read<
                                                          DetailTransactionCubit>()
                                                      .state
                                                      .detailTransactionModel
                                                      ?.data
                                                      ?.first
                                                      .keteranganStatus
                                                      ?.toLowerCase() ==
                                                  'selesai'
                                              ? colorSuccess
                                              : colorError,
                            ),
                            _DetailTransactionPageExtension().itemView(
                              title: "Batas Pembayaran",
                              value: context
                                      .read<DetailTransactionCubit>()
                                      .state
                                      .detailTransactionModel
                                      ?.data
                                      ?.first
                                      .tglJatuhTempo ??
                                  "-",
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 5,
                        width: double.infinity,
                        color: greyBase300,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if ((context
                                  .read<DetailTransactionCubit>()
                                  .state
                                  .detailTransactionModel
                                  ?.data
                                  ?.first
                                  .pengiriman
                                  ?.kurir ??
                              "") !=
                          "") ...{
                        // NOTE: Info Pengiriman
                        Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          child: Column(
                            spacing: 5,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "info Pengiriman",
                                style: TextStyle(
                                  fontWeight: bold,
                                ),
                              ),
                              _DetailTransactionPageExtension().itemView(
                                title: "Kurir",
                                value: context
                                        .read<DetailTransactionCubit>()
                                        .state
                                        .detailTransactionModel
                                        ?.data
                                        ?.first
                                        .pengiriman
                                        ?.kurir ??
                                    "",
                              ),
                              Row(
                                spacing: 5,
                                children: [
                                  Expanded(
                                    child: _DetailTransactionPageExtension()
                                        .itemView(
                                      title: "no Resi",
                                      value: context
                                              .read<DetailTransactionCubit>()
                                              .state
                                              .detailTransactionModel
                                              ?.data
                                              ?.first
                                              .pengiriman
                                              ?.noresi ??
                                          "",
                                    ),
                                  ),
                                  const Icon(
                                    SolarIconsOutline.copy,
                                    size: 14,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),

                        Container(
                          height: 5,
                          width: double.infinity,
                          color: greyBase300,
                        ),
                        // ignore: equal_elements_in_set
                        const SizedBox(
                          height: 10,
                        ),

                        // NOTE: Alamat Pengiriman
                        Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 5,
                            children: [
                              Text(
                                "Alamat Pengiriman",
                                style: TextStyle(
                                  fontWeight: bold,
                                ),
                              ),
                              _DetailTransactionPageExtension().addressItemView(
                                transaction: context
                                        .read<DetailTransactionCubit>()
                                        .state
                                        .detailTransactionModel
                                        ?.data
                                        ?.first ??
                                    TransactionData(),
                              ),
                            ],
                          ),
                        ),

                        // ignore: equal_elements_in_set
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 5,
                          width: double.infinity,
                          color: greyBase300,
                        ),
                        // ignore: equal_elements_in_set
                        const SizedBox(
                          height: 10,
                        ),
                      },

                      //NOTE: Produk dan cabangnya
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
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
                                  "Cabang ${context.read<DetailTransactionCubit>().state.detailTransactionModel?.data?.first.namaCabang ?? "-"}",
                                  style: TextStyle(
                                    fontWeight: bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  (context
                                                  .read<
                                                      DetailTransactionCubit>()
                                                  .state
                                                  .detailTransactionModel
                                                  ?.data
                                                  ?.first
                                                  .createdAt ??
                                              "") !=
                                          ""
                                      ? Utils().formatTanggal(context
                                              .read<DetailTransactionCubit>()
                                              .state
                                              .detailTransactionModel
                                              ?.data
                                              ?.first
                                              .createdAt ??
                                          "")
                                      : "",
                                  style: const TextStyle(
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                            for (var index = 0;
                                index <
                                    (context
                                                .read<DetailTransactionCubit>()
                                                .state
                                                .detailTransactionModel
                                                ?.data
                                                ?.first
                                                .produk ??
                                            [])
                                        .length;
                                index++)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 5,
                                children: [
                                  Container(
                                    height: 48,
                                    width: 48,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      image: DecorationImage(
                                          image: NetworkImage(context
                                                  .read<
                                                      DetailTransactionCubit>()
                                                  .state
                                                  .detailTransactionModel
                                                  ?.data
                                                  ?.first
                                                  .produk?[index]
                                                  .gambarProduk ??
                                              "")),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          context
                                                  .read<
                                                      DetailTransactionCubit>()
                                                  .state
                                                  .detailTransactionModel
                                                  ?.data
                                                  ?.first
                                                  .produk?[index]
                                                  .namaProduk ??
                                              "-",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: bold,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "Rp ${context.read<DetailTransactionCubit>().state.detailTransactionModel?.data?.first.produk?[index].hargaProduk ?? ""}",
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              ),
                                            ),
                                            Text(
                                              "x ${context.read<DetailTransactionCubit>().state.detailTransactionModel?.data?.first.produk?[index].jumlah ?? ""}",
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      Container(
                        height: 5,
                        width: double.infinity,
                        color: greyBase300,
                      ),
                      // ignore: equal_elements_in_set
                      const SizedBox(
                        height: 10,
                      ),

                      //NOTE: rincian pembayaran
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          spacing: 5,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Rincian Pembayaran",
                              style: TextStyle(
                                fontWeight: bold,
                              ),
                            ),
                            _DetailTransactionPageExtension().itemView(
                                title: "Total harga",
                                value:
                                    "Rp ${context.read<DetailTransactionCubit>().state.detailTransactionModel?.data?.first.subtotal ?? 0}"),
                            _DetailTransactionPageExtension().itemView(
                                title: "Total Ongkos Kirim",
                                value:
                                    "Rp ${context.read<DetailTransactionCubit>().state.detailTransactionModel?.data?.first.totalOngkosKirim ?? 0}"),
                            _DetailTransactionPageExtension().itemView(
                                title: "Total Diskon",
                                value:
                                    "Rp ${context.read<DetailTransactionCubit>().state.detailTransactionModel?.data?.first.totalDiskon ?? 0}"),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Total Pesanan",
                                    style: TextStyle(
                                      fontWeight: bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  "Rp ${(context.read<DetailTransactionCubit>().state.detailTransactionModel?.data?.first.total ?? 0)}",
                                  style: TextStyle(
                                    fontWeight: bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DetailTransactionPageExtension {
  Widget itemView({
    required String title,
    required String value,
    Color color = Colors.black,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 12),
          ),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 12, color: color),
        ),
      ],
    );
  }

  Widget addressItemView({required TransactionData transaction}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        const Icon(
          SolarIconsOutline.mapPoint,
          size: 14,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "${transaction.pengiriman?.namaPenerima}",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                  ),
                  TextSpan(
                    text: " | ${transaction.pengiriman?.telpPenerima}",
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            Text(
              transaction.pengiriman?.alamatLengkap ?? "",
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
