import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tokosm_v2/cubit/cabang_cubit.dart';
import 'package:tokosm_v2/cubit/category_cubit.dart';
import 'package:tokosm_v2/cubit/auth_cubit.dart';
import 'package:tokosm_v2/cubit/product_cubit.dart';
import 'package:tokosm_v2/model/product_model.dart';
import 'package:tokosm_v2/shared/themes.dart';
import 'package:tokosm_v2/shared/utils.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  var tabFilter = ["Populer", "Terlaris", "Terbaru", "Termahal", "Termurah"];

  TextEditingController searchController = TextEditingController(text: "");

  int productPageIndex = 1;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);

    searchController.text =
        (context.read<ProductCubit>().state as ProductSuccess).searchkeyword;
    initProductData();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    productPageIndex += 1;
    context.read<ProductCubit>().getAllProduct(
          token: context.read<AuthCubit>().state.loginModel.token ?? "",
          cabangId:
              context.read<CabangCubit>().state.selectedCabangData.id ?? 0,
          type: (context.read<ProductCubit>().state as ProductSuccess)
              .selectedPromoFilter,
          category: (context.read<ProductCubit>().state as ProductSuccess)
              .selectedCategoryFilter,
          minrating: (context.read<ProductCubit>().state as ProductSuccess)
              .selectedRatingFilter,
          maxprice: (context.read<ProductCubit>().state as ProductSuccess)
              .maxPriceFilter,
          minprice: (context.read<ProductCubit>().state as ProductSuccess)
              .minPriceFilter,
          page: productPageIndex,
          limit: 10,
          sort: tabFilter[context.read<ProductCubit>().state.productTabIndex]
              .toLowerCase(),
        );
  }

  void initProductData() async {
    context.read<ProductCubit>().getAllProduct(
          token: context.read<AuthCubit>().state.loginModel.token ?? "",
          cabangId:
              context.read<CabangCubit>().state.selectedCabangData.id ?? 0,
          type: (context.read<ProductCubit>().state as ProductSuccess)
              .selectedPromoFilter,
          category: (context.read<ProductCubit>().state as ProductSuccess)
              .selectedCategoryFilter,
          minrating: (context.read<ProductCubit>().state as ProductSuccess)
              .selectedRatingFilter,
          maxprice: (context.read<ProductCubit>().state as ProductSuccess)
              .maxPriceFilter,
          minprice: (context.read<ProductCubit>().state as ProductSuccess)
              .minPriceFilter,
          page: 1,
          limit: 10,
          sort: tabFilter[context.read<ProductCubit>().state.productTabIndex]
              .toLowerCase(),
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
                              onFieldSubmitted: (value) {
                                context
                                    .read<ProductCubit>()
                                    .setSearchKeyword(value);
                                context.read<ProductCubit>().getAllProduct(
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
                                      type: (context.read<ProductCubit>().state
                                              as ProductSuccess)
                                          .selectedPromoFilter,
                                      category: (context
                                              .read<ProductCubit>()
                                              .state as ProductSuccess)
                                          .selectedCategoryFilter,
                                      minrating: (context
                                              .read<ProductCubit>()
                                              .state as ProductSuccess)
                                          .selectedRatingFilter,
                                      maxprice: (context
                                              .read<ProductCubit>()
                                              .state as ProductSuccess)
                                          .maxPriceFilter,
                                      minprice: (context
                                              .read<ProductCubit>()
                                              .state as ProductSuccess)
                                          .minPriceFilter,
                                      page: 1,
                                      limit: 10,
                                      sort: tabFilter[context
                                              .read<ProductCubit>()
                                              .state
                                              .productTabIndex]
                                          .toLowerCase(),
                                    );
                              },
                              style: const TextStyle(fontSize: 12),
                              controller: searchController,
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
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "cart");
                  },
                  child: const Icon(
                    SolarIconsOutline.cartLarge2,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    _ProductPageExtension().filterBottomSheet(
                        context: context,
                        sortBy: tabFilter[context
                                .read<ProductCubit>()
                                .state
                                .productTabIndex]
                            .toLowerCase());
                  },
                  child: Stack(
                    children: [
                      const Icon(
                        SolarIconsOutline.tuning_2,
                      ),
                      (context.read<ProductCubit>().state is ProductSuccess)
                          ? (context.read<ProductCubit>().state
                                              as ProductSuccess)
                                          .selectedCategoryFilter !=
                                      "" ||
                                  (context.read<ProductCubit>().state
                                              as ProductSuccess)
                                          .maxPriceFilter !=
                                      "" ||
                                  (context.read<ProductCubit>().state
                                              as ProductSuccess)
                                          .minPriceFilter !=
                                      "" ||
                                  (context.read<ProductCubit>().state
                                              as ProductSuccess)
                                          .selectedPromoFilter !=
                                      "" ||
                                  (context.read<ProductCubit>().state
                                              as ProductSuccess)
                                          .selectedRatingFilter !=
                                      ""
                              ? Positioned(
                                  right: 1,
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                )
                              : const SizedBox()
                          : const SizedBox(),
                    ],
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
                        _scrollController.animateTo(
                          0, // posisi paling atas
                          duration: const Duration(
                              milliseconds: 500), // durasi animasi
                          curve: Curves.easeInOut, // efek animasi
                        );
                        productPageIndex = 1;
                        context.read<ProductCubit>().productTabIndex(i);
                        context.read<ProductCubit>().getAllProduct(
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
                              type: (context.read<ProductCubit>().state
                                      as ProductSuccess)
                                  .selectedPromoFilter,
                              category: (context.read<ProductCubit>().state
                                      as ProductSuccess)
                                  .selectedCategoryFilter,
                              minrating: (context.read<ProductCubit>().state
                                      as ProductSuccess)
                                  .selectedRatingFilter,
                              maxprice: (context.read<ProductCubit>().state
                                      as ProductSuccess)
                                  .maxPriceFilter,
                              minprice: (context.read<ProductCubit>().state
                                      as ProductSuccess)
                                  .minPriceFilter,
                              page: productPageIndex,
                              limit: 10,
                              sort: tabFilter[context
                                      .read<ProductCubit>()
                                      .state
                                      .productTabIndex]
                                  .toLowerCase(),
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
          body: RefreshIndicator(
            color: colorSuccess,
            onRefresh: () async {
              initProductData();
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
                        controller: _scrollController,
                        children: [
                          Wrap(
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
class _ProductPageExtension {
  var promoFilter = ["Flashsale", "Diskon", "Bundling & Hadiah"];
  var ratingFilter = ["5", "≥4", "≥3", "≥2", "≥1"];
  TextEditingController lowestPriceController = TextEditingController(text: "");
  TextEditingController highestPriceController =
      TextEditingController(text: "");
  FocusNode lowestPriceFocusNode = FocusNode();
  FocusNode highestPriceFocusNode = FocusNode();

  //NOTE: variable yang menerima input filter
  String selectedCategory = "";
  String selectedPromo = "";
  String selectedRating = "";

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

  Future<void> filterBottomSheet({
    required BuildContext context,
    required String sortBy,
  }) {
    final state = context.read<ProductCubit>().state as ProductSuccess;

    final slugs = state.selectedCategoryFilter == ""
        ? []
        : state.selectedCategoryFilter.split(',');

    List<Map<String, dynamic>> data = [];
    if (slugs.isNotEmpty) {
      data = slugs.map((slug) {
        final name = slug
            .split('_')
            .map((word) => word[0].toUpperCase() + word.substring(1))
            .join(' ');
        return {
          "kat2_slug": slug,
          "kat2": name,
        };
      }).toList();
    }

    context.read<CategoryCubit>().getProductCategory(
          token: context.read<AuthCubit>().state.loginModel.token ?? "",
          filter: 'populer',
          selectedCategory:
              (context.read<ProductCubit>().state as ProductSuccess)
                          .selectedCategoryFilter ==
                      ""
                  ? null
                  : data,
        );

    selectedCategory = (context.read<ProductCubit>().state as ProductSuccess)
        .selectedCategoryFilter;

    selectedPromo = (context.read<ProductCubit>().state as ProductSuccess)
        .selectedPromoFilter;

    selectedRating = (context.read<ProductCubit>().state as ProductSuccess)
        .selectedRatingFilter;

    lowestPriceController.text =
        (context.read<ProductCubit>().state as ProductSuccess).minPriceFilter;

    highestPriceController.text =
        (context.read<ProductCubit>().state as ProductSuccess).maxPriceFilter;

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: StatefulBuilder(
            builder: (BuildContext context, setState) {
              lowestPriceFocusNode.addListener(() {
                setState(() {}); // Rebuild to reflect focus change
              });

              highestPriceFocusNode.addListener(() {
                setState(() {});
              });

              return BlocBuilder<CategoryCubit, CategoryState>(
                builder: (context, state) {
                  return Container(
                    margin: const EdgeInsets.all(16),
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    width: double.infinity,
                    child: SingleChildScrollView(
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Kategori",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: bold,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          type: PageTransitionType.rightToLeft,
                                          child: CategoryFilterPage(
                                            selectedCategory: selectedCategory,
                                          ),
                                        ),
                                      ).then(
                                        (var category) {
                                          selectedCategory = category;

                                          final slugs = selectedCategory == ""
                                              ? []
                                              : selectedCategory.split(',');

                                          List<Map<String, dynamic>> data = [];
                                          if (slugs.isNotEmpty) {
                                            data = slugs.map((slug) {
                                              final name = slug
                                                  .split('_')
                                                  .map((word) =>
                                                      word[0].toUpperCase() +
                                                      word.substring(1))
                                                  .join(' ');
                                              return {
                                                "kat2_slug": slug,
                                                "kat2": name,
                                              };
                                            }).toList();
                                          }

                                          context
                                              .read<CategoryCubit>()
                                              .getProductCategory(
                                                token: context
                                                        .read<AuthCubit>()
                                                        .state
                                                        .loginModel
                                                        .token ??
                                                    "",
                                                filter: 'populer',
                                                selectedCategory: category == ""
                                                    ? null
                                                    : data,
                                              );
                                        },
                                      );
                                    },
                                    child: Text(
                                      "Lihat Semua",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: bold,
                                        color: colorSuccess,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Wrap(
                                children: [
                                  for (var index = 0;
                                      index <
                                          (((context
                                                      .read<CategoryCubit>()
                                                      .state
                                                      .categoryModel?["data"] ??
                                                  []) as List))
                                              .length;
                                      index++) ...{
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          var selectedCategoryList =
                                              selectedCategory != ""
                                                  ? selectedCategory.split(",")
                                                  : [];

                                          if (selectedCategoryList.contains(
                                              "${(((context.read<CategoryCubit>().state.categoryModel?["data"] as List).map((e) => e as Map<String, dynamic>).toList()[index]["kat2_slug"] ?? []))}"
                                                  .toLowerCase())) {
                                            selectedCategoryList.remove(
                                                "${(((context.read<CategoryCubit>().state.categoryModel?["data"] as List).map((e) => e as Map<String, dynamic>).toList()[index]["kat2_slug"] ?? []))}"
                                                    .toLowerCase());
                                          } else {
                                            selectedCategoryList.add(
                                                "${(((context.read<CategoryCubit>().state.categoryModel?["data"] as List).map((e) => e as Map<String, dynamic>).toList()[index]["kat2_slug"] ?? []))}"
                                                    .toLowerCase());
                                          }

                                          selectedCategory =
                                              selectedCategoryList.join(",");
                                        });
                                      },
                                      child: filterItem(
                                        cardColor: selectedCategory
                                                .split(",")
                                                .contains(
                                                    "${(((context.read<CategoryCubit>().state.categoryModel?["data"] as List).map((e) => e as Map<String, dynamic>).toList()[index]["kat2_slug"] ?? []))}"
                                                        .toLowerCase())
                                            ? Colors.black
                                            : null,
                                        name:
                                            "${(((context.read<CategoryCubit>().state.categoryModel?["data"] as List).map((e) => e as Map<String, dynamic>).toList()[index]["kat2"] ?? []))}",
                                      ),
                                    ),
                                  },
                                ],
                              ),
                            ],
                          ),
                          //NOTE: Promo
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Promo",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: bold,
                                ),
                              ),
                              Wrap(
                                children: [
                                  for (var index = 0;
                                      index < promoFilter.length;
                                      index++)
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (selectedPromo ==
                                              promoFilter[index]
                                                  .toLowerCase()) {
                                            selectedPromo = "";
                                          } else {
                                            selectedPromo = promoFilter[index]
                                                .toLowerCase();
                                          }
                                        });
                                      },
                                      child: filterItem(
                                        cardColor:
                                            promoFilter[index].toLowerCase() ==
                                                    selectedPromo
                                                ? Colors.black
                                                : null,
                                        name: promoFilter[index],
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                          //NOTE: Rating
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Rating",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: bold,
                                ),
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    for (var index = 0;
                                        index < ratingFilter.length;
                                        index++)
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (selectedRating ==
                                                ratingFilter[index]
                                                    .replaceAll("≥", "")) {
                                              selectedRating = "";
                                            } else {
                                              selectedRating =
                                                  ratingFilter[index]
                                                      .replaceAll("≥", "");
                                            }
                                          });
                                        },
                                        child: filterItem(
                                          cardColor: ratingFilter[index]
                                                      .replaceAll("≥", "") ==
                                                  selectedRating
                                              ? Colors.black
                                              : null,
                                          name: "",
                                          content: Row(
                                            children: [
                                              Text(
                                                ratingFilter[index],
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: ratingFilter[index]
                                                              .replaceAll(
                                                                  "≥", "") ==
                                                          selectedRating
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                              Icon(
                                                Icons.star,
                                                color: colorWarning,
                                                size: 14,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          //NOTE: Harga
                          Column(
                            spacing: 10,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Harga",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: bold,
                                ),
                              ),
                              Row(
                                spacing: 10,
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: lowestPriceFocusNode.hasFocus
                                              ? Colors.black
                                              : Colors.grey,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        spacing: 5,
                                        children: [
                                          Text(
                                            "Rp",
                                            style: TextStyle(
                                              fontWeight: bold,
                                            ),
                                          ),
                                          Expanded(
                                            child: TextFormField(
                                              focusNode: lowestPriceFocusNode,
                                              controller: lowestPriceController,
                                              cursorColor: Colors.black,
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: const InputDecoration
                                                  .collapsed(
                                                hintText: 'Terendah',
                                                hintStyle: TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Text("-"),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: highestPriceFocusNode.hasFocus
                                              ? Colors.black
                                              : Colors.grey,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        spacing: 5,
                                        children: [
                                          Text(
                                            "Rp",
                                            style: TextStyle(
                                              fontWeight: bold,
                                            ),
                                          ),
                                          Expanded(
                                            child: TextFormField(
                                              cursorColor: Colors.black,
                                              controller:
                                                  highestPriceController,
                                              focusNode: highestPriceFocusNode,
                                              keyboardType:
                                                  TextInputType.number,
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                              decoration: const InputDecoration
                                                  .collapsed(
                                                hintText: 'Tertinggi',
                                                hintStyle: TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),

                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            spacing: 10,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedCategory = "";
                                      selectedPromo = "";
                                      selectedRating = "";
                                      lowestPriceController.text = "";
                                      highestPriceController.text = "";
                                    });
                                    context
                                        .read<ProductCubit>()
                                        .setProductFilter(
                                          kategori: '',
                                          promo: '',
                                          rating: '',
                                          minPrice: '',
                                          maxPrice: '',
                                        );
                                    context.read<ProductCubit>().getAllProduct(
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
                                          type: (selectedPromo ==
                                                  'bundling & hadiah'
                                              ? 'promo'
                                              : selectedPromo),
                                          category: selectedCategory,
                                          minrating: selectedRating,
                                          maxprice: highestPriceController.text,
                                          minprice: lowestPriceController.text,
                                          page: 1,
                                          limit: 10,
                                          sort: sortBy,
                                        );
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: colorSuccess,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      "Reset",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: colorSuccess,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    context
                                        .read<ProductCubit>()
                                        .setProductFilter(
                                          kategori: selectedCategory,
                                          promo: selectedPromo,
                                          rating: selectedRating,
                                          minPrice: lowestPriceController.text,
                                          maxPrice: highestPriceController.text,
                                        );

                                    context.read<ProductCubit>().getAllProduct(
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
                                          type: (selectedPromo ==
                                                  'bundling & hadiah'
                                              ? 'promo'
                                              : selectedPromo),
                                          category: selectedCategory,
                                          minrating: selectedRating,
                                          maxprice: highestPriceController.text,
                                          minprice: lowestPriceController.text,
                                          page: 1,
                                          limit: 10,
                                          sort: sortBy,
                                        );
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: colorSuccess,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      "Terapkan",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget filterItem({
    Color? cardColor,
    required String name,
    Widget? content,
  }) {
    return Card(
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: content ??
            Text(
              name,
              style: TextStyle(
                fontSize: 12,
                color: cardColor != null ? Colors.white : Colors.black,
              ),
            ),
      ),
    );
  }
}

//NOTE: halaman untuk menampilkan kategori secara penuh
// ignore: must_be_immutable
class CategoryFilterPage extends StatefulWidget {
  String? selectedCategory;
  CategoryFilterPage({super.key, this.selectedCategory});

  @override
  State<CategoryFilterPage> createState() => _CategoryFilterPageState();
}

class _CategoryFilterPageState extends State<CategoryFilterPage> {
  String? newSelectedCategory = "";

  @override
  void initState() {
    context.read<CategoryCubit>().getProductCategory(
        token: context.read<AuthCubit>().state.loginModel.token ?? "",
        filter: "all");

    newSelectedCategory = widget.selectedCategory;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        // ignore: deprecated_member_use
        return WillPopScope(
          onWillPop: () async {
            Navigator.pop(context, widget.selectedCategory);
            return true;
          },
          child: Scaffold(
            body: SafeArea(
              child: Container(
                margin: const EdgeInsets.only(
                  top: 10,
                  left: 16,
                  right: 16,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          spacing: 10,
                          children: [
                            //NOTE: header
                            Row(
                              spacing: 5,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(
                                        context, widget.selectedCategory);
                                  },
                                  child: const Icon(
                                    SolarIconsOutline.arrowLeft,
                                  ),
                                ),
                                Text(
                                  "Kategori Produk",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: bold,
                                  ),
                                ),
                              ],
                            ),
                            //NOTE: content
                            for (var index = 0;
                                index <
                                    ((context
                                                .read<CategoryCubit>()
                                                .state
                                                .categoryModel?['data'] ??
                                            []) as List)
                                        .length;
                                index++) ...{
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    var selectedCategoryList =
                                        newSelectedCategory == ""
                                            ? []
                                            : newSelectedCategory?.split(",") ??
                                                [];

                                    if (selectedCategoryList.contains(
                                        "${(((context.read<CategoryCubit>().state.categoryModel?["data"] as List).map((e) => e as Map<String, dynamic>).toList()[index]["kat2_slug"] ?? []))}"
                                            .toLowerCase())) {
                                      selectedCategoryList.remove(
                                          "${(((context.read<CategoryCubit>().state.categoryModel?["data"] as List).map((e) => e as Map<String, dynamic>).toList()[index]["kat2_slug"] ?? []))}"
                                              .toLowerCase());
                                    } else {
                                      selectedCategoryList.add(
                                          "${(((context.read<CategoryCubit>().state.categoryModel?["data"] as List).map((e) => e as Map<String, dynamic>).toList()[index]["kat2_slug"] ?? []))}"
                                              .toLowerCase());
                                    }

                                    newSelectedCategory =
                                        selectedCategoryList.join(",");
                                  });
                                },
                                child: _CategoryFilterPageExtension()
                                    .productCategoryItem(
                                  categoryData: ((context
                                          .read<CategoryCubit>()
                                          .state
                                          .categoryModel?['data'] ??
                                      []) as List)[index],
                                  isSelected: (newSelectedCategory
                                                  ?.split(",") ??
                                              [])
                                          .contains(((context
                                                  .read<CategoryCubit>()
                                                  .state
                                                  .categoryModel?['data'] ??
                                              []) as List)[index]['kat2_slug'])
                                      ? true
                                      : false,
                                ),
                              ),
                            },
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.selectedCategory = newSelectedCategory;
                        Navigator.pop(context, widget.selectedCategory);
                      },
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: colorSuccess,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          "Simpan",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CategoryFilterPageExtension {
  Widget productCategoryItem({
    required Map<String, dynamic> categoryData,
    required bool isSelected,
  }) {
    return Row(
      spacing: 5,
      children: [
        Container(
          height: 12,
          width: 12,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
            ),
            color: isSelected ? Colors.black : Colors.transparent,
            borderRadius: BorderRadius.circular(9999),
          ),
        ),
        Text(
          categoryData['kat2'],
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
