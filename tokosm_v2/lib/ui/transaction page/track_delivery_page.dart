import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tokosm_v2/cubit/auth_cubit.dart';
import 'package:tokosm_v2/cubit/transaction_cubit.dart';
import 'package:tokosm_v2/shared/themes.dart';
import 'package:tokosm_v2/shared/utils.dart';

class TrackDeliveryPage extends StatefulWidget {
  const TrackDeliveryPage({super.key});

  @override
  State<TrackDeliveryPage> createState() => _TrackDeliveryPageState();
}

class _TrackDeliveryPageState extends State<TrackDeliveryPage> {
  Map<String, dynamic>? data;

  @override
  initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData(); // panggil setelah frame pertama selesai
    });
    super.initState();
  }

  void initData() async {
    Utils().loadingDialog(context: context);
    await context.read<TrackingTransactionCubit>().getTrackingTransaction(
          token: context.read<AuthCubit>().state.loginModel.token ?? "",
          noInvoice: context
                  .read<DetailTransactionCubit>()
                  .state
                  .detailTransactionModel
                  ?.data
                  ?.first
                  .noInvoice ??
              "",
        );

    if (context.read<TrackingTransactionCubit>().state
        is TrackingTransactionSuccess) {
      data = (context.read<TrackingTransactionCubit>().state
              as TrackingTransactionSuccess)
          .TrackingTransactionData["data"];

      setState(() {});
    }

    Navigator.pop(context);
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
                  "Status Pengiriman",
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

    return BlocBuilder<TrackingTransactionCubit, TrackingTransactionState>(
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
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: ListView(
                      children: [
                        // NOTE: Kurir
                        Row(
                          children: [
                            const Text(
                              "kurir",
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                "${data?["pengiriman"]["kurir"]} - ${data?["pengiriman"]["nama_layanan"]}"
                                    .toUpperCase(),
                                style: TextStyle(
                                  fontWeight: bold,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                        // NOTE: No Resi
                        Row(
                          children: [
                            const Text(
                              "No Resi",
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                "${data?["pengiriman"]["no_resi"]}",
                                style: TextStyle(
                                  fontWeight: bold,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            const Icon(
                              SolarIconsOutline.copy,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // NOTE: Track Delivery
                        Stack(
                          children: [
                            Positioned.fill(
                              child: Container(
                                margin: const EdgeInsets.only(
                                  left: 7.5,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                      color: greyBase300,
                                      width: 5,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                for (var dataTrack in data?["status"]) ...{
                                  _TrackDeliveryPageExtension()
                                      .trackDeliveryItem(
                                    title: "${dataTrack["keterangan"]}",
                                    message: "${dataTrack["deskripsi"]}",
                                    date:
                                        "${dataTrack["date"]}, ${dataTrack["time"]}",
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                },
                              ],
                            ),
                          ],
                        )
                      ],
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

class _TrackDeliveryPageExtension {
  Widget trackDeliveryItem({
    required String title,
    required String message,
    required String date,
    bool isActive = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorSuccess,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Text(
              title,
              style: TextStyle(
                fontWeight: bold,
              ),
            ),
            Expanded(
              child: Text(
                date,
                style: const TextStyle(
                  color: Colors.grey,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(
            left: 36,
          ),
          child: Text(
            message,
          ),
        ),
      ],
    );
  }
}
