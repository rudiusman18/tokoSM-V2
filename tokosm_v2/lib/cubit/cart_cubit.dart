import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokosm_v2/service/cart_service.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  void addCart({
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
}
