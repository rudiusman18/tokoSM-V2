import 'package:bloc/bloc.dart';
import 'package:tokosm_v2/model/login_model.dart';
import 'package:tokosm_v2/service/login_service.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  void postLogin({required String email, required String password}) async {
    emit(LoginLoading());
    try {
      var loginData =
          await LoginService().postLogin(email: email, password: password);
      print("login berhasil dengan isi $loginData");
      emit(LoginSuccess(loginModelData: loginData));
    } catch (e) {
      print("login gagal dengan pesan $e");
      emit(LoginFailure(error: e.toString()));
    }
  }
}
