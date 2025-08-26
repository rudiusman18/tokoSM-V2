import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tokosm_v2/cubit/page_cubit.dart';
import 'package:tokosm_v2/cubit/review_cubit.dart';
import 'package:tokosm_v2/shared/themes.dart';
import 'package:tokosm_v2/shared/utils.dart';

class AllProductReviewPage extends StatefulWidget {
  const AllProductReviewPage({super.key});

  @override
  State<AllProductReviewPage> createState() => AllProductReviewPageState();
}

class AllProductReviewPageState extends State<AllProductReviewPage> {
  List<String> ratingFilter = [
    "Semua",
    "5",
    "4",
    "3",
    "2",
    "1",
  ];

  var selectedFilter = "";

// Lakukan filter
  List<Map<String, dynamic>>? filteredData;

  @override
  void initState() {
    selectedFilter = ratingFilter[0];

    filteredData =
        (context.read<ReviewCubit>().state.reviewModel?["data"] ?? [])
            .cast<Map<String, dynamic>>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = (context.read<ReviewCubit>().state.reviewModel?["data"] ?? [])
        .cast<Map<String, dynamic>>();

    Widget header() {
      return Container(
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
                'Ulasan',
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

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            header(),
            const SizedBox(
              height: 20,
            ),

            //NOTE: Filter
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: SingleChildScrollView(
                child: Row(
                  spacing: 5,
                  children: [
                    for (var index = 0;
                        index < ratingFilter.length;
                        index++) ...{
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedFilter = ratingFilter[index];

                            if (selectedFilter == "Semua") {
                              filteredData = data; // tidak difilter
                            } else {
                              filteredData = data.where((e) {
                                return e["rating"].toString() == selectedFilter;
                              }).toList();
                            }
                          });
                        },
                        child: _AllProductReviewPageExtension().filterItem(
                          name: ratingFilter[index],
                          selectedFilter: selectedFilter,
                        ),
                      ),
                    },
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Divider(
              color: greyBase300,
              height: 2,
              thickness: 2,
            ),
            const SizedBox(
              height: 5,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: ListView(
                  children: [
                    if ((filteredData ?? []).isEmpty) ...{
                      const Center(
                        child: Text(
                          "Tidak ada ulasan",
                        ),
                      ),
                    } else ...{
                      for (var data in (filteredData ?? [])) ...{
                        _AllProductReviewPageExtension().reviewItem(
                          imageURL: "",
                          reviewerName: "${data["nama_pelanggan"]}",
                          dateString:
                              Utils().formatTanggal("${data["created_at"]}"),
                          star: "${data["rating"]}",
                          commentString: "${data["ulasan"]}",
                        ),
                      },
                    },
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AllProductReviewPageExtension {
  Widget filterItem({
    required String name,
    required String selectedFilter,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: selectedFilter == name ? Colors.grey : greyBase300,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: bold,
            ),
          ),
          Icon(
            Icons.star,
            color: colorWarning,
            size: 12,
          ),
        ],
      ),
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
