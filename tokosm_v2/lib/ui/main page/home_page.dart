import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:solar_icons/solar_icons.dart';
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

  final CarouselSliderController carouselController =
      CarouselSliderController();

  int carouselCurrentIndex = 0;

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
                Container(
                  child: Row(
                    spacing: 10,
                    children: [
                      const Icon(
                        SolarIconsOutline.mapPointWave,
                        size: 24,
                      ),
                      Text(
                        "Cabang Pusat",
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
                Container(
                  child: const Row(
                    spacing: 10,
                    children: [
                      Icon(
                        SolarIconsOutline.cartLarge2,
                        size: 24,
                      ),
                      Icon(
                        SolarIconsOutline.settings,
                        size: 24,
                      ),
                    ],
                  ),
                )
              ],
            ),

            const SizedBox(
              height: 20,
            ),

            // NOTE: search
            Container(
              padding: const EdgeInsets.all(8),
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
                        decoration: const InputDecoration.collapsed(
                          hintText: "Cari Produk",
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );
    }

    Widget carouselBanner() {
      return Container(
        margin: const EdgeInsets.only(top: 10),
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
                _HomePageExtension().allButtonView(onTap: () {})
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                spacing: 10,
                children: [
                  for (var index = 0; index < 20; index++) ...{
                    _HomePageExtension().smallItemView(
                      imageURL:
                          'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80',
                      productName: "Lorem Ipsum",
                      productPrice: "Rp 12000",
                      discountPercentage: "20%",
                      productPriceColor: colorError,
                      productRealPrice: "RP 20000",
                      bonusInformation: "",
                    ),
                  }
                ],
              ),
            ),
          )
        ],
      );
    }

    Widget discountSection() {
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
                  "Diskon",
                  style: TextStyle(
                    fontWeight: bold,
                  ),
                ),
                _HomePageExtension().allButtonView(onTap: () {})
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                spacing: 10,
                children: [
                  for (var index = 0; index < 20; index++) ...{
                    _HomePageExtension().smallItemView(
                      imageURL:
                          'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80',
                      productName: "Lorem Ipsum",
                      productPrice: "Rp 12000",
                      discountPercentage: "20%",
                      productPriceColor: colorSuccess,
                      productRealPrice: "RP 20000",
                      bonusInformation: "",
                    ),
                  }
                ],
              ),
            ),
          )
        ],
      );
    }

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
                  const SizedBox(
                    height: 10,
                  ),
                  flashSaleSection(),
                  const SizedBox(
                    height: 10,
                  ),
                  discountSection(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _HomePageExtension {
  Widget allButtonView({required Function onTap}) {
    return Row(
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
    );
  }

  Widget smallItemView(
      {required String imageURL,
      required String productName,
      required String productPrice,
      required Color productPriceColor,
      required String discountPercentage,
      required String productRealPrice,
      required String bonusInformation}) {
    return Container(
      width: 96,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            // Ini nanti diisi image
            height: 96,
            width: 96,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Text(
            productName,
            style: const TextStyle(fontSize: 12),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                productPrice,
                style: TextStyle(
                  fontSize: 12,
                  color: productPriceColor,
                  fontWeight: bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: colorError,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
            ],
          ),
          Text(
            productRealPrice == "" ? bonusInformation : productRealPrice,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: bold,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ],
      ),
    );
  }
}
