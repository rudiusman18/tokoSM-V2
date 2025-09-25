import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tokosm_v2/cubit/address_cubit.dart';
import 'package:tokosm_v2/cubit/auth_cubit.dart';
import 'package:tokosm_v2/cubit/cabang_cubit.dart';
import 'package:tokosm_v2/cubit/cart_cubit.dart';
import 'package:tokosm_v2/cubit/page_cubit.dart';
import 'package:tokosm_v2/cubit/product_cubit.dart';
import 'package:tokosm_v2/model/product_model.dart';
import 'package:tokosm_v2/shared/themes.dart';
import 'package:tokosm_v2/shared/utils.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    initialCartData();
    super.initState();
  }

  void initialCartData() {
    context.read<CartCubit>().cartProducttoTransaction(
        product: ProductModel(message: "success", data: []));
    context.read<CartCubit>().getCart(
          token: context.read<AuthCubit>().state.loginModel.token ?? "",
          cabangID:
              context.read<CabangCubit>().state.selectedCabangData.id ?? 0,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CabangCubit, CabangState>(
      builder: (context, state) {
        return BlocBuilder<CartCubit, CartState>(
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
                          Expanded(
                            child: Text(
                              'Keranjang',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: bold,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              context.read<PageCubit>().setPage(2);
                              Navigator.popUntil(
                                  context, ModalRoute.withName('main-page'));
                            },
                            child: const Icon(
                              SolarIconsOutline.heart,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () async {
                          final List<String> listCabangName = (context
                                      .read<CabangCubit>()
                                      .state
                                      .cabangModel
                                      .data ??
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
                            await context.read<CabangCubit>().selectCabang(
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

                            initialCartData();
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
                        child: context.read<CartCubit>().state is CartLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: colorSuccess,
                                ),
                              )
                            : ListView(
                                children: [
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  for (var i = 0;
                                      i <
                                          (context
                                                      .read<CartCubit>()
                                                      .state
                                                      .productModel
                                                      ?.data ??
                                                  [])
                                              .length;
                                      i++) ...{
                                    _CartPageExtenion().verticalSmallItemView(
                                        context: context,
                                        product: context
                                            .read<CartCubit>()
                                            .state
                                            .productModel
                                            ?.data?[i]),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  }
                                ],
                              ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          spacing: 5,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (context
                                        .read<CartCubit>()
                                        .state
                                        .productModel
                                        ?.data
                                        ?.length ==
                                    context
                                        .read<CartCubit>()
                                        .state
                                        .productToTransaction
                                        ?.data
                                        ?.length) {
                                  context
                                      .read<CartCubit>()
                                      .cartProducttoTransaction(
                                          product: ProductModel(
                                        message: "success",
                                        data: [],
                                      ));
                                } else {
                                  context
                                      .read<CartCubit>()
                                      .cartProducttoTransaction(
                                        product: context
                                                .read<CartCubit>()
                                                .state
                                                .productModel ??
                                            ProductModel(
                                              message: "success",
                                              data: [],
                                            ),
                                      );
                                }
                              },
                              child: context
                                              .read<CartCubit>()
                                              .state
                                              .productModel
                                              ?.data
                                              ?.length ==
                                          context
                                              .read<CartCubit>()
                                              .state
                                              .productToTransaction
                                              ?.data
                                              ?.length &&
                                      (context
                                                  .read<CartCubit>()
                                                  .state
                                                  .productModel
                                                  ?.data ??
                                              [])
                                          .isNotEmpty
                                  ? Icon(
                                      SolarIconsBold.checkSquare,
                                      color: colorSuccess,
                                      size: 25,
                                    )
                                  : Container(
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                            ),
                            const Text(
                              "Semua",
                            ),
                            Expanded(
                              child: Text(
                                "Rp ${formatNumber(context.read<CartCubit>().state.productPricestoTransaction?.fold(0, (a, b) => (a ?? 0) + b) ?? 0)}",
                                style: TextStyle(
                                  fontWeight: bold,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if ((context
                                            .read<CartCubit>()
                                            .state
                                            .productPricestoTransaction
                                            ?.fold(0, (a, b) => a + b) ??
                                        0) !=
                                    0) {
                                  Navigator.pushNamed(context, "checkout");
                                } else {
                                  Utils().scaffoldMessenger(context,
                                      "Silahkan pilih produk terlebih dahulu");
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
                                "Beli",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
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

class _CartPageExtenion {
  Widget verticalSmallItemView({
    required BuildContext context,
    required DataProduct? product,
  }) {
    ProductModel dataProduct = ProductModel(message: "success", data: []);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              if (product != null) {
                dataProduct =
                    context.read<CartCubit>().state.productToTransaction ??
                        ProductModel(message: "success", data: []);

                if ((context
                            .read<CartCubit>()
                            .state
                            .productToTransaction
                            ?.data ??
                        [])
                    .where((element) => (element.id == product.id))
                    .toList()
                    .isNotEmpty) {
                  dataProduct.data
                      ?.removeWhere((element) => element.id == product.id);
                } else {
                  dataProduct.data?.add(product);
                }

                context
                    .read<CartCubit>()
                    .cartProducttoTransaction(product: dataProduct);
              }
            },
            child:
                (context.read<CartCubit>().state.productToTransaction?.data ??
                            [])
                        .where((element) => (element.id == product?.id))
                        .toList()
                        .isNotEmpty
                    ? Icon(
                        SolarIconsBold.checkSquare,
                        size: 25,
                        color: colorSuccess,
                      )
                    : Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                      ),
          ),

          const SizedBox(
            width: 10,
          ),

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

                const SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: () {
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
                                controller: TextEditingController(),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    spacing: 5,
                    children: [
                      // Promo badge
                      if ((product?.isPromo == 1
                              ? "${product?.namaPromo}"
                              : "") !=
                          "")
                        Flexible(
                          child: Container(
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
                        ),
                      const SizedBox(),
                      // jumlah barang
                      Row(
                        spacing: 5,
                        children: [
                          //NOTE: tambah dan kurang keranjang
                          if (product?.isMultisatuan == 1) ...{
                            // multi satuan

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              spacing: 5,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                for (var i = 0;
                                    i < (product?.multisatuanUnit ?? []).length;
                                    i++) ...{
                                  Row(
                                    spacing: 5,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "${product?.multisatuanUnit?[i] ?? "-"}(${product?.multisatuanJumlah?[i] ?? "-"})",
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      // NOTE: kurang
                                      GestureDetector(
                                        onTap: () {
                                          product?.jumlahMultisatuan?[i] =
                                              product.jumlahMultisatuan?[i] -
                                                          1 <
                                                      0
                                                  ? 0
                                                  : product.jumlahMultisatuan?[
                                                          i] -
                                                      1;

                                          if ((product?.jumlahMultisatuan ?? [])
                                              .every(
                                                  (element) => element <= 0)) {
                                            product?.jumlahMultisatuan?[i] = 1;
                                            Utils().alertDialog(
                                              context: context,
                                              function: () {
                                                Navigator.pop(context);
                                                context
                                                    .read<CartCubit>()
                                                    .deleteCart(
                                                      token: context
                                                              .read<AuthCubit>()
                                                              .state
                                                              .loginModel
                                                              .token ??
                                                          "",
                                                      cabangID: context
                                                              .read<
                                                                  CabangCubit>()
                                                              .state
                                                              .selectedCabangData
                                                              .id ??
                                                          0,
                                                      product: product ??
                                                          DataProduct(),
                                                    );
                                              },
                                              title: "Warning!",
                                              message:
                                                  "Data akan dihapus, apakah anda yakin?",
                                            );
                                          } else if (product
                                                  ?.jumlahMultisatuan?[i] >=
                                              0) {
                                            context
                                                .read<CartCubit>()
                                                .updateCart(
                                                    token: context
                                                            .read<AuthCubit>()
                                                            .state
                                                            .loginModel
                                                            .token ??
                                                        "",
                                                    product: product ??
                                                        DataProduct(),
                                                    cabangID: context
                                                            .read<CabangCubit>()
                                                            .state
                                                            .selectedCabangData
                                                            .id ??
                                                        0);
                                          }
                                        },
                                        child: Container(
                                          width: 25,
                                          height: 25,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: greyBase300,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: const Text(
                                            "-",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "${(product?.jumlahMultisatuan ?? [])[i]}",
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      // NOTE: tambah
                                      GestureDetector(
                                        onTap: () {
                                          product?.jumlahMultisatuan?[i] += 1;
                                          context.read<CartCubit>().updateCart(
                                              token: context
                                                      .read<AuthCubit>()
                                                      .state
                                                      .loginModel
                                                      .token ??
                                                  "",
                                              product: product ?? DataProduct(),
                                              cabangID: context
                                                      .read<CabangCubit>()
                                                      .state
                                                      .selectedCabangData
                                                      .id ??
                                                  0);
                                        },
                                        child: Container(
                                          width: 25,
                                          height: 25,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: colorSuccess,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: const Text(
                                            "+",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                }
                              ],
                            ),
                          } else ...{
                            // satuan
                            Row(
                              spacing: 5,
                              children: [
                                // NOTE: kurang
                                GestureDetector(
                                  onTap: () {
                                    product?.jumlah -= 1;
                                    if (product?.jumlah > 0) {
                                      context.read<CartCubit>().updateCart(
                                          token: context
                                                  .read<AuthCubit>()
                                                  .state
                                                  .loginModel
                                                  .token ??
                                              "",
                                          product: product ?? DataProduct(),
                                          cabangID: context
                                                  .read<CabangCubit>()
                                                  .state
                                                  .selectedCabangData
                                                  .id ??
                                              0);
                                    } else {
                                      product?.jumlah = 1;
                                      Utils().alertDialog(
                                        context: context,
                                        function: () {
                                          Navigator.pop(context);
                                          context.read<CartCubit>().deleteCart(
                                                token: context
                                                        .read<AuthCubit>()
                                                        .state
                                                        .loginModel
                                                        .token ??
                                                    "",
                                                cabangID: context
                                                        .read<CabangCubit>()
                                                        .state
                                                        .selectedCabangData
                                                        .id ??
                                                    0,
                                                product:
                                                    product ?? DataProduct(),
                                              );
                                        },
                                        title: "Warning!",
                                        message:
                                            "Data akan dihapus, apakah anda yakin?",
                                      );
                                    }
                                  },
                                  child: Container(
                                    width: 25,
                                    height: 25,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: greyBase300,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: const Text(
                                      "-",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                                Text(
                                  "${product?.jumlah}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                //NOTE: tambah
                                GestureDetector(
                                  onTap: () {
                                    product?.jumlah += 1;
                                    context.read<CartCubit>().updateCart(
                                        token: context
                                                .read<AuthCubit>()
                                                .state
                                                .loginModel
                                                .token ??
                                            "",
                                        product: product ?? DataProduct(),
                                        cabangID: context
                                                .read<CabangCubit>()
                                                .state
                                                .selectedCabangData
                                                .id ??
                                            0);
                                  },
                                  child: Container(
                                    width: 25,
                                    height: 25,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: colorSuccess,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: const Text(
                                      "+",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          },
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
    );
  }
}
