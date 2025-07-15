import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokosm_v2/cubit/wishlist_cubit.dart';
import 'package:tokosm_v2/shared/themes.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  var tabFilter = ["Terbaru", "Terlaris", "Termahal", "Termurah"];

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
                        context.read<WishlistTabFilterCubit>().setTabIndex(i);
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
                                          .read<WishlistTabFilterCubit>()
                                          .state
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
                                    context.read<WishlistTabFilterCubit>().state
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

    return BlocBuilder<WishlistTabFilterCubit, int>(
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
                          children: List.generate(20, (index) {
                            return _wishlistPageExtension().bigItemView(
                              context:
                                  context, // Pass context to measure screen width
                              productName: "Lorem Ipsum",
                              price: "Rp 12000",
                              rating: "4.7",
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
class _wishlistPageExtension {
  Widget bigItemView({
    required BuildContext context,
    required String productName,
    required String price,
    required String rating,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    const horizontalPadding = 32; // 16 left + 16 right
    const spacing = 10;
    final itemWidth = (screenWidth - horizontalPadding - spacing) / 2;

    return SizedBox(
      width: itemWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Text(
            productName,
            style: const TextStyle(fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            price,
            style: TextStyle(
              fontSize: 12,
              color: colorSuccess,
              fontWeight: bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            children: [
              Icon(Icons.star, size: 12, color: colorWarning),
              Text(
                rating,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
