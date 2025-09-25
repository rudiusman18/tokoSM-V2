import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tokosm_v2/cubit/address_cubit.dart';
import 'package:tokosm_v2/cubit/auth_cubit.dart';
import 'package:tokosm_v2/cubit/cabang_cubit.dart';
import 'package:tokosm_v2/cubit/cart_cubit.dart';
import 'package:tokosm_v2/cubit/checkout_cubit.dart';
import 'package:tokosm_v2/cubit/page_cubit.dart';
import 'package:tokosm_v2/cubit/transaction_cubit.dart';
import 'package:tokosm_v2/model/address_model.dart';
import 'package:tokosm_v2/model/product_model.dart';
import 'package:tokosm_v2/shared/themes.dart';
import 'package:tokosm_v2/shared/utils.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String transactionNotes = "";
  Map<String, dynamic> productNotesController = {};

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initCheckout();
    });
    super.initState();
  }

  void initCheckout() async {
    context.read<CheckoutCubit>().setPaymentMethod(paymentMethod: "");

    Utils().loadingDialog(context: context);
    await context.read<AddressCubit>().getAddress(
        token: context.read<AuthCubit>().state.loginModel.token ?? "");

    await context.read<CheckoutCubit>().getCourier(
        token: context.read<AuthCubit>().state.loginModel.token ?? "",
        cabangID: context.read<CabangCubit>().state.selectedCabangData.id ?? 0);

    context.read<AddressCubit>().selectAddress(
            addressData:
                (context.read<AddressCubit>().state.addressModel?.data ?? [])
                    .firstWhere(
          (element) => element.isUtama == 1,
        ));

    Navigator.pop(context);

    if (context.read<AddressCubit>().state is AddressFailure) {
      Utils().scaffoldMessenger(context,
          (context.read<AddressCubit>().state as AddressFailure).error ?? "");
    }

    if (context.read<CheckoutCubit>().state is CheckoutFailure) {
      Utils().scaffoldMessenger(context,
          (context.read<CheckoutCubit>().state as CheckoutFailure).error ?? "");
    }
  }

  // view template untuk menampilkan produk
  Widget productListView() {
    return Container(
      margin: const EdgeInsets.only(
        top: 10,
        left: 16,
        right: 16,
      ),
      child: Column(
        spacing: 10,
        children: [
          for (var index = 0;
              index <
                  (context.read<CartCubit>().state.productToTransaction?.data ??
                          [])
                      .length;
              index++) ...{
            _CheckoutPageExtension().verticalSmallItemView(
                context: context,
                product: (context
                        .read<CartCubit>()
                        .state
                        .productToTransaction
                        ?.data ??
                    [])[index],
                prevNotes: productNotesController[
                        "${(context.read<CartCubit>().state.productToTransaction?.data ?? [])[index].namaProduk?.toLowerCase()}"] ??
                    "",
                completion: (productNotes) {
                  setState(() {
                    productNotesController[
                            "${(context.read<CartCubit>().state.productToTransaction?.data ?? [])[index].namaProduk?.toLowerCase()}"] =
                        productNotes;
                  });
                })
          },
        ],
      ),
    );
  }

  // view template untuk membuat item metode pembayaran
  Widget paymentMethodItemView({
    required String imageURL,
    required String name,
  }) {
    return GestureDetector(
      onTap: () {
        context
            .read<CheckoutCubit>()
            .setPaymentMethod(paymentMethod: name.toLowerCase());
      },
      child: Column(
        spacing: 10,
        children: [
          Row(
            spacing: 5,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      imageURL,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
              Icon(
                context
                            .read<CheckoutCubit>()
                            .state
                            .paymentMethod
                            ?.toLowerCase() !=
                        name.toLowerCase()
                    ? Icons.radio_button_off
                    : Icons.radio_button_checked, //radio_button_checked
                color: colorSuccess,
                size: 24,
              ),
            ],
          ),
          const Divider(
            height: 1,
          ),
        ],
      ),
    );
  }

  // View template untuk membuat rincian pembayaran
  Widget paymentDetailView({required String name, required String value}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            name,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            color: value.contains("-") ? colorError : Colors.black,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutCubit, CheckoutState>(
      builder: (context, state) {
        return BlocBuilder<AddressCubit, AddressState>(
          builder: (context, state) {
            return Scaffold(
              body: SafeArea(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: Column(
                    spacing: 10,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: Row(
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
                            Expanded(
                              child: Text(
                                'Checkout',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 3,
                        color: Colors.grey.withAlpha(90),
                      ),
                      Expanded(
                        child: ListView(
                          children: [
                            // NOTE: ALAMAT
                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(context, "address");
                                      },
                                      child: _CheckoutPageExtension()
                                          .addressItemView(context),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.chevron_right,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 10,
                              color: Colors.grey.withAlpha(90),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                top: 10,
                                left: 16,
                                right: 16,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                spacing: 5,
                                children: [
                                  const Icon(
                                    SolarIconsOutline.shopMinimalistic,
                                    size: 18,
                                  ),
                                  Text(
                                    "Cabang ${context.read<CabangCubit>().state.selectedCabangData.namaCabang?.replaceAll("Cab ", "")}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            productListView(),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 2,
                              color: Colors.grey.withAlpha(90),
                            ),

                            //NOTE: catatan toko
                            const SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                TextEditingController
                                    transactionNotesController =
                                    TextEditingController(text: "");
                                transactionNotesController.text =
                                    transactionNotes;
                                Utils().customBottomSheet(
                                  context,
                                  Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 16,
                                    ),
                                    child: Column(
                                      spacing: 10,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          spacing: 5,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "Catatan Toko",
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
                                        Container(
                                          height: 100,
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          child: TextFormField(
                                            maxLines: 5,
                                            autocorrect: false,
                                            controller:
                                                transactionNotesController,
                                            cursorColor: Colors.black,
                                            decoration:
                                                const InputDecoration.collapsed(
                                              hintText: "Tulis Catatan",
                                              focusColor: Colors.black,
                                              hintStyle:
                                                  TextStyle(fontSize: 14),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                transactionNotes =
                                                    transactionNotesController
                                                        .text;
                                                Navigator.pop(context);
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                                foregroundColor: colorSuccess,
                                                backgroundColor: colorSuccess,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadiusGeometry
                                                          .circular(
                                                    10,
                                                  ),
                                                )),
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
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Row(
                                  spacing: 5,
                                  children: [
                                    Text(
                                      "Catatan Toko",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: bold,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        transactionNotes == ""
                                            ? "..."
                                            : transactionNotes,
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                        textAlign: TextAlign.end,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.chevron_right,
                                      size: 18,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // NOTE: Pengiriman
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Row(
                                spacing: 5,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Pengiriman",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: bold,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Utils().customBottomSheet(
                                          context,
                                          _CheckoutPageExtension()
                                              .courierView());
                                    },
                                    child: const Text(
                                      "Lihat Semua",
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.chevron_right,
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                Utils().customBottomSheet(context,
                                    _CheckoutPageExtension().courierView());
                              },
                              child: Container(
                                padding: const EdgeInsets.all(
                                  10,
                                ),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: colorSuccess.withAlpha(50),
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "${context.read<CheckoutCubit>().state.selectedCourier?["data"].first["nama"]}",
                                            style: TextStyle(
                                              fontWeight: bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "Rp ${formatNumber(context.read<CheckoutCubit>().state.selectedCourier?["data"].first["layanan"].first["biaya"] ?? 0)}",
                                          style: TextStyle(
                                            fontWeight: bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "${context.read<CheckoutCubit>().state.selectedCourier?["data"].first["layanan"].first["nama"]}",
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      "Estimasi tiba ${context.read<CheckoutCubit>().state.selectedCourier?["data"].first["layanan"].first["durasi"]}",
                                      style: const TextStyle(
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 10,
                              color: Colors.grey.withAlpha(90),
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            // NOTE: Metode Pembayaran
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 10,
                                children: [
                                  Text(
                                    "Metode Pembayaran",
                                    style: TextStyle(
                                      fontWeight: bold,
                                    ),
                                  ),
                                  Text(
                                    "Tunai",
                                    style: TextStyle(
                                      fontWeight: bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  paymentMethodItemView(
                                    imageURL:
                                        "https://images.tokopedia.net/img/payment/icons/cod.png",
                                    name: "COD",
                                  ),
                                  Text(
                                    "Bank Transfer",
                                    style: TextStyle(
                                      fontWeight: bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  paymentMethodItemView(
                                    imageURL:
                                        "https://images.tokopedia.net/img/payment/icons/bca.png",
                                    name: "Bank BCA",
                                  ),
                                  paymentMethodItemView(
                                    imageURL:
                                        "https://images.tokopedia.net/img/payment/icons/bri.png",
                                    name: "Bank BRI",
                                  ),
                                  paymentMethodItemView(
                                    imageURL:
                                        "https://images.tokopedia.net/img/payment/icons/mandiri.png",
                                    name: "Bank Mandiri",
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 10,
                              color: Colors.grey.withAlpha(90),
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            //NOTE: Rincian Pembayaran
                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Column(
                                spacing: 10,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Rincian Pembayaran",
                                    style: TextStyle(
                                      fontWeight: bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  paymentDetailView(
                                    name: "Total Harga",
                                    value: "Rp 88,000",
                                  ),
                                  paymentDetailView(
                                    name: "Total Ongkos Kirim",
                                    value: "Rp 88,000",
                                  ),
                                  paymentDetailView(
                                    name: "Total Diskon",
                                    value: "- Rp 88,000",
                                  ),
                                  const Divider(),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Total Pembayaran",
                                          style: TextStyle(
                                            fontWeight: bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "Rp ${formatNumber(context.read<CartCubit>().state.productPricestoTransaction?.fold(0, (a, b) => (a ?? 0) + b) ?? 0)}",
                                        style: TextStyle(
                                          fontWeight: bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          spacing: 10,
                          children: [
                            RichText(
                              text: TextSpan(
                                  text: "Total ",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                  children: [
                                    TextSpan(
                                      text:
                                          "Rp ${formatNumber(context.read<CartCubit>().state.productPricestoTransaction?.fold(0, (a, b) => (a ?? 0) + b) ?? 0)}",
                                      style: TextStyle(
                                        color: colorSuccess,
                                        fontWeight: bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ]),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if ((context
                                            .read<CheckoutCubit>()
                                            .state
                                            .paymentMethod ??
                                        "") !=
                                    "") {
                                  Utils().loadingDialog(context: context);
                                  await context
                                      .read<TransactionCubit>()
                                      .postTransaction(
                                        token: context
                                                .read<AuthCubit>()
                                                .state
                                                .loginModel
                                                .token ??
                                            "",
                                        cabangId:
                                            "${context.read<CabangCubit>().state.selectedCabangData.id}",
                                        userId:
                                            "${context.read<AuthCubit>().state.loginModel.data?.id}",
                                        username:
                                            "${context.read<AuthCubit>().state.loginModel.data?.namaPelanggan}",
                                        total:
                                            "${(context.read<CartCubit>().state.productPricestoTransaction?.fold(0, (a, b) => (a) + b) ?? 0)}",
                                        paymentMethod: context
                                                .read<CheckoutCubit>()
                                                .state
                                                .paymentMethod ??
                                            "",
                                        addressID:
                                            "${context.read<AddressCubit>().state.selectedAddressModel?.id}",
                                        products: context
                                                .read<CartCubit>()
                                                .state
                                                .productToTransaction
                                                ?.data ??
                                            [],
                                        courier:
                                            "${context.read<CheckoutCubit>().state.selectedCourier?["data"].first["id"]}",
                                        courierService:
                                            "${context.read<CheckoutCubit>().state.selectedCourier?["data"].first["layanan"].first["nama"]}",
                                        productNotes: productNotesController,
                                        transactionNotes: transactionNotes,
                                      );

                                  Navigator.pop(context);
                                  if (context.read<TransactionCubit>().state
                                      is TransactionFailure) {
                                    Utils().scaffoldMessenger(
                                        context,
                                        (context.read<TransactionCubit>().state
                                                as TransactionFailure)
                                            .error);
                                  } else if (context
                                      .read<TransactionCubit>()
                                      .state is TransactionSuccess) {
                                    context.read<PageCubit>().setPage(3);
                                    Navigator.popUntil(context,
                                        ModalRoute.withName('main-page'));
                                  }
                                } else {
                                  Utils().scaffoldMessenger(context,
                                      "Silahkan pilih metode pembayaran terlebih dahulu");
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorSuccess,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadiusGeometry.circular(
                                    10,
                                  ),
                                ),
                              ),
                              child: const Text(
                                "Buat Pesanan",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _CheckoutPageExtension {
  Widget courierView() {
    return StatefulBuilder(
      builder: (context, setState) {
        return IntrinsicHeight(
          child: Container(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 10,
            ),
            width: double.infinity,
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Opsi Pengiriman",
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
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var data in (context
                                .read<CheckoutCubit>()
                                .state
                                .courierModel?["data"] ??
                            [])) ...[
                          // NOTE: Nama Kurir
                          Text(
                            "${data["nama"]}",
                            style: TextStyle(
                              fontWeight: bold,
                            ),
                          ),
                          for (var service in (data?["layanan"] ?? [])) ...{
                            // NOTE: layanan kurir
                            GestureDetector(
                              onTap: () {
                                setState(
                                  () {
                                    var selectedCourier = <String, dynamic>{
                                      ...context
                                              .read<CheckoutCubit>()
                                              .state
                                              .courierModel ??
                                          {}
                                    };

                                    selectedCourier["data"] = [
                                      <String, dynamic>{...data}
                                    ];
                                    selectedCourier["data"].first["layanan"] = [
                                      service
                                    ];

                                    context.read<CheckoutCubit>().selectCourier(
                                        selectedCourier: selectedCourier);

                                    Navigator.pop(context);
                                  },
                                );
                              },
                              child: Container(
                                color: Colors.transparent,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${service["nama"]} (Rp ${formatNumber(service["biaya"] ?? 0)})",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: bold,
                                            ),
                                          ),
                                          Text(
                                            "Estimasi tiba ${service["durasi"]}",
                                            style: const TextStyle(
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      "${data["nama"]}${service["nama"]}" ==
                                              "${context.read<CheckoutCubit>().state.selectedCourier?["data"].first["nama"]}${context.read<CheckoutCubit>().state.selectedCourier?["data"].first["layanan"].first["nama"]}"
                                          ? Icons.radio_button_checked
                                          : Icons.radio_button_off,
                                      color: colorSuccess,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                          },
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget addressItemView(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        const Icon(
          SolarIconsOutline.mapPoint,
          size: 24,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          "${context.read<AddressCubit>().state.selectedAddressModel?.namaAlamat}",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: bold,
                      ),
                    ),
                    TextSpan(
                      text:
                          " | ${context.read<AddressCubit>().state.selectedAddressModel?.telpPenerima}",
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Text(
                "${context.read<AddressCubit>().state.selectedAddressModel?.alamatLengkap ?? ""}, ${context.read<AddressCubit>().state.selectedAddressModel?.kelurahan ?? ""}, ${context.read<AddressCubit>().state.selectedAddressModel?.kecamatan ?? ""}, ${context.read<AddressCubit>().state.selectedAddressModel?.kabkota ?? ""}, ${context.read<AddressCubit>().state.selectedAddressModel?.provinsi ?? ""}\n${context.read<AddressCubit>().state.selectedAddressModel?.kodepos ?? ""}",
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget verticalSmallItemView({
    required BuildContext context,
    required DataProduct? product,
    required String prevNotes,
    required Function(String) completion,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar produk (pakai Stack biar bisa ada promo badge)
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(
                  (product?.gambarProduk ?? []).isEmpty
                      ? ""
                      : (product?.gambarProduk ?? []).first,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(width: 8), // jarak antara gambar dan teks

          // Bagian teks
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Nama produk
                Text(
                  product?.namaProduk ?? "",
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),

                // Jika flashsale + satuan berbeda → tampilkan harga normal dulu
                if (product?.isFlashsale == 1 &&
                    product?.satuanProduk != product?.flashsaleSatuan)
                  Text(
                    "Rp ${formatNumber(product?.hargaProduk)}",
                    style: TextStyle(
                      fontSize: 12,
                      color: colorSuccess,
                      fontWeight: bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),

                // Harga + diskon + persentase
                Row(
                  spacing: 5,
                  children: [
                    Flexible(
                      child: Text(
                        product?.isFlashsale == 1
                            ? "Rp ${formatNumber(product?.hargaDiskonFlashsale ?? 0)}"
                            : product?.isDiskon == 1
                                ? "Rp ${formatNumber(product?.hargaDiskon)}"
                                : "Rp ${formatNumber(product?.hargaProduk)}",
                        style: TextStyle(
                          fontSize: 12,
                          color: product?.isFlashsale == 1
                              ? colorError
                              : colorSuccess,
                          fontWeight: bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if ((product?.isFlashsale == 1 || product?.isDiskon == 1
                            ? "Rp ${formatNumber(product?.hargaProduk)}"
                            : "") !=
                        "")
                      Text(
                        product?.isFlashsale == 1
                            ? "Rp ${formatNumber(product?.hargaProdukFlashsale ?? 0)}"
                            : product?.isDiskon == 1
                                ? "Rp ${formatNumber(product?.hargaDiskon ?? 0)}"
                                : "",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: bold,
                          decoration: TextDecoration.lineThrough,
                          decorationThickness: 3,
                        ),
                      ),
                    if ((product?.isFlashsale == 1
                            ? "${product?.persentaseFlashsale}%"
                            : product?.isDiskon == 1
                                ? "${product?.persentaseDiskon}%"
                                : "") !=
                        "")
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: colorError,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (product?.isFlashsale == 1)
                                  const Icon(
                                    SolarIconsBold.bolt,
                                    size: 10,
                                    color: Colors.white,
                                  ),
                                Text(
                                  product?.isFlashsale == 1
                                      ? "${product?.persentaseFlashsale}%"
                                      : product?.isDiskon == 1
                                          ? "${product?.persentaseDiskon}%"
                                          : "",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (product?.isFlashsale == 1)
                            Container(
                              margin: const EdgeInsets.only(left: 4),
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                product?.flashsaleSatuan ?? "",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                  ],
                ),

                // Rating
                if ((product?.rating ?? "") != "")
                  Row(
                    children: [
                      Icon(Icons.star, size: 12, color: colorWarning),
                      Text(
                        "${product?.rating ?? ""}",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),

                // Promo badge
                if ((product?.isPromo == 1 ? "${product?.namaPromo}" : "") !=
                    "")
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: colorWarning,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      spacing: 2,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          SolarIconsBold.tag,
                          size: 10,
                          color: Colors.white,
                        ),
                        Text(
                          product?.namaPromo ?? "",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: () {
                    TextEditingController productNotesController =
                        TextEditingController(text: prevNotes);
                    Utils().customBottomSheet(
                      context,
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 16,
                        ),
                        child: Column(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 5,
                              children: [
                                Expanded(
                                  child: Text(
                                    "Catatan Produk (${product?.namaProduk})",
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
                            Container(
                              height: 100,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                              ),
                              child: TextFormField(
                                maxLines: 5,
                                autocorrect: false,
                                controller: productNotesController,
                                cursorColor: Colors.black,
                                decoration: const InputDecoration.collapsed(
                                  hintText: "Tulis Catatan",
                                  focusColor: Colors.black,
                                  hintStyle: TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  completion(productNotesController.text);
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                    foregroundColor: colorSuccess,
                                    backgroundColor: colorSuccess,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadiusGeometry.circular(
                                        10,
                                      ),
                                    )),
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
                  },
                  child: Row(
                    spacing: 5,
                    children: [
                      const Icon(
                        SolarIconsOutline.penNewSquare,
                        size: 14,
                      ),
                      Expanded(
                        child: Text(
                          prevNotes == "" ? "..." : prevNotes,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // jumlah barang
          Container(
            alignment: Alignment.bottomRight,
            child: Row(
              spacing: 5,
              children: [
                // for loop untuk multisatuan
                for (var index = 0;
                    index < (product?.multisatuanJumlah ?? []).length;
                    index++) ...{
                  Text(
                    "(${product?.jumlahMultisatuan?[index]}${product?.multisatuanUnit?[index]})",
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                },
                Text(
                  "x${product?.jumlah}",
                  style: TextStyle(
                    fontWeight: bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
