import 'package:bloc/bloc.dart';

class WishlistTabFilterCubit extends Cubit<int> {
  WishlistTabFilterCubit() : super(0);

  void setTabIndex(int index) {
    emit(index);
  }
}
