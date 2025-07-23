import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tokosm_v2/cubit/cabang_cubit.dart';
import 'package:tokosm_v2/cubit/login_cubit.dart';
import 'package:tokosm_v2/cubit/product_cubit.dart';
import 'package:tokosm_v2/model/cabang_model.dart';
import 'package:tokosm_v2/shared/themes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> imgList = [
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
  ];

  TextEditingController searchController = TextEditingController(text: "");

  final CarouselSliderController carouselController =
      CarouselSliderController();

  int carouselCurrentIndex = 0;

  @override
  void initState() {
    initCabangData();
    super.initState();
  }

  void initProductData() async {
    context.read<ProductCubit>().getProducts(
        token: context.read<LoginCubit>().state.loginModel.token ?? "",
        cabangId: context.read<CabangCubit>().state.selectedCabangData.id ?? 0,
        type: 'flashsale');
    context.read<ProductCubit>().getProducts(
        token: context.read<LoginCubit>().state.loginModel.token ?? "",
        cabangId: context.read<CabangCubit>().state.selectedCabangData.id ?? 0,
        type: 'diskon');
    context.read<ProductCubit>().getProducts(
        token: context.read<LoginCubit>().state.loginModel.token ?? "",
        cabangId: context.read<CabangCubit>().state.selectedCabangData.id ?? 0,
        type: 'promo');
    context.read<ProductCubit>().getProducts(
        token: context.read<LoginCubit>().state.loginModel.token ?? "",
        cabangId: context.read<CabangCubit>().state.selectedCabangData.id ?? 0,
        type: 'terlaris',
        sort: 'terlaris');
    context.read<ProductCubit>().getProducts(
          token: context.read<LoginCubit>().state.loginModel.token ?? "",
          cabangId:
              context.read<CabangCubit>().state.selectedCabangData.id ?? 0,
          type: 'populer',
          sort: 'populer',
          limit: 99999999,
        );
  }

  void initCabangData() async {
    context.read<CabangCubit>().getCabangData(
        token: context.read<LoginCubit>().state.loginModel.token ?? "");
  }

  @override
  Widget build(BuildContext context) {
    Widget header() {
      return Container(
        margin: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            // NOTE: header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //NOTE: opsi cabang
                GestureDetector(
                  onTap: () async {
                    final List<String> listCabangName =
                        (context.read<CabangCubit>().state.cabangModel.data ??
                                [])
                            .map((e) => e.namaCabang ?? "")
                            .toList();

                    final result = await showMenu<String>(
                      context: context,
                      position: const RelativeRect.fromLTRB(
                          30, 80, 30, 0), // sesuaikan posisi
                      items: listCabangName.map((String cabang) {
                        return PopupMenuItem<String>(
                          value: cabang,
                          child: Text(cabang),
                        );
                      }).toList(),
                    );

                    if (result != null) {
                      setState(() {
                        context.read<CabangCubit>().selectCabang(
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
                      });
                    }
                  },
                  child: Row(
                    spacing: 10,
                    children: [
                      const Icon(
                        SolarIconsOutline.mapPointWave,
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

                // NOTE: setting dan keranjang
                Row(
                  spacing: 10,
                  children: [
                    const Icon(
                      SolarIconsOutline.cartLarge2,
                      size: 24,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "home-page/setting");
                      },
                      child: const Icon(
                        SolarIconsOutline.settings,
                        size: 24,
                      ),
                    ),
                  ],
                )
              ],
            ),

            const SizedBox(
              height: 20,
            ),

            // NOTE: search
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              margin: const EdgeInsets.only(
                bottom: 10,
              ),
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
          ],
        ),
      );
    }

    Widget carouselBanner() {
      return Container(
        height: 128,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: greyBase300,
              blurRadius: 4,
              offset: const Offset(2, 8), // Shadow position
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              CarouselSlider(
                  items: [
                    for (var img in imgList)
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: colorSecondary,
                          image: DecorationImage(
                            image: NetworkImage(img),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                  ],
                  options: CarouselOptions(
                      height: 128,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      padEnds: false,
                      viewportFraction: 1,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      autoPlayCurve: Curves.linear,
                      scrollDirection: Axis.horizontal,
                      onPageChanged: (index, reason) {
                        setState(() {
                          carouselCurrentIndex = index;
                        });
                      })),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: AnimatedSmoothIndicator(
                  activeIndex: carouselCurrentIndex,
                  count: imgList.length,
                  effect: WormEffect(
                    activeDotColor: colorSuccess,
                    dotColor: Colors.white,
                    dotWidth: 10,
                    dotHeight: 10,
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }

    Widget flashSaleSection() {
      var product = context.read<ProductCubit>().state.flashSaleProduct.data;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      "Fla",
                      style: TextStyle(
                        fontWeight: bold,
                        fontStyle: FontStyle.italic,
                        color: colorError,
                      ),
                    ),
                    Icon(
                      SolarIconsBold.bolt,
                      size: 14,
                      color: colorError,
                    ),
                    Text(
                      "h Sale",
                      style: TextStyle(
                        fontWeight: bold,
                        fontStyle: FontStyle.italic,
                        color: colorError,
                      ),
                    ),
                  ],
                ),
                _HomePageExtension()
                    .allButtonView(context: context, onTap: () {})
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    for (var index = 0;
                        index < (product ?? []).length;
                        index++) ...{
                      _HomePageExtension().smallItemView(
                        context: context,
                        imageURL: product?[index].gambarProduk?.first ?? "",
                        productName: product?[index].namaProduk ?? "",
                        productPrice: product?[index].isFlashsale == 1
                            ? "Rp ${product?[index].hargaFlashsale}"
                            : product?[index].isDiskon == 1
                                ? "Rp ${product?[index].hargaDiskon}"
                                : "Rp ${product?[index].hargaJual}",
                        discountPercentage: product?[index].isFlashsale == 1
                            ? "${product?[index].persentaseFlashsale}%"
                            : product?[index].isDiskon == 1
                                ? "${product?[index].persentaseDiskon}%"
                                : "",
                        productPriceColor: colorSuccess,
                        productRealPrice: product?[index].isFlashsale == 1 ||
                                product?[index].isDiskon == 1
                            ? "Rp ${product?[index].hargaJual}"
                            : "",
                        bonusInformation: product?[index].isPromo == 1
                            ? "${product?[index].namaPromo}"
                            : "",
                        isFlashSale:
                            product?[index].isFlashsale == 1 ? true : false,
                      ),
                    }
                  ],
                ),
              ),
            ),
          )
        ],
      );
    }

    Widget discountSection() {
      var product = context.read<ProductCubit>().state.discountProduct.data;
      return Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Diskon",
                  style: TextStyle(
                    fontWeight: bold,
                  ),
                ),
                _HomePageExtension()
                    .allButtonView(context: context, onTap: () {})
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    for (var index = 0;
                        index < (product ?? []).length;
                        index++) ...{
                      _HomePageExtension().smallItemView(
                        context: context,
                        imageURL: product?[index].gambarProduk?.first ?? "",
                        productName: product?[index].namaProduk ?? "",
                        productPrice: product?[index].isFlashsale == 1
                            ? "Rp ${product?[index].hargaFlashsale}"
                            : product?[index].isDiskon == 1
                                ? "Rp ${product?[index].hargaDiskon}"
                                : "Rp ${product?[index].hargaJual}",
                        discountPercentage: product?[index].isFlashsale == 1
                            ? "${product?[index].persentaseFlashsale}%"
                            : product?[index].isDiskon == 1
                                ? "${product?[index].persentaseDiskon}%"
                                : "",
                        productPriceColor: colorSuccess,
                        productRealPrice: product?[index].isFlashsale == 1 ||
                                product?[index].isDiskon == 1
                            ? "Rp ${product?[index].hargaJual}"
                            : "",
                        bonusInformation: product?[index].isPromo == 1
                            ? "${product?[index].namaPromo}"
                            : "",
                        isFlashSale:
                            product?[index].isFlashsale == 1 ? true : false,
                      ),
                    }
                  ],
                ),
              ),
            ),
          )
        ],
      );
    }

    Widget promoSection() {
      var product = context.read<ProductCubit>().state.promoProduct.data;
      return Column(
        spacing: 10,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Promo",
                  style: TextStyle(
                    fontWeight: bold,
                  ),
                ),
                _HomePageExtension()
                    .allButtonView(context: context, onTap: () {})
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    for (var index = 0;
                        index < (product ?? []).length;
                        index++) ...{
                      _HomePageExtension().smallItemView(
                        context: context,
                        imageURL: product?[index].gambarProduk?.first ?? "",
                        productName: product?[index].namaProduk ?? "",
                        productPrice: product?[index].isFlashsale == 1
                            ? "Rp ${product?[index].hargaFlashsale}"
                            : product?[index].isDiskon == 1
                                ? "Rp ${product?[index].hargaDiskon}"
                                : "Rp ${product?[index].hargaJual}",
                        discountPercentage: product?[index].isFlashsale == 1
                            ? "${product?[index].persentaseFlashsale}%"
                            : product?[index].isDiskon == 1
                                ? "${product?[index].persentaseDiskon}%"
                                : "",
                        productPriceColor: colorSuccess,
                        productRealPrice: product?[index].isFlashsale == 1 ||
                                product?[index].isDiskon == 1
                            ? "Rp ${product?[index].hargaJual}"
                            : "",
                        bonusInformation: product?[index].isPromo == 1
                            ? "${product?[index].namaPromo}"
                            : "",
                        isFlashSale:
                            product?[index].isFlashsale == 1 ? true : false,
                      ),
                    }
                  ],
                ),
              ),
            ),
          )
        ],
      );
    }

    Widget terlarisSection() {
      var product = context.read<ProductCubit>().state.bestSellerProduct.data;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Terlaris",
                  style: TextStyle(
                    fontWeight: bold,
                  ),
                ),
                _HomePageExtension()
                    .allButtonView(context: context, onTap: () {})
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    for (var index = 0;
                        index < (product ?? []).length;
                        index++) ...{
                      _HomePageExtension().smallItemView(
                        context: context,
                        imageURL: product?[index].gambarProduk?.first ?? "",
                        productName: product?[index].namaProduk ?? "",
                        productPrice: product?[index].isFlashsale == 1
                            ? "Rp ${product?[index].hargaFlashsale}"
                            : product?[index].isDiskon == 1
                                ? "Rp ${product?[index].hargaDiskon}"
                                : "Rp ${product?[index].hargaJual}",
                        discountPercentage: product?[index].isFlashsale == 1
                            ? "${product?[index].persentaseFlashsale}%"
                            : product?[index].isDiskon == 1
                                ? "${product?[index].persentaseDiskon}%"
                                : "",
                        productPriceColor: colorSuccess,
                        productRealPrice: product?[index].isFlashsale == 1 ||
                                product?[index].isDiskon == 1
                            ? "Rp ${product?[index].hargaJual}"
                            : "",
                        bonusInformation: product?[index].isPromo == 1
                            ? "${product?[index].namaPromo}"
                            : "",
                        isFlashSale:
                            product?[index].isFlashsale == 1 ? true : false,
                      ),
                    }
                  ],
                ),
              ),
            ),
          )
        ],
      );
    }

    Widget popularSection() {
      var product = context.read<ProductCubit>().state.popularProduct.data;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Populer",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _HomePageExtension()
                    .allButtonView(context: context, onTap: () {}),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(
                (product ?? []).length,
                (index) {
                  return _HomePageExtension().bigItemView(
                    context: context,
                    imageURL: product?[index].gambarProduk?.first ?? "",
                    productName: product?[index].namaProduk ?? "",
                    productPrice: product?[index].isFlashsale == 1
                        ? "Rp ${product?[index].hargaFlashsale}"
                        : product?[index].isDiskon == 1
                            ? "Rp ${product?[index].hargaDiskon}"
                            : "Rp ${product?[index].hargaJual}",
                    discountPercentage: product?[index].isFlashsale == 1
                        ? "${product?[index].persentaseFlashsale}%"
                        : product?[index].isDiskon == 1
                            ? "${product?[index].persentaseDiskon}%"
                            : "",
                    productPriceColor: colorSuccess,
                    productRealPrice: product?[index].isFlashsale == 1 ||
                            product?[index].isDiskon == 1
                        ? "Rp ${product?[index].hargaJual}"
                        : "",
                    bonusInformation: product?[index].isPromo == 1
                        ? "${product?[index].namaPromo}"
                        : "",
                    rating: product?[index].rating ?? "",
                    isFlashSale:
                        product?[index].isFlashsale == 1 ? true : false,
                  );
                },
              ),
            ),
          ),
        ],
      );
    }

    return BlocConsumer<CabangCubit, CabangState>(
      listener: (context, state) {
        if (state is CabangSuccess) {
          if (context.read<CabangCubit>().state.selectedCabangData.namaCabang ==
              null) {
            context.read<CabangCubit>().selectCabang(
                cabang:
                    context.read<CabangCubit>().state.cabangModel.data?.first ??
                        DataCabang());
          }
          initProductData();
        }
      },
      builder: (context, state) {
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
                    Expanded(
                      child: ListView(
                        children: [
                          Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: carouselBanner()),
                          if ((context
                                      .read<ProductCubit>()
                                      .state
                                      .flashSaleProduct
                                      .data ??
                                  [])
                              .isNotEmpty) ...{
                            const SizedBox(
                              height: 10,
                            ),
                            flashSaleSection(),
                          },
                          if ((context
                                      .read<ProductCubit>()
                                      .state
                                      .discountProduct
                                      .data ??
                                  [])
                              .isNotEmpty) ...{
                            const SizedBox(
                              height: 10,
                            ),
                            discountSection(),
                          },
                          if ((context
                                      .read<ProductCubit>()
                                      .state
                                      .promoProduct
                                      .data ??
                                  [])
                              .isNotEmpty) ...{
                            const SizedBox(
                              height: 10,
                            ),
                            promoSection(),
                          },
                          if ((context
                                      .read<ProductCubit>()
                                      .state
                                      .bestSellerProduct
                                      .data ??
                                  [])
                              .isNotEmpty) ...{
                            const SizedBox(
                              height: 10,
                            ),
                            terlarisSection(),
                          },
                          const SizedBox(
                            height: 10,
                          ),
                          popularSection(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _HomePageExtension {
  Widget allButtonView(
      {required BuildContext context, required Function onTap}) {
    return GestureDetector(
      onTap: () {
        context.read<ProductCubit>().setSearchKeyword("");
        Navigator.pushNamed(context, 'product-page');
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Lihat Semua",
            style: TextStyle(
              color: colorSuccess,
              fontSize: 12,
            ),
          ),
          Icon(
            SolarIconsOutline.altArrowRight,
            size: 12,
            color: colorSuccess,
          ),
        ],
      ),
    );
  }

  Widget smallItemView({
    required BuildContext context,
    required String imageURL,
    required String productName,
    required String productPrice,
    required Color productPriceColor,
    required String discountPercentage,
    required String productRealPrice,
    required String bonusInformation,
    bool isFlashSale = false,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, 'product/detail-product');
      },
      child: SizedBox(
        width: 96,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  // Ini nanti diisi image
                  height: 96,
                  width: 96,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(imageURL),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Text(
                  productName,
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
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
            if (bonusInformation != "") ...{
              Container(
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
            },
          ],
        ),
      ),
    );
  }

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
}
