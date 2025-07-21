
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tokosm_v2/shared/themes.dart';

class DetailProductPage extends StatefulWidget {
  const DetailProductPage({super.key});

  @override
  State<DetailProductPage> createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
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
            const Icon(
              SolarIconsOutline.cartLarge2,
              size: 24,
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
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
                  Container(
                    width: 390,
                    height: 390,
                    color: Colors.grey,
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
                        Text(
                          "Rp 2000",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: bold,
                            color: colorError,
                          ),
                        ),
                        Text(
                          "Lorem ipsum dolor sit amet",
                          style: TextStyle(
                            fontWeight: bold,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: colorWarning,
                              size: 14,
                            ),
                            const Text(
                              "4.7",
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              "|",
                            ),
                            const SizedBox(
                              width: 10,
                            ),
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
                    margin: const EdgeInsets.symmetric(horizontal: 16),
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
                            title: "Merk", value: "Unilever"),
                        const SizedBox(
                          height: 2,
                        ),
                        _DetailProductExtension()
                            .detailProductItem(title: "Satuan", value: "Pcs"),
                        const SizedBox(
                          height: 2,
                        ),
                        _DetailProductExtension().detailProductItem(
                            title: "Kategori", value: "Makanan Ringan"),
                        const SizedBox(
                          height: 2,
                        ),
                        _DetailProductExtension().detailProductItem(
                            title: "Grosir", value: "3≥  12≥  50≥"),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          "Deskripsi Produk",
                          style: TextStyle(
                            fontWeight: bold,
                          ),
                        ),
                        const Text(
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                          style: TextStyle(
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
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          spacing: 10,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Ulasan Produk",
                              style: TextStyle(
                                fontWeight: bold,
                              ),
                            ),
                            _DetailProductExtension().allButtonView(
                              onTap: () {},
                            ),
                          ],
                        ),
                        for (var i = 0; i < 5; i++) ...{
                          _DetailProductExtension().reviewItem(
                            imageURL: "",
                            reviewerName: "Rudi Usman",
                            dateString: "14 Feb 24",
                            star: "3",
                            commentString: "Produk sangat recommended",
                          ),
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
            Container(
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
            )
          ],
        ),
      ),
    );
  }
}

class _DetailProductExtension {
  Widget allButtonView({required Function onTap}) {
    return Text(
      "Lihat Semua",
      style: TextStyle(
        color: colorSuccess,
        fontSize: 12,
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
            print(rating);
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
