import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:toastification/toastification.dart';
import 'package:tokosm_v2/cubit/auth_cubit.dart';
import 'package:tokosm_v2/cubit/transaction_cubit.dart';
import 'package:tokosm_v2/model/transaction_model.dart';
import 'package:tokosm_v2/shared/themes.dart';
import 'package:tokosm_v2/shared/utils.dart';
import 'package:image_picker/image_picker.dart';

class DetailTransactionPage extends StatefulWidget {
  const DetailTransactionPage({super.key});

  @override
  State<DetailTransactionPage> createState() => _DetailTransactionPageState();
}

class _DetailTransactionPageState extends State<DetailTransactionPage> {
  final ImagePicker picker = ImagePicker();

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
    Widget paymentConfirmation(BuildContext context) {
      File? file;
      TextEditingController noRekeningTextController = TextEditingController(
        text:
            "${context.read<DetailTransactionCubit>().state.detailTransactionModel?.data?.first.detailPembayaran?.norekeningPengirim ?? ""}",
      );
      TextEditingController fullNameTextController = TextEditingController(
        text:
            "${context.read<DetailTransactionCubit>().state.detailTransactionModel?.data?.first.detailPembayaran?.namaPengirim ?? ""}",
      );

      return StatefulBuilder(builder: (context, setState) {
        return SafeArea(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // NOTE: Judul
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Konfirmasi Pembayaran",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: bold,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.close,
                      ),
                    ),
                  ],
                ),
                // NOTE: Bank
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Expanded(
                      child: Text(
                        "Bank",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    Image.network(
                      "https://images.tokopedia.net/img/payment/icons/${context.read<DetailTransactionCubit>().state.detailTransactionModel?.data?.first.detailPembayaran?.namaBank?.toLowerCase()}.png",
                      width: 50,
                      height: 50,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                // NOTE: No Rekening
                Row(
                  spacing: 10,
                  children: [
                    const Expanded(
                      child: Text(
                        "No Rekening",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    Flexible(
                      child: TextFormField(
                        textAlign: TextAlign.end,
                        keyboardType: TextInputType.number,
                        controller: noRekeningTextController,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                        decoration: const InputDecoration.collapsed(
                          hintText: 'No Rekening Pengguna',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                // NOTE: Nama Lengkap
                Row(
                  spacing: 10,
                  children: [
                    const Text(
                      "Nama Lengkap",
                      style: TextStyle(fontSize: 14),
                    ),
                    Flexible(
                      child: TextFormField(
                        textAlign: TextAlign.end,
                        controller: fullNameTextController,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                        decoration: const InputDecoration.collapsed(
                          hintText: 'Nama Pengguna',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                // NOTE: Bukti Transfer
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: Text(
                        "Bukti Transfer",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Utils().customAlertDialog(
                          context: context,
                          confirmationFunction: () {},
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    foregroundColor: colorSuccess,
                                  ),
                                  onPressed: () async {
                                    final pickedFile = await picker.pickImage(
                                        source: ImageSource.gallery);

                                    if (pickedFile != null) {
                                      Navigator.pop(context);
                                      setState(() {
                                        file = File(pickedFile.path);
                                      });
                                    } else {
                                      print("Tidak ada gambar yang dipilih");
                                    }
                                  },
                                  child: Text(
                                    "Galeri",
                                    style: TextStyle(
                                      color: colorSuccess,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    foregroundColor: colorSuccess,
                                  ),
                                  onPressed: () async {
                                    final pickedFile = await picker.pickImage(
                                        source: ImageSource.camera);

                                    if (pickedFile != null) {
                                      Navigator.pop(context);
                                      setState(() {
                                        file = File(pickedFile.path);
                                      });
                                      print("isi file adalah $file");
                                    } else {
                                      print("Tidak ada gambar yang dipilih");
                                    }
                                  },
                                  child: Text(
                                    "Kamera",
                                    style: TextStyle(
                                      color: colorSuccess,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          title: "Pilih Sumber Gambar",
                        );
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        color: Colors.transparent,
                        child: file != null
                            ? Image.file(
                                file!,
                                fit: BoxFit.cover,
                              )
                            : const DottedBorder(
                                options: RectDottedBorderOptions(
                                  dashPattern: [
                                    5,
                                  ],
                                  color: Colors.grey,
                                  strokeWidth: 2,
                                  padding: EdgeInsets.all(16),
                                ),
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),

                // Button Simpan
                Container(
                  margin: const EdgeInsets.only(
                    top: 20,
                  ),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (noRekeningTextController.text != "" &&
                          fullNameTextController.text != "" &&
                          file != null) {
                        Utils().loadingDialog(context: context);
                        await context
                            .read<DetailTransactionCubit>()
                            .postPaymentConfirmation(
                              token: context
                                      .read<AuthCubit>()
                                      .state
                                      .loginModel
                                      .token ??
                                  "",
                              noInvoice:
                                  "${context.read<DetailTransactionCubit>().state.detailTransactionModel?.data?.first.noInvoice}",
                              noRekening: noRekeningTextController.text,
                              nama: fullNameTextController.text,
                              bukti: file!,
                            );
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Utils().scaffoldMessenger(context,
                            "Anda telah melakukan konfirmasi pembayaran");
                      } else {
                        toastification.show(
                          context:
                              context, // optional if you use ToastificationWrapper
                          title: const Text(
                              'Silahkan lengkapi data Anda terlebih dahulu'),
                          autoCloseDuration: const Duration(seconds: 2),
                          style: ToastificationStyle.simple,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorSuccess,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Simpan",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      });
    }

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

    return BlocBuilder<DetailTransactionCubit, DetailTransactionState>(
      builder: (context, state) {
        return Scaffold(
          body: state is DetailTransactionLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: colorSuccess,
                  ),
                )
              : state is! DetailTransactionSuccess
                  ? const SizedBox()
                  : SafeArea(
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
                                              color: context
                                                          .read<
                                                              DetailTransactionCubit>()
                                                          .state
                                                          .detailTransactionModel
                                                          ?.data
                                                          ?.first
                                                          .status ==
                                                      0
                                                  ? colorWarning
                                                  : context
                                                              .read<
                                                                  DetailTransactionCubit>()
                                                              .state
                                                              .detailTransactionModel
                                                              ?.data
                                                              ?.first
                                                              .status ==
                                                          1
                                                      ? Colors.orange
                                                      : context
                                                                  .read<
                                                                      DetailTransactionCubit>()
                                                                  .state
                                                                  .detailTransactionModel
                                                                  ?.data
                                                                  ?.first
                                                                  .status ==
                                                              2
                                                          ? colorInfo
                                                          : context
                                                                      .read<
                                                                          DetailTransactionCubit>()
                                                                      .state
                                                                      .detailTransactionModel
                                                                      ?.data
                                                                      ?.first
                                                                      .status ==
                                                                  3
                                                              ? colorSuccess
                                                              : context
                                                                          .read<
                                                                              DetailTransactionCubit>()
                                                                          .state
                                                                          .detailTransactionModel
                                                                          ?.data
                                                                          ?.first
                                                                          .status ==
                                                                      4
                                                                  ? colorSuccess
                                                                  : context
                                                                              .read<
                                                                                  DetailTransactionCubit>()
                                                                              .state
                                                                              .detailTransactionModel
                                                                              ?.data
                                                                              ?.first
                                                                              .status ==
                                                                          5
                                                                      ? colorError
                                                                      : Colors
                                                                          .grey,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              context
                                                      .read<
                                                          DetailTransactionCubit>()
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
                                            ((context
                                                            .read<
                                                                DetailTransactionCubit>()
                                                            .state
                                                            .detailTransactionModel
                                                            ?.data
                                                            ?.first
                                                            .status ??
                                                        0) ==
                                                    0)
                                                ? "Cara Bayar"
                                                : ((context
                                                                .read<
                                                                    DetailTransactionCubit>()
                                                                .state
                                                                .detailTransactionModel
                                                                ?.data
                                                                ?.first
                                                                .status ??
                                                            0) ==
                                                        2)
                                                    ? "Lacak Pengiriman"
                                                    : "",
                                            style: TextStyle(
                                              color: colorSuccess,
                                              fontWeight: bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      _DetailTransactionPageExtension()
                                          .itemView(
                                        title: "No Pelanggan",
                                        value:
                                            "${context.read<DetailTransactionCubit>().state.detailTransactionModel?.data?.first.noInvoice}",
                                      ),
                                      _DetailTransactionPageExtension()
                                          .itemView(
                                        title: "Tanggal Pembelian",
                                        value: (context
                                                        .read<
                                                            DetailTransactionCubit>()
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
                                      _DetailTransactionPageExtension()
                                          .itemView(
                                        title: "Metode Pembayaran",
                                        value:
                                            "${context.read<DetailTransactionCubit>().state.detailTransactionModel?.data?.first.metodePembayaran}",
                                      ),
                                      _DetailTransactionPageExtension()
                                          .itemView(
                                        title: "Status Pembayaran",
                                        value: context
                                                    .read<
                                                        DetailTransactionCubit>()
                                                    .state
                                                    .detailTransactionModel
                                                    ?.data
                                                    ?.first
                                                    .status !=
                                                0
                                            ? "Sudah Dibayar"
                                            : "${context.read<DetailTransactionCubit>().state.detailTransactionModel?.data?.first.keteranganStatus}",
                                        color: context
                                                    .read<
                                                        DetailTransactionCubit>()
                                                    .state
                                                    .detailTransactionModel
                                                    ?.data
                                                    ?.first
                                                    .status !=
                                                0
                                            ? colorSuccess
                                            : Colors.orange,
                                        isClickable: context
                                                    .read<
                                                        DetailTransactionCubit>()
                                                    .state
                                                    .detailTransactionModel
                                                    ?.data
                                                    ?.first
                                                    .status !=
                                                0
                                            ? true
                                            : false,
                                      ),
                                      _DetailTransactionPageExtension()
                                          .itemView(
                                        title: "Batas Pembayaran",
                                        value: context
                                                .read<DetailTransactionCubit>()
                                                .state
                                                .detailTransactionModel
                                                ?.data
                                                ?.first
                                                .tglJatuhtempo ??
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "info Pengiriman",
                                          style: TextStyle(
                                            fontWeight: bold,
                                          ),
                                        ),
                                        _DetailTransactionPageExtension()
                                            .itemView(
                                          title: "Kurir",
                                          value: context
                                                  .read<
                                                      DetailTransactionCubit>()
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
                                              child:
                                                  _DetailTransactionPageExtension()
                                                      .itemView(
                                                title: "no Resi",
                                                value: context
                                                        .read<
                                                            DetailTransactionCubit>()
                                                        .state
                                                        .detailTransactionModel
                                                        ?.data
                                                        ?.first
                                                        .pengiriman
                                                        ?.noResi ??
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      spacing: 5,
                                      children: [
                                        Text(
                                          "Alamat Pengiriman",
                                          style: TextStyle(
                                            fontWeight: bold,
                                          ),
                                        ),
                                        _DetailTransactionPageExtension()
                                            .addressItemView(
                                          transaction: context
                                                  .read<
                                                      DetailTransactionCubit>()
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
                                          Expanded(
                                            child: Text(
                                              "Cabang ${context.read<DetailTransactionCubit>().state.detailTransactionModel?.data?.first.namaCabang ?? "-"}",
                                              style: TextStyle(
                                                fontWeight: bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "${context.read<DetailTransactionCubit>().state.detailTransactionModel?.data?.first.produk?.length} Produk",
                                            style: const TextStyle(
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                      for (var index = 0;
                                          index <
                                              (context
                                                          .read<
                                                              DetailTransactionCubit>()
                                                          .state
                                                          .detailTransactionModel
                                                          ?.data
                                                          ?.first
                                                          .produk ??
                                                      [])
                                                  .length;
                                          index++)
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                borderRadius:
                                                    BorderRadius.circular(8),
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
                                                          "Rp ${formatNumber(context.read<DetailTransactionCubit>().state.detailTransactionModel?.data?.first.produk?[index].hargaProduk ?? 0)}",
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12),
                                                        ),
                                                      ),
                                                      Text(
                                                        "x ${context.read<DetailTransactionCubit>().state.detailTransactionModel?.data?.first.produk?[index].jumlah ?? ""}",
                                                        style: const TextStyle(
                                                            fontSize: 12),
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
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Column(
                                    spacing: 5,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              "Rp ${formatNumber(context.read<DetailTransactionCubit>().state.detailTransactionModel?.data?.first.subtotal ?? 0)}"),
                                      _DetailTransactionPageExtension().itemView(
                                          title: "Total Ongkos Kirim",
                                          value:
                                              "Rp ${formatNumber(context.read<DetailTransactionCubit>().state.detailTransactionModel?.data?.first.totalOngkosKirim ?? 0)}"),
                                      _DetailTransactionPageExtension().itemView(
                                          title: "Total Diskon",
                                          value:
                                              "Rp ${formatNumber(context.read<DetailTransactionCubit>().state.detailTransactionModel?.data?.first.totalDiskon ?? 0)}"),
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
                                            "Rp ${formatNumber((context.read<DetailTransactionCubit>().state.detailTransactionModel?.data?.first.total ?? 0))}",
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
                          (context
                                      .read<DetailTransactionCubit>()
                                      .state
                                      .detailTransactionModel
                                      ?.data
                                      ?.first
                                      .status) !=
                                  0
                              ? const SizedBox()
                              : Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 16,
                                  ),
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      (context
                                                      .read<
                                                          DetailTransactionCubit>()
                                                      .state
                                                      .detailTransactionModel
                                                      ?.data
                                                      ?.first
                                                      .status ??
                                                  0) ==
                                              0
                                          ?
                                          // NOTE: Menunggu Pembayaran / Belum Dibayar
                                          Utils().customBottomSheet(context,
                                              paymentConfirmation(context))
                                          : print("");
                                    },
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadiusGeometry.circular(10),
                                      side: BorderSide(
                                        color: colorSuccess,
                                      ),
                                    )),
                                    child: Text(
                                      (context
                                                      .read<
                                                          DetailTransactionCubit>()
                                                      .state
                                                      .detailTransactionModel
                                                      ?.data
                                                      ?.first
                                                      .status ??
                                                  0) ==
                                              0
                                          ? "Konfirmasi Pembayaran"
                                          : "",
                                      style: TextStyle(
                                        color: colorSuccess,
                                      ),
                                    ),
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
    bool isClickable = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 12),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (isClickable) {}
          },
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12,
              color: color,
              decoration:
                  isClickable ? TextDecoration.underline : TextDecoration.none,
              decorationThickness: 2,
              decorationColor: color,
              decorationStyle: TextDecorationStyle.solid,
            ),
          ),
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
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: bold,
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
