import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokosm_v2/model/product_model.dart';
import 'package:tokosm_v2/service/cart_service.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  Future<void> addCart({
    required String token,
    required int cabangId,
    required int productId,
    int? amount,
    List<int>? multisatuanJumlah,
    List<String>? multisatuanUnit,
    List<int>? jumlahmultiSatuan,
    required bool isMultiCart,
  }) async {
    emit(CartLoading());
    try {
      var _ = await CartService().postCart(
        token: token,
        cabangId: cabangId,
        productId: productId,
        amount: amount,
        multisatuanJumlah: multisatuanJumlah,
        multisatuanUnit: multisatuanUnit,
        jumlahmultiSatuan: jumlahmultiSatuan,
        isMultiCart: isMultiCart,
      );

      emit(CartSuccess());
    } catch (e) {
      print(e.toString());
      emit(CartFailure(error: e.toString()));
    }
  }

  void getCart({
    required String token,
    required int cabangID,
    bool isLoadingNeeded = true,
  }) async {
    var selectedProductCart = state.productToTransaction;
    List<int>? productCartPrices = [];

    if (isLoadingNeeded == true) {
      emit(CartLoading());
    }
    try {
      ProductModel productCart =
          await CartService().getCart(token: token, cabangID: cabangID);

      for (var index = 0;
          index < (selectedProductCart?.data ?? []).length;
          index++) {
        selectedProductCart?.data?[index] = (productCart.data ?? [])
            .where((e) => e.id == selectedProductCart.data?[index].id)
            .toList()
            .first;

        //NOTE: perhitungan pembelian grosir
        if ((selectedProductCart?.data ?? [])[index].isGrosir == 1) {
          var hargaGrosir =
              (selectedProductCart?.data ?? [])[index].hargaProduk *
                  (selectedProductCart?.data ?? [])[index].jumlah;
          for (var i = 0;
              i <
                  ((selectedProductCart?.data ?? [])[index].grosirJumlahMin ??
                          [])
                      .length;
              i++) {
            print(
                "isi grosir min adalah ${((selectedProductCart?.data ?? [])[index].grosirJumlahMin?[i] ?? 0)}");
            if ((selectedProductCart?.data ?? [])[index].jumlah >=
                ((selectedProductCart?.data ?? [])[index].grosirJumlahMin?[i] ??
                    0)) {
              hargaGrosir = (selectedProductCart?.data ?? [])[index].jumlah *
                  (selectedProductCart?.data ?? [])[index].hargaGrosir?[i];
            }
          }

          print("isi harga grosir adalah ${hargaGrosir}");

          productCartPrices.add(hargaGrosir);
        }

        //NOTE: perhitungan flashsale (sesuai syarat dan syarat harus sama persis dengan flashsale_kuantitas)
        if ((selectedProductCart?.data ?? [])[index].isFlashsale == 1) {
          if ((selectedProductCart?.data ?? [])[index].jumlah ==
              (selectedProductCart?.data ?? [])[index].flashsaleKuantitas) {
            productCartPrices.add(
                (selectedProductCart?.data ?? [])[index].hargaDiskonFlashsale *
                    (selectedProductCart?.data ?? [])[index].jumlah);
          } else {
            // jika tidak sesuai kuantitas kena harga normal
            productCartPrices.add(
                (selectedProductCart?.data ?? [])[index].hargaProduk *
                    (selectedProductCart?.data ?? [])[index].jumlah);
          }
        }

        //NOTE: perhitungan diskon (sesuai dengan syarat max beli untuk diskon)
        if ((selectedProductCart?.data ?? [])[index].isDiskon == 1) {
          if ((selectedProductCart?.data ?? [])[index].jumlah <=
              (selectedProductCart?.data ?? [])[index].diskonMaxBeli) {
            productCartPrices.add(
                (selectedProductCart?.data ?? [])[index].hargaDiskon *
                    (selectedProductCart?.data ?? [])[index].jumlah);
          }
        }
      }

      emit(
        CartSuccess(
          productModelData: productCart,
          productPricestoTransactionData: productCartPrices,
          productToTransactionData: selectedProductCart,
        ),
      );
    } catch (e) {
      print("gagal dengan $e");
      emit(CartFailure(error: e.toString()));
    }
  }

