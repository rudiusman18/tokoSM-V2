import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tokosm_v2/cubit/login_cubit.dart';
import 'package:tokosm_v2/cubit/product_cubit.dart';
import 'package:tokosm_v2/shared/themes.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  var tabFilter = ["Populer", "Terlaris", "Terbaru", "Termahal", "Termurah"];

  @override
  void initState() {
    initProductData();
    super.initState();
  }

  void initProductData() async {
    context.read<ProductCubit>().productTabIndex(0);
    context.read<ProductCubit>().getAllProduct(
          token: context.read<LoginCubit>().state.loginModel.token ?? "",
          cabangId: 1,
          type: '',
          sort: tabFilter.first.toLowerCase(),
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
            // NOTE: Header
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    SolarIconsOutline.arrowLeft,
                  ),
                ),
                const SizedBox(
                  width: 10,
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
                const SizedBox(
                  width: 10,
                ),
                const Icon(
                  SolarIconsOutline.cartLarge2,
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    _ProductPageExtension().filterBottomSheet(context: context);
                  },
                  child: const Icon(
                    SolarIconsOutline.tuning_2,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (var i = 0; i < tabFilter.length; i++) ...{
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        context.read<ProductCubit>().productTabIndex(i);
                        context.read<ProductCubit>().getAllProduct(
                              token: context
                                      .read<LoginCubit>()
                                      .state
                                      .loginModel
                                      .token ??
                                  "",
                              cabangId: 1,
                              type: '',
                              sort: tabFilter[i].toLowerCase(),
                              page: 1,
                              limit: 999999999,
                            );
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                          bottom: 5,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: i ==
                                      context
                                          .read<ProductCubit>()
                                          .state
                                          .productTabIndex
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
                                        .read<ProductCubit>()
                                        .state
                                        .productTabIndex
                                ? Colors.black
                                : colorSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                },
              ],
            )
          ],
        ),
      );
    }

    return BlocBuilder<ProductCubit, ProductState>(
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
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView(
                    children: [
                      Center(
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: List.generate(
                              (context
                                          .read<ProductCubit>()
                                          .state
                                          .wildProduct
                                          .data ??
                                      [])
                                  .length, (index) {
                            var product = context
                                .read<ProductCubit>()
                                .state
                                .wildProduct
                                .data;
                            return _ProductPageExtension().bigItemView(
                              context: context,
                              imageURL:
                                  product?[index].gambarProduk?.first ?? "",
                              productName: product?[index].namaProduk ?? "",
                              productPrice: product?[index].isFlashsale == 1
                                  ? "Rp ${product?[index].hargaFlashsale}"
                                  : product?[index].isDiskon == 1
                                      ? "Rp ${product?[index].hargaDiskon}"
                                      : "Rp ${product?[index].hargaJual}",
                              discountPercentage: product?[index].isFlashsale ==
                                      1
                                  ? "${product?[index].persentaseFlashsale}%"
                                  : product?[index].isDiskon == 1
                                      ? "${product?[index].persentaseDiskon}%"
                                      : "",
                              productPriceColor: colorSuccess,
                              productRealPrice:
                                  product?[index].isFlashsale == 1 ||
                                          product?[index].isDiskon == 1
                                      ? "Rp ${product?[index].hargaJual}"
                                      : "",
                              bonusInformation: product?[index].isPromo == 1
                                  ? "${product?[index].namaPromo}"
                                  : "",
                              isFlashSale: product?[index].isFlashsale == 1
                                  ? true
                                  : false,
                              rating: product?[index].rating ?? "",
                            );
                          }),
                        ),
                      )
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

// ignore: camel_case_types
class _ProductPageExtension {
  Widget bigItemView({
    required BuildContext context,
    required String imageURL,
    required String productName,
    required String productPrice,
    required Color productPriceColor,
    required String discountPercentage,
    required String productRealPrice,
    required String bonusInformation,
    required String rating,
    bool isFlashSale = false,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    const horizontalPadding = 32; // 16 left + 16 right
    const spacing = 10;
    final itemWidth = (screenWidth - horizontalPadding - spacing) / 2;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, 'product/detail-product');
      },
      child: SizedBox(
        width: itemWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(imageURL),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      if (bonusInformation != "") ...{
                        Positioned(
                          bottom: 5,
                          left: 5,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: colorWarning,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              spacing: 2,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  SolarIconsBold.tag,
                                  size: 10,
                                  color: Colors.white,
                                ),
                                Text(
                                  bonusInformation,
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
                      },
                    ],
                  ),
                ),
                Text(
                  productName,
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  spacing: 10,
                  children: [
                    Flexible(
                      child: Text(
                        productPrice,
                        style: TextStyle(
                          fontSize: 12,
                          color: productPriceColor,
                          fontWeight: bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (productRealPrice != "") ...{
                      Text(
                        productRealPrice,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: bold,
                          decoration: TextDecoration.lineThrough,
                          decorationThickness: 3,
                        ),
                      ),
                    },
                    if (discountPercentage != "") ...{
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: colorError,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (isFlashSale)
                              const Icon(
                                SolarIconsBold.bolt,
                                size: 10,
                                color: Colors.white,
                              ),
                            Text(
                              discountPercentage,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    },
                  ],
                ),
              ],
            ),
            if (rating != "") ...{
              Row(
                children: [
                  Icon(Icons.star, size: 12, color: colorWarning),
                  Text(
                    rating,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            },
          ],
        ),
      ),
    );
  }

  Future<void> filterBottomSheet({required BuildContext context}) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          margin: const EdgeInsets.all(16),
          width: double.infinity,
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Filter",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: bold,
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
              //NOTE: Kategori
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Kategori",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: bold,
                        ),
                      ),
                      Text(
                        "Lihat Semua",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: bold,
                          color: colorSuccess,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              //NOTE: Promo
              Column(
                children: [
                  Text(
                    "Promo",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: bold,
                    ),
                  ),
                ],
              ),
              //NOTE: Rating
              Column(
                children: [
                  Text(
                    "Rating",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: bold,
                    ),
                  ),
                ],
              ),

              //NOTE: Harga
              Column(
                children: [
                  Text(
                    "Harga",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
