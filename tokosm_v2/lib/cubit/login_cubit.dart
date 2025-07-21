import 'package:bloc/bloc.dart';
import 'package:tokosm_v2/model/login_model.dart';
import 'package:tokosm_v2/service/login_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  void postLogin({required String email, required String password}) async {
    emit(LoginLoading());
    try {
      var loginData =
          await LoginService().postLogin(email: email, password: password);
      print("login berhasil dengan isi $loginData");
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user credential', "$email||$password");
      emit(LoginSuccess(loginModelData: loginData));
    } catch (e) {
      print("login gagal dengan pesan $e");
      emit(LoginFailure(error: e.toString()));
    }
  }
}
