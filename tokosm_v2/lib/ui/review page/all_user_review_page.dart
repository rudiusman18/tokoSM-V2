import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tokosm_v2/cubit/auth_cubit.dart';
import 'package:tokosm_v2/cubit/review_cubit.dart';
import 'package:tokosm_v2/shared/themes.dart';
import 'package:tokosm_v2/shared/utils.dart';

class AllUserReviewPage extends StatefulWidget {
  const AllUserReviewPage({super.key});

  @override
  State<AllUserReviewPage> createState() => _AllUserReviewPageState();
}

class _AllUserReviewPageState extends State<AllUserReviewPage> {
  TextEditingController searchController = TextEditingController(text: "");

  @override
  void initState() {
    getInitData();
    super.initState();
  }

  void getInitData() {
    context.read<ReviewCubit>().getUserReviewProduct(
          token: context.read<AuthCubit>().state.loginModel.token ?? "",
          searchKeyword: searchController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    Widget header() {
      return Column(
        spacing: 10,
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
              Text(
                'Data Ulasan',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: bold,
                ),
              ),
            ],
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
                        searchController.text = value;
                        getInitData();
                      },
                      style: const TextStyle(fontSize: 12),
                      decoration: const InputDecoration.collapsed(
                        hintText: "Cari",
                        hintStyle: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      );
    }

    return BlocBuilder<ReviewCubit, ReviewState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Column(
                children: [
                  header(),
                  if (state is ReviewLoading) ...{
                    Center(
                      child: CircularProgressIndicator(
                        color: colorSuccess,
                      ),
                    ),
                  } else if (state is ReviewFailure) ...{
                    const Center(
                      child: Text("Gagal Memuat Data"),
                    ),
                  } else if (state is ReviewSuccess) ...{
                    (context.read<ReviewCubit>().state.reviewModel?["data"] ??
                                [])
                            .isEmpty
                        ? const Center(
                            child: Text(
                              "Data tidak ditemukan",
                            ),
                          )
                        : Expanded(
                            child: ListView(
                              children: [
                                for (var data in (context
                                        .read<ReviewCubit>()
                                        .state
                                        .reviewModel?["data"] ??
                                    [])) ...{
                                  _allReviewPageExtension().reviewItem(
                                    productName: "${data["nama_produk"]}",
                                    dateString: Utils()
                                        .formatTanggal(data["created_at"]),
                                    star: "${data["rating"]}",
                                    commentString: data["ulasan"],
                                  )
                                },
                              ],
                            ),
                          ),
                  },
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _allReviewPageExtension {
  Widget reviewItem({
    required String productName,
    required String dateString,
    required String star,
    required String commentString,
  }) {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              productName,
              style: TextStyle(
                fontSize: 12,
                fontWeight: bold,
              ),
            ),
            Text(
              dateString,
              style: const TextStyle(fontSize: 12),
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
