import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tokosm_v2/cubit/cabang_cubit.dart';
import 'package:tokosm_v2/cubit/auth_cubit.dart';
import 'package:tokosm_v2/cubit/product_cubit.dart';
import 'package:tokosm_v2/cubit/wishlist_cubit.dart';
import 'package:tokosm_v2/model/product_model.dart';
import 'package:tokosm_v2/shared/themes.dart';
import 'package:tokosm_v2/shared/utils.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  var tabFilter = ["Terbaru", "Terlaris", "Termahal", "Termurah"];
  TextEditingController searchController = TextEditingController(text: "");

  @override
  void initState() {
    context.read<ProductCubit>().setSearchKeyword("");
    initWishlistProduct();
    super.initState();
  }

  void initWishlistProduct() async {
    context.read<WishlistCubit>().getWishlistProduct(
          token: context.read<AuthCubit>().state.loginModel.token ?? "",
          cabangId:
              context.read<CabangCubit>().state.selectedCabangData.id ?? 0,
          sort: tabFilter.first.toLowerCase(),
          page: 1,
          search: (context.read<ProductCubit>().state as ProductSuccess)
              .searchkeyword,
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
            // NOTE: header
            Text(
              "Produk Favorit",
              style: TextStyle(
                fontSize: 14,
                fontWeight: bold,
              ),
            ),

            const SizedBox(height: 20),

            // NOTE: search
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                        onFieldSubmitted: (value) {
                          context.read<ProductCubit>().setSearchKeyword(value);
                          context.read<WishlistCubit>().getWishlistProduct(
                                search: (context.read<ProductCubit>().state
                                        as ProductSuccess)
                                    .searchkeyword,
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
                                sort: tabFilter.first.toLowerCase(),
                                page: 1,
                                limit: 999999999,
                              );
                        },
                        controller: searchController,
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

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (var i = 0; i < tabFilter.length; i++) ...{
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        context.read<WishlistCubit>().setTabIndex(i);
                        context.read<WishlistCubit>().getWishlistProduct(
                              search: (context.read<ProductCubit>().state
                                      as ProductSuccess)
                                  .searchkeyword,
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
                              sort: tabFilter.first.toLowerCase(),
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
                                          .read<WishlistCubit>()
                                          .state
                                          .tabIndex
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
                                    context.read<WishlistCubit>().state.tabIndex
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

    return BlocBuilder<WishlistCubit, WishlistState>(
      builder: (context, state) {
        return Scaffold(
          body: RefreshIndicator(
            color: colorSuccess,
            onRefresh: () async {
              initWishlistProduct();
            },
            child: SafeArea(
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
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: List.generate(
                                (context
                                            .read<WishlistCubit>()
                                            .state
                                            .wishlistProduct
                                            .data ??
                                        [])
                                    .length, (index) {
                              var product = context
                                  .read<WishlistCubit>()
                                  .state
                                  .wishlistProduct
                                  .data;

                              return _wishlistPageExtension().bigItemView(
                                context: context,
                                product: product?[index],
                              );
                            }),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ignore: camel_case_types
class _wishlistPageExtension {
  Widget bigItemView({
    required BuildContext context,
    required DataProduct? product,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    const horizontalPadding = 32; // 16 left + 16 right
    const spacing = 10;
    final itemWidth = (screenWidth - horizontalPadding - spacing) / 2;

    return GestureDetector(
      onTap: () {
        context
            .read<ProductCubit>()
            .selectProduct(product: product ?? DataProduct());
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
                            image: NetworkImage(
                              (product?.gambarProduk ?? []).isEmpty
                                  ? ""
                                  : (product?.gambarProduk ?? []).first,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      if ((product?.isPromo == 1
                              ? "${product?.namaPromo}"
                              : "") !=
                          "") ...{
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
                                  product?.isPromo == 1
                                      ? "${product?.namaPromo}"
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
                        ),
                      },
                    ],
                  ),
                ),
                Text(
                  product?.namaProduk ?? "",
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
                if (product?.isFlashsale == 1 &&
                    product?.satuanProduk != product?.flashsaleSatuan) ...{
                  Text(
                    "Rp ${formatNumber(product?.hargaProduk)}",
                    style: TextStyle(
                      fontSize: 12,
                      color: colorSuccess,
                      fontWeight: bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                },
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
                        "") ...{
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
                    },
                    if ((product?.isFlashsale == 1
                            ? "${product?.persentaseFlashsale}%"
                            : product?.isDiskon == 1
                                ? "${product?.persentaseDiskon}%"
                                : "") !=
                        "") ...{
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
                      if (product?.isFlashsale == 1) ...{
                        Container(
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
                      },
                    },
                  ],
                ),
              ],
            ),
            if ((product?.rating ?? "") != "") ...{
              Row(
                children: [
                  Icon(Icons.star, size: 12, color: colorWarning),
                  Text(
                    "${product?.rating ?? ""}",
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
}
