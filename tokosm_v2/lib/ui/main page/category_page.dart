import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokosm_v2/cubit/category_cubit.dart';
import 'package:tokosm_v2/cubit/auth_cubit.dart';
import 'package:tokosm_v2/cubit/product_cubit.dart';
import 'package:tokosm_v2/shared/themes.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  void initState() {
    initCategory();
    super.initState();
  }

  void initCategory() async {
    context.read<CategoryCubit>().getProductCategory(
        token: context.read<AuthCubit>().state.loginModel.token ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Container(
              margin: const EdgeInsets.only(
                top: 10,
                left: 16,
                right: 16,
              ),
              width: double.infinity,
              child: Column(
                children: [
                  Text(
                    "Kategori Produk",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ListView(
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
                          ExpandablePanel(
                            theme: const ExpandableThemeData(
                              headerAlignment:
                                  ExpandablePanelHeaderAlignment.center,
                              tapBodyToCollapse: true,
                            ),
                            header: Text(
                              "${(context.read<CategoryCubit>().state.categoryModel?["data"] as List).map((e) => e as Map<String, dynamic>).toList()[index]["kat1"]}",
                              style: TextStyle(
                                fontWeight: bold,
                              ),
                            ),
                            expanded: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  for (var index1 = 0;
                                      index1 <
                                          (((context
                                                              .read<CategoryCubit>()
                                                              .state
                                                              .categoryModel?[
                                                          "data"] as List)
                                                      .map((e) => e as Map<
                                                          String, dynamic>)
                                                      .toList()[index]["child"] ??
                                                  []) as List)
                                              .length;
                                      index1++) ...{
                                    GestureDetector(
                                      onTap: () {
                                        context
                                            .read<ProductCubit>()
                                            .setProductFilter(
                                                kategori:
                                                    "${(((context.read<CategoryCubit>().state.categoryModel?["data"] as List).map((e) => e as Map<String, dynamic>).toList()[index]["child"] ?? []) as List).map((e) => e as Map<String, dynamic>).toList()[index1]["kat2_slug"]}",
                                                promo: "",
                                                rating: "",
                                                minPrice: "",
                                                maxPrice: "");
                                        Navigator.pushNamed(
                                                context, 'product-page')
                                            .then((_) {
                                          initCategory();
                                        });
                                      },
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "${(((context.read<CategoryCubit>().state.categoryModel?["data"] as List).map((e) => e as Map<String, dynamic>).toList()[index]["child"] ?? []) as List).map((e) => e as Map<String, dynamic>).toList()[index1]["kat2"]}",
                                            style:
                                                const TextStyle(fontSize: 10),
                                          ),
                                        ),
                                      ),
                                    ),
                                  },
                                ],
                              ),
                            ),
                            collapsed: const SizedBox(),
                          ),
                        },
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
