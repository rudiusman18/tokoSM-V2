import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tokosm_v2/cubit/cabang_cubit.dart';
import 'package:tokosm_v2/cubit/auth_cubit.dart';
import 'package:tokosm_v2/cubit/cart_cubit.dart';
import 'package:tokosm_v2/cubit/product_cubit.dart';
import 'package:tokosm_v2/cubit/review_cubit.dart';
import 'package:tokosm_v2/model/product_model.dart';
import 'package:tokosm_v2/shared/themes.dart';
import 'package:tokosm_v2/shared/utils.dart';

class DetailProductPage extends StatefulWidget {
  const DetailProductPage({super.key});

  @override
  State<DetailProductPage> createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
  DetailProductModel detailProductModel = DetailProductModel();
  TextEditingController searchController = TextEditingController(text: "");

  bool enableLoading = false;

  @override
  void initState() {
    initDetailProduct();
    super.initState();
  }

  void initDetailProduct() {
    // mendapatkan data product
    context.read<CartCubit>().setProductAmount(productAmount: []);

    var product =
        (context.read<ProductCubit>().state as ProductSuccess).detailProduct ??
            DataProduct();

    context.read<DetailProductCubit>().getDetailproduct(
          token: context.read<AuthCubit>().state.loginModel.token ?? "",
          cabangId:
              context.read<CabangCubit>().state.selectedCabangData.id ?? 0,
          productId: "${product.id}",
        );

    // mendapatkan data review
    context.read<ReviewCubit>().getReviewProduct(
        token: context.read<AuthCubit>().state.loginModel.token ?? "",
        productID: "${product.id}");
  }