// Digunakan untuk menambah data product (state nya akan digunakan di detail product)
  void setProductAmount({
    required List<int> productAmount,
  }) {
    emit(
      CartSuccess(
          productModelData: state.productModel,
          productAmountData: productAmount),
    );
  }

  void updateCart({
    required String token,
    required DataProduct product,
    required int cabangID,
  }) async {
    ProductModel? selectedProductCart = state.productToTransaction;
    List<int>? selectedProductPrices = state.productPricestoTransaction;
    ProductModel? productModel = state.productModel;

    try {
      var _ = await CartService().updateCart(
        token: token,
        cartId: product.cartId,
        amount: product.jumlah,
        jumlahmultiSatuan: (product.jumlahMultisatuan ?? [])
            .map((e) => int.tryParse(e.toString()) ?? 0)
            .toList(),
        multisatuanjumlah: (product.multisatuanJumlah ?? [])
            .map((e) => int.tryParse(e.toString()) ?? 0)
            .toList(),
        isMultiCart: product.isMultisatuan == 1 ? true : false,
      );
      emit(CartSuccess(
        productModelData: productModel,
        productPricestoTransactionData: selectedProductPrices,
        productToTransactionData: selectedProductCart,
      ));
      getCart(
        token: token,
        cabangID: cabangID,
        isLoadingNeeded: false,
      );
    } catch (e) {
      print("update cart error $e");
      emit(CartFailure(error: e.toString()));
    }
  }

  void deleteCart({
    required String token,
    required int cabangID,
    required DataProduct product,
  }) async {
    emit(CartLoading());
    try {
      ProductModel? selectedProductCart = state.productToTransaction;
      List<int>? selectedProductPrices = state.productPricestoTransaction;
      ProductModel? productModel = state.productModel;

      var _ =
          await CartService().deleteCart(token: token, cartId: product.cartId);

      emit(CartSuccess(
        productModelData: productModel,
        productPricestoTransactionData: selectedProductPrices,
        productToTransactionData: selectedProductCart,
      ));
      getCart(
        token: token,
        cabangID: cabangID,
        isLoadingNeeded: false,
      );
    } catch (e) {
      emit(CartFailure(error: e.toString()));
    }
  }

  void cartProducttoTransaction({required ProductModel product}) {
    final List<int> productPricestoTransaction = [];

    for (var index = 0; index < (product.data ?? []).length; index++) {
      //NOTE: perhitungan pembelian grosir
      if ((product.data ?? [])[index].isGrosir == 1) {
        var hargaGrosir = (product.data ?? [])[index].hargaProduk *
            (product.data ?? [])[index].jumlah;
        for (var i = 0;
            i < ((product.data ?? [])[index].grosirJumlahMin ?? []).length;
            i++) {
          print(
              "isi grosir min adalah ${((product.data ?? [])[index].grosirJumlahMin?[i] ?? 0)}");
          if ((product.data ?? [])[index].jumlah >=
              ((product.data ?? [])[index].grosirJumlahMin?[i] ?? 0)) {
            hargaGrosir = (product.data ?? [])[index].jumlah *
                (product.data ?? [])[index].hargaGrosir?[i];
          }
        }

        print("isi harga grosir adalah ${hargaGrosir}");

        productPricestoTransaction.add(hargaGrosir);
      }

      //NOTE: perhitungan flashsale (sesuai syarat dan syarat harus sama persis dengan flashsale_kuantitas)
      if ((product.data ?? [])[index].isFlashsale == 1) {
        if ((product.data ?? [])[index].jumlah ==
            (product.data ?? [])[index].flashsaleKuantitas) {
          productPricestoTransaction.add(
              (product.data ?? [])[index].hargaDiskonFlashsale *
                  (product.data ?? [])[index].jumlah);
        } else {
          // jika tidak sesuai kuantitas kena harga normal
          productPricestoTransaction.add(
              (product.data ?? [])[index].hargaProduk *
                  (product.data ?? [])[index].jumlah);
        }
      }

      //NOTE: perhitungan diskon (sesuai dengan syarat max beli untuk diskon)
      if ((product.data ?? [])[index].isDiskon == 1) {
        if ((product.data ?? [])[index].jumlah <=
            (product.data ?? [])[index].diskonMaxBeli) {
          productPricestoTransaction.add(
              (product.data ?? [])[index].hargaDiskon *
                  (product.data ?? [])[index].jumlah);
        }
      }
    }

    emit(
      CartSuccess(
        productAmountData: state.productAmount,
        productModelData: state.productModel,
        productToTransactionData: product,
        productPricestoTransactionData: productPricestoTransaction,
      ),
    );
  }
}
