import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tokosm_v2/cubit/auth_cubit.dart';
import 'package:tokosm_v2/cubit/transaction_cubit.dart';
import 'package:tokosm_v2/shared/themes.dart';
import 'package:tokosm_v2/shared/utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HowToPayPage extends StatefulWidget {
  const HowToPayPage({super.key});

  @override
  State<HowToPayPage> createState() => _HowToPayPageState();
}

class _HowToPayPageState extends State<HowToPayPage> {
  late final WebViewController _howToPayWebController;

  @override
  void initState() {
    initData();

    super.initState();
  }

  void initData() async {
    print("initData dijalankan");
    await context
        .read<DetailPaymentTransactionCubit>()
        .getDetailPaymentTransaction(
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

    _howToPayWebController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      // ..setNavigationDelegate(
      //   NavigationDelegate(
      //     onPageStarted: (_) => setState(() => isLoading = true),
      //     onPageFinished: (_) => setState(() => isLoading = false),
      //   ),
      // )
      ..loadRequest(Uri.parse(context
              .read<DetailPaymentTransactionCubit>()
              .state is DetailPaymentTrasansactionSuccess
          ? "$paymentTutorialURL/carabayar/${(context.read<DetailPaymentTransactionCubit>().state as DetailPaymentTrasansactionSuccess).detailPaymentTransactionData["data"]["bank_id"]}/${(context.read<DetailPaymentTransactionCubit>().state as DetailPaymentTrasansactionSuccess).detailPaymentTransactionData["data"]["total"]}"
          : ""));

    // http://192.168.1.13:3000/mobile/transaksi/carabayar/[bank_id]/[total_bayar]

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var data = context.read<DetailPaymentTransactionCubit>().state
            is DetailPaymentTrasansactionSuccess
        ? (context.read<DetailPaymentTransactionCubit>().state
                as DetailPaymentTrasansactionSuccess)
            .detailPaymentTransactionData["data"]
        : null;
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
                  "Cara Pembayaran",
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

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: header(),
          ),
          Container(
            height: 5,
            width: double.infinity,
            color: greyBase300,
          ),
          _HowToPayPageExtension().itemView(
            title: "Bank Tujuan",
            value: "${data?["logo_bank"] ?? "-"}",
          ),
          _HowToPayPageExtension().itemView(
            title: "No Rekening Tujuan",
            value: "${data?["norekening_tujuan"] ?? "-"}",
          ),
          _HowToPayPageExtension().itemView(
            title: "Total Pembayaran",
            value: "Rp ${formatNumber(
              data?["total"] ?? 0,
            )}",
          ),
          Container(
            height: 5,
            width: double.infinity,
            color: greyBase300,
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Text(
              "Petunjuk Pembayaran",
              style: TextStyle(
                // fontSize: 24,
                fontWeight: bold,
              ),
            ),
          ),
          Expanded(
            child: WebViewWidget(
              controller: _howToPayWebController,
            ),
          ),
        ],
      )),
    );
  }
}

class _HowToPayPageExtension {
  Widget itemView({
    required String title,
    required dynamic value,
    Color color = Colors.black,
    bool isClickable = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Row(
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
              child: (Uri.tryParse(value) != null &&
                      (Uri.tryParse(value)!.isScheme('http') ||
                          Uri.tryParse(value)!.isScheme('https')))
                  ? Image.network(
                      value,
                      width: 40,
                      height: 40,
                    )
                  : Text(
                      value,
                      style: TextStyle(
                        fontSize: 12,
                        color: color,
                        decoration: isClickable
                            ? TextDecoration.underline
                            : TextDecoration.none,
                        decorationThickness: 2,
                        decorationColor: color,
                        decorationStyle: TextDecorationStyle.solid,
                      ),
                    )),
        ],
      ),
    );
  }
}
