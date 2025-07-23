import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tokosm_v2/cubit/cabang_cubit.dart';
import 'package:tokosm_v2/cubit/category_cubit.dart';
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

  TextEditingController searchController = TextEditingController(text: "");

  @override
  void initState() {
    searchController.text =
        (context.read<ProductCubit>().state as ProductSearchKeyword)
            .searchKeyword;
    initProductData();
    super.initState();
  }

  void initProductData() async {
    context.read<ProductCubit>().productTabIndex(0);
    context.read<ProductCubit>().getAllProduct(
          token: context.read<LoginCubit>().state.loginModel.token ?? "",
          cabangId:
              context.read<CabangCubit>().state.selectedCabangData.id ?? 0,
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
                const Icon(
                  SolarIconsOutline.cartLarge2,
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
                              cabangId: context
                                      .read<CabangCubit>()
                                      .state
                                      .selectedCabangData
                                      .id ??
                                  0,
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
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: ListView(
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

  Future<void> filterBottomSheet({
    required BuildContext context,
    required String sortBy,
  }) {
    context.read<CategoryCubit>().getProductCategory(
          token: context.read<LoginCubit>().state.loginModel.token ?? "",
        );

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, setState) {
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
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              for (var index = 0;
                                  index <
                                      ((context
                                                  .read<CategoryCubit>()
                                                  .state
                                                  .categoryModel?["data"] ??
                                              []) as List)
                                          .length;
                                  index++) ...{
                                for (var index1 = 0;
                                    index1 <
                                        (((context
                                                            .read<CategoryCubit>()
                                                            .state
                                                            .categoryModel?[
                                                        "data"] as List)
                                                    .map((e) => e
                                                        as Map<String, dynamic>)
                                                    .toList()[index]["child"] ??
                                                []) as List)
                                            .length;
                                    index1++) ...{
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedCategory =
                                            "${(((context.read<CategoryCubit>().state.categoryModel?["data"] as List).map((e) => e as Map<String, dynamic>).toList()[index]["child"] ?? []) as List).map((e) => e as Map<String, dynamic>).toList()[index1]["kat2_slug"]}"
                                                .toLowerCase();
                                      });
                                    },
                                    child: filterItem(
                                      cardColor:
                                          "${(((context.read<CategoryCubit>().state.categoryModel?["data"] as List).map((e) => e as Map<String, dynamic>).toList()[index]["child"] ?? []) as List).map((e) => e as Map<String, dynamic>).toList()[index1]["kat2_slug"]}"
                                                      .toLowerCase() ==
                                                  selectedCategory
                                              ? Colors.black
                                              : null,
                                      name:
                                          "${(((context.read<CategoryCubit>().state.categoryModel?["data"] as List).map((e) => e as Map<String, dynamic>).toList()[index]["child"] ?? []) as List).map((e) => e as Map<String, dynamic>).toList()[index1]["kat2"]}",
                                    ),
                                  ),
                                },
                              },
                            ],
                          ),
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
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              for (var index = 0;
                                  index < promoFilter.length;
                                  index++)
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedPromo =
                                          promoFilter[index].toLowerCase();
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
                                      selectedRating = ratingFilter[index]
                                          .replaceAll("≥", "");
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
                                                        .replaceAll("≥", "") ==
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
                                        keyboardType: TextInputType.number,
                                        decoration:
                                            const InputDecoration.collapsed(
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
                                        controller: highestPriceController,
                                        focusNode: highestPriceFocusNode,
                                        keyboardType: TextInputType.number,
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                        decoration:
                                            const InputDecoration.collapsed(
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
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              print(
                                  "Filter yang diterapkan adalah: $selectedCategory, $selectedPromo, $selectedRating, ${lowestPriceController.text}, ${highestPriceController.text}");
                              context.read<ProductCubit>().getAllProduct(
                                    token: context
                                            .read<LoginCubit>()
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
                                    type: (selectedPromo == 'bundling & hadiah'
                                        ? 'promo'
                                        : selectedPromo),
                                    category: selectedCategory,
                                    minrating: selectedRating,
                                    maxprice: highestPriceController.text,
                                    minprice: lowestPriceController.text,
                                    page: 1,
                                    limit: 999999999,
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
              );
            },
          );
        });
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
class CategoryFilterPage extends StatefulWidget {
  const CategoryFilterPage({super.key});

  @override
  State<CategoryFilterPage> createState() => _CategoryFilterPageState();
}

class _CategoryFilterPageState extends State<CategoryFilterPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
