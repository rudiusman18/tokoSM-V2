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
          isMultiCart: isMultiCart);
      emit(CartSuccess());
    } catch (e) {
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

        if ((selectedProductCart?.data ?? [])[index].isFlashsale == 1 &&
            (selectedProductCart?.data ?? [])[index].satuanProduk !=
                (selectedProductCart?.data ?? [])[index].flashsaleSatuan) {
          productCartPrices.add(
              (selectedProductCart?.data ?? [])[index].hargaProduk *
                  (selectedProductCart?.data ?? [])[index].jumlah);
        } else if ((selectedProductCart?.data ?? [])[index].isFlashsale == 1) {
          productCartPrices.add(
              (selectedProductCart?.data ?? [])[index].hargaDiskonFlashsale *
                  (selectedProductCart?.data ?? [])[index].jumlah);
        } else if ((selectedProductCart?.data ?? [])[index].isDiskon == 1) {
          productCartPrices.add(
              (selectedProductCart?.data ?? [])[index].hargaDiskon *
                  (selectedProductCart?.data ?? [])[index].jumlah);
        } else {
          productCartPrices.add(
            (selectedProductCart?.data ?? [])[index].hargaProduk *
                (selectedProductCart?.data ?? [])[index].jumlah,
          );
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
        jumlahmultiSatuan: (product.jumlahList ?? [])
            .map((e) => int.tryParse(e.toString()) ?? 0)
            .toList(),
        multisatuanjumlah: (product.multisatuanJumlah?.split("/") ?? [])
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
      if ((product.data ?? [])[index].isFlashsale == 1 &&
          (product.data ?? [])[index].satuanProduk !=
              (product.data ?? [])[index].flashsaleSatuan) {
        productPricestoTransaction.add((product.data ?? [])[index].hargaProduk *
            (product.data ?? [])[index].jumlah);
      } else if ((product.data ?? [])[index].isFlashsale == 1) {
        productPricestoTransaction.add(
            (product.data ?? [])[index].hargaDiskonFlashsale *
                (product.data ?? [])[index].jumlah);
      } else if ((product.data ?? [])[index].isDiskon == 1) {
        productPricestoTransaction.add((product.data ?? [])[index].hargaDiskon *
            (product.data ?? [])[index].jumlah);
      } else {
        productPricestoTransaction.add(
          (product.data ?? [])[index].hargaProduk *
              (product.data ?? [])[index].jumlah,
        );
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
