import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tokosm_v2/cubit/auth_cubit.dart';
import 'package:tokosm_v2/cubit/cabang_cubit.dart';
import 'package:tokosm_v2/cubit/cart_cubit.dart';
import 'package:tokosm_v2/cubit/product_cubit.dart';
import 'package:tokosm_v2/model/product_model.dart';
import 'package:tokosm_v2/shared/themes.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    initialCartData();
    super.initState();
  }

  void initialCartData() {
    context.read<CartCubit>().getCart(
          token: context.read<AuthCubit>().state.loginModel.token ?? "",
          cabangID:
              context.read<CabangCubit>().state.selectedCabangData.id ?? 0,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CabangCubit, CabangState>(
      builder: (context, state) {
        return BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            return Scaffold(
              body: SafeArea(
                child: Container(
                  margin: const EdgeInsets.only(
                    top: 10,
                    left: 16,
                    right: 16,
                  ),
                  child: Column(
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
                            'Keranjang',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () async {
                          final List<String> listCabangName = (context
                                      .read<CabangCubit>()
                                      .state
                                      .cabangModel
                                      .data ??
                                  [])
                              .map((e) => e.namaCabang ?? "")
                              .toList();

                          final result = await showMenu<String>(
                            context: context,
                            position: const RelativeRect.fromLTRB(
                                40, 100, 30, 0), // sesuaikan posisi
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 10,
                          children: [
                            const Icon(
                              SolarIconsOutline.shopMinimalistic,
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
                      Expanded(
                        child: context.read<CartCubit>().state is CartLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: colorSuccess,
                                ),
                              )
                            : ListView(
                                children: [
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  for (var i = 0;
                                      i <
                                          (context
                                                      .read<CartCubit>()
                                                      .state
                                                      .productModel
                                                      ?.data ??
                                                  [])
                                              .length;
                                      i++) ...{
                                    _CartPageExtenion().verticalSmallItemView(
                                        context: context,
                                        product: context
                                            .read<CartCubit>()
                                            .state
                                            .productModel
                                            ?.data?[i]),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  }
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
      },
    );
  }
}

class _CartPageExtenion {
  Widget verticalSmallItemView({
    required BuildContext context,
    required DataProduct? product,
  }) {
    return GestureDetector(
      onTap: () {},
      child: SizedBox(
        height: 96, // tingginya menyesuaikan gambar
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(
                top: 10,
              ),
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.grey,
                  )),
            ),
            const SizedBox(
              width: 10,
            ),
            // Gambar di kiri
            Container(
              height: 96,
              width: 96,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(product?.gambarProduk?.first ?? ""),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 8), // jarak antara gambar dan teks

            // Semua teks di kanan
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product?.namaProduk ?? "",
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (product?.isFlashsale == 1 &&
                      product?.satuanProduk != product?.flashsaleSatuan)
                    Text(
                      "Rp ${product?.hargaProduk}",
                      style: TextStyle(
                        fontSize: 12,
                        color: colorSuccess,
                        fontWeight: bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          product?.isFlashsale == 1
                              ? "Rp ${product?.hargaDiskonFlashsale ?? 0}"
                              : product?.isDiskon == 1
                                  ? "Rp ${product?.hargaDiskon}"
                                  : "Rp ${product?.hargaProduk}",
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
                      if ((product?.isFlashsale == 1
                              ? "${product?.persentaseFlashsale}%"
                              : product?.isDiskon == 1
                                  ? "${product?.persentaseDiskon}%"
                                  : "") !=
                          "") ...{
                        const SizedBox(
                          width: 10,
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
                      }
                    ],
                  ),
                  if ((product?.isFlashsale == 1 || product?.isDiskon == 1) &&
                      product?.hargaProduk != null) ...{
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            product?.isFlashsale == 1
                                ? "Rp ${product?.hargaProdukFlashsale}"
                                : product?.isDiskon == 1
                                    ? "Rp ${product?.hargaDiskon}"
                                    : "",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: bold,
                              decoration: TextDecoration.lineThrough,
                              decorationThickness: 3,
                            ),
                          ),
                        ),
                        if (product?.isFlashsale == 1) ...{
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              product?.flashsaleSatuan ?? "",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        },
                      ],
                    ),
                  },
                  if (product?.isPromo == 1 && product?.namaPromo != null)
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
                            product?.namaPromo ?? "",
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
            ),

            //NOTE: tambah dan kurang keranjang
            if (product?.isMultisatuan == 1) ...{
              // multi satuan
              
            } else ...{
              // satuan
              Container(
                alignment: Alignment.bottomRight,
                child: Text("${product?.jumlah}"),
              ),
            },
          ],
        ),
      ),
    );
  }
}
