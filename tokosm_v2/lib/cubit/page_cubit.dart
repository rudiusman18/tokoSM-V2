import 'package:bloc/bloc.dart';

class PageCubit extends Cubit<int> {
  PageCubit() : super(0);

  void setPage(int pageNumber) {
    emit(pageNumber);
  }
}