  @override
  Widget build(BuildContext context) {
    Widget header() {
      return Container(
        margin: const EdgeInsets.only(top: 10),
        child: Row(
          spacing: 10,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                SolarIconsOutline.arrowLeft,
                size: 24,
              ),
            ),
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
                          controller: searchController,
                          onFieldSubmitted: (value) {
                            if (value != "") {
                              context
                                  .read<ProductCubit>()
                                  .setSearchKeyword(searchController.text);
                              searchController.text = "";
                              Navigator.pushNamed(context, 'product-page');
                            }
                          },
                          style: const TextStyle(fontSize: 12),
                          decoration: const InputDecoration.collapsed(
                            hintText: "Cari Produk",
                            hintStyle: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "cart");
              },
              child: const Icon(
                SolarIconsOutline.cartLarge2,
              ),
            ),
          ],
        ),
      );
    }

    return BlocBuilder<ReviewCubit, ReviewState>(
      builder: (context, state) {
        return BlocConsumer<DetailProductCubit, DetailProductState>(
          listener: (context, state) {
            if (state is DetailProductLoading) {
              Utils().loadingDialog(context: context);
              enableLoading = true;
            }

            if (state is DetailProductSuccess) {
              if (enableLoading == true) {
                enableLoading = false;
                Navigator.pop(context);
              }
            }
          },
          builder: (context, state) {
            detailProductModel =
                context.read<DetailProductCubit>().state.detailProductModel;
            var product = detailProductModel.data ??
                (context.read<ProductCubit>().state as ProductSuccess)
                    .detailProduct ??
                DataProduct();

            return Scaffold(
              body: RefreshIndicator(
                color: colorSuccess,
                onRefresh: () async {
                  initDetailProduct();
                },
                child: SafeArea(
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: header(),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: ListView(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  height: 390,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        product.gambarProduk?.first ?? "",
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                if (product.isFlashsale == 1) ...{
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      color: colorError,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Wrap(
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            children: [
                                              Text(
                                                "Fla",
                                                style: TextStyle(
                                                  fontWeight: bold,
                                                  fontStyle: FontStyle.italic,
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              const Icon(
                                                SolarIconsBold.bolt,
                                                size: 12,
                                                color: Colors.white,
                                              ),
                                              Text(
                                                "h Sale",
                                                style: TextStyle(
                                                  fontWeight: bold,
                                                  fontStyle: FontStyle.italic,
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            "Berakhir ${Utils().formatTanggal(product.flashsaleEnd ?? "")}",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: bold,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                }
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    spacing: 10,
                                    children: [
                                      Text(
                                        "Rp ${formatNumber(product.isFlashsale == 1 ? product.hargaDiskonFlashsale : product.isDiskon == 1 ? product.hargaDiskon : product.hargaProduk)}",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: bold,
                                          color: colorError,
                                        ),
                                      ),
                                      if (product.isFlashsale == 1 ||
                                          product.isDiskon == 1) ...{
                                        Text(
                                          "Rp ${formatNumber(product.hargaProduk)}",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                            decoration:
                                                TextDecoration.lineThrough,
                                            decorationThickness: 3,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            color: colorError,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Text(
                                            "${product.isFlashsale == 1 ? product.persentaseFlashsale : product.isDiskon == 1 ? product.persentaseDiskon : ""}%",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                        )
                                      },
                                    ],
                                  ),
                                  if (product.keteranganPromo != null) ...{
                                    Container(
                                      padding: const EdgeInsets.all(
                                        5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: colorWarning.withAlpha(30),
                                      ),
                                      child: Text(
                                        "${product.keteranganPromo}",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.orange,
                                        ),
                                      ),
                                    ),
                                  },
                                  if (product.isFlashsale == 1) ...{
                                    Row(
                                      spacing: 10,
                                      children: [
                                        Expanded(
                                          // terjual/limit
                                          child: LinearProgressIndicator(
                                            value: double.parse(
                                                    "${(product.flashsaleLimit ?? 0) - (product.hargaProduk ?? 0)}") /
                                                100, // Ensure it stays between 0 and 1
                                            minHeight: 10,
                                            borderRadius:
                                                BorderRadius.circular(999),
                                            backgroundColor: Colors.grey[300],
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    colorError),
                                          ),
                                        ),
                                        Text(
                                          // limit - terjual
                                          "Tersisa ${(product.flashsaleLimit ?? 0) - (product.flashsaleTerjual ?? 0)} ${product.flashsaleSatuan}",
                                          style: const TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  },
                                  Text(
                                    "${product.namaProduk}",
                                    style: TextStyle(
                                      fontWeight: bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      if ((product.rating ?? 0) != 0) ...{
                                        Icon(
                                          Icons.star,
                                          color: colorWarning,
                                          size: 14,
                                        ),
                                        Text(
                                          "${product.rating ?? 0}",
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Text(
                                          "|",
                                        ),
                                        // ignore: equal_elements_in_set
                                        const SizedBox(
                                          width: 10,
                                        ),
                                      },
                                      const Text(
                                        "88 Terjual",
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
                              color: greyBase300,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Detail Produk",
                                    style: TextStyle(
                                      fontWeight: bold,
                                    ),
                                  ),
                                  _DetailProductExtension().detailProductItem(
                                      title: "Merk",
                                      value: "${product.merkProduk}"),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  _DetailProductExtension().detailProductItem(
                                      title: "Satuan",
                                      value: "${product.satuanProduk}"),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  _DetailProductExtension().detailProductItem(
                                      title: "Kategori",
                                      value: product.kategoriProduk ??
                                          "tidak ada kategori"),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  _DetailProductExtension().detailProductItem(
                                    title: "Grosir",
                                    value: product.grosirProduk ?? "Tidak ada",
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    "Deskripsi Produk",
                                    style: TextStyle(
                                      fontWeight: bold,
                                    ),
                                  ),
                                  Text(
                                    product.deskripsiProduk ??
                                        "Tidak ada deskripsi",
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 5,
                              color: greyBase300,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                spacing: 10,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    spacing: 10,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Ulasan Produk",
                                        style: TextStyle(
                                          fontWeight: bold,
                                        ),
                                      ),
                                      _DetailProductExtension().allButtonView(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, "product/all-review");
                                        },
                                      ),
                                    ],
                                  ),
                                  if (context.read<ReviewCubit>().state
                                          is! ReviewLoading &&
                                      context
                                              .read<ReviewCubit>()
                                              .state
                                              .reviewModel ==
                                          null) ...{
                                    const Center(
                                      child: Text(
                                        "Tidak ada ulasan",
                                      ),
                                    ),
                                  } else ...{
                                    for (var i = 0;
                                        i <
                                            ((context
                                                                    .read<
                                                                        ReviewCubit>()
                                                                    .state
                                                                    .reviewModel?[
                                                                "data"] ??
                                                            [])
                                                        .length >
                                                    5
                                                ? 5
                                                : (context
                                                            .read<ReviewCubit>()
                                                            .state
                                                            .reviewModel?["data"] ??
                                                        [])
                                                    .length);
                                        i++) ...{
                                      _DetailProductExtension().reviewItem(
                                        imageURL: "",
                                        reviewerName:
                                            "${(context.read<ReviewCubit>().state.reviewModel?["data"] ?? [])[i]["nama_pelanggan"]}",
                                        dateString: Utils().formatTanggal(
                                            "${(context.read<ReviewCubit>().state.reviewModel?["data"] ?? [])[i]["created_at"]}"),
                                        star:
                                            "${(context.read<ReviewCubit>().state.reviewModel?["data"] ?? [])[i]["rating"]}",
                                        commentString:
                                            "${(context.read<ReviewCubit>().state.reviewModel?["data"] ?? [])[i]["ulasan"]}",
                                      ),
                                    },
                                  },
                                  const SizedBox(
                                    height: 120,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (product.isMultisatuan == 1) {
                            // multisatuan
                            showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                List<int> productAmount = [];

                                if ((context
                                            .read<CartCubit>()
                                            .state
                                            .productAmount ??
                                        [])
                                    .isNotEmpty) {
                                  productAmount.addAll(List<int>.from(context
                                          .read<CartCubit>()
                                          .state
                                          .productAmount ??
                                      []));
                                } else {
                                  productAmount.addAll(
                                    List.filled(
                                        (product.multisatuanJumlah ?? [])
                                            .length,
                                        0),
                                  );

                                  context.read<CartCubit>().setProductAmount(
                                        productAmount: List.filled(
                                            (product.multisatuanJumlah ?? [])
                                                .length,
                                            0),
                                      ); //Mengisi data kosong
                                }

                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          margin: const EdgeInsets.all(
                                            20,
                                          ),
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(
                                                10,
                                              ),
                                            ),
                                          ),
                                          child: Column(
                                            spacing: 5,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              for (var i = 0;
                                                  i <
                                                      (product.multisatuanJumlah ??
                                                              [])
                                                          .length;
                                                  i++) ...{
                                                // NOTE: content multisatuan
                                                Row(
                                                  spacing: 5,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        "${product.multisatuanUnit?[i]} (${product.multisatuanJumlah?[i]})",
                                                      ),
                                                    ),
                                                    // NOTE: kurang
                                                    GestureDetector(
                                                      onTap: () {
                                                        if (context
                                                                .read<
                                                                    CartCubit>()
                                                                .state
                                                                .productAmount?[i] !=
                                                            0) {
                                                          setState(() {
                                                            productAmount[
                                                                i] = (context
                                                                        .read<
                                                                            CartCubit>()
                                                                        .state
                                                                        .productAmount?[i] ??
                                                                    0) -
                                                                1;

                                                            context
                                                                .read<
                                                                    CartCubit>()
                                                                .setProductAmount(
                                                                  productAmount:
                                                                      productAmount,
                                                                );
                                                          });
                                                        }
                                                      },
                                                      child: Container(
                                                        width: 25,
                                                        height: 25,
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: greyBase300,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                        ),
                                                        child: const Text(
                                                          "-",
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      "${productAmount[i]}",
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    // NOTE: tambah
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          productAmount[
                                                              i] = (context
                                                                      .read<
                                                                          CartCubit>()
                                                                      .state
                                                                      .productAmount?[i] ??
                                                                  0) +
                                                              1;

                                                          context
                                                              .read<CartCubit>()
                                                              .setProductAmount(
                                                                productAmount:
                                                                    productAmount,
                                                              );
                                                        });
                                                      },
                                                      child: Container(
                                                        width: 25,
                                                        height: 25,
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: colorSuccess,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
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
                                                ),
                                              },
                                              const SizedBox(
                                                height: 12,
                                              ),
                                              Row(
                                                spacing: 10,
                                                children: [
                                                  Expanded(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Container(
                                                        width: double.infinity,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 10,
                                                          vertical: 10,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  colorSuccess),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                        ),
                                                        child: Text(
                                                          "Batal",
                                                          style: TextStyle(
                                                            color: colorSuccess,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: GestureDetector(
                                                      onTap: () async {
                                                        if ((product?.jumlahMultisatuan ??
                                                                [])
                                                            .every((element) =>
                                                                element <= 0)) {

                                                                  Utils().scaffoldMessenger(context, "Silahkan");
                                                        } else {
                                                          Utils().loadingDialog(
                                                              context: context);
                                                          await context
                                                              .read<CartCubit>()
                                                              .addCart(
                                                                token: context
                                                                        .read<
                                                                            AuthCubit>()
                                                                        .state
                                                                        .loginModel
                                                                        .token ??
                                                                    "",
                                                                cabangId: context
                                                                        .read<
                                                                            CabangCubit>()
                                                                        .state
                                                                        .selectedCabangData
                                                                        .id ??
                                                                    0,
                                                                productId:
                                                                    product.id,
                                                                isMultiCart:
                                                                    true,
                                                                amount: null,
                                                                jumlahmultiSatuan: context
                                                                    .read<
                                                                        CartCubit>()
                                                                    .state
                                                                    .productAmount,
                                                                multisatuanJumlah: ((product
                                                                            .multisatuanJumlah ??
                                                                        [])
                                                                    .map((e) =>
                                                                        int.tryParse(
                                                                            e) ??
                                                                        0)).toList(),
                                                                multisatuanUnit:
                                                                    product
                                                                        .multisatuanUnit,
                                                              );

                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                          if (context
                                                                  .read<CartCubit>()
                                                                  .state
                                                              is CartSuccess) {
                                                            Navigator.pushNamed(
                                                                context,
                                                                'cart');
                                                          } else if (context
                                                                  .read<CartCubit>()
                                                                  .state
                                                              is CartFailure) {
                                                            Utils().scaffoldMessenger(
                                                                context,
                                                                "Gagal menambahkan produk ke keranjang");
                                                          }
                                                        }
                                                      },
                                                      child: Container(
                                                        width: double.infinity,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 10,
                                                          vertical: 10,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: colorSuccess,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                        ),
                                                        child: const Text(
                                                          "Simpan",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          } else {
                            // satuan
                            Utils().loadingDialog(context: context);
                            await context.read<CartCubit>().addCart(
                                  token: context
                                          .read<AuthCubit>()
                                          .state
                                          .loginModel
                                          .token ??
                                      "",
                                  cabangId: context
                                          .read<CabangCubit>()
                                          .state
                                          .selectedCabangData
                                          .id ??
                                      0,
                                  productId: product.id,
                                  isMultiCart: false,
                                  amount: 1,
                                  jumlahmultiSatuan: null,
                                  multisatuanJumlah: null,
                                  multisatuanUnit: null,
                                );
                            Navigator.pop(context);
                            if (context.read<CartCubit>().state
                                is CartSuccess) {
                              Navigator.pushNamed(context, 'cart');
                            } else if (context.read<CartCubit>().state
                                is CartFailure) {
                              Utils().scaffoldMessenger(context,
                                  "Gagal menambahkan produk ke keranjang");
                            }
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: colorSuccess,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Text(
                            "Masukkan Keranjang",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
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

class _DetailProductExtension {
  Widget allButtonView({required Function onTap}) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Text(
        "Lihat Semua",
        style: TextStyle(
          color: colorSuccess,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget detailProductItem({required String title, required value}) {
    return Column(
      spacing: 2,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 10,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        Divider(
          color: greyBase300,
          height: 2,
          thickness: 2,
        ),
      ],
    );
  }

  Widget reviewItem(
      {required String imageURL,
      required String reviewerName,
      required String dateString,
      required String star,
      required String commentString}) {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 5,
          children: [
            Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(
                  18,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reviewerName,
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  dateString,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        RatingBar.builder(
          ignoreGestures: true,
          initialRating: double.parse(star),
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemSize: 14,
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: colorWarning,
          ),
          onRatingUpdate: (rating) {
            // print(rating);
          },
        ),
        Text(
          commentString,
          style: const TextStyle(fontSize: 12),
        ),
        Divider(
          color: greyBase300,
          height: 2,
          thickness: 2,
        ),
      ],
    );
  }
}
