import 'package:bloc/bloc.dart';
import 'package:tokosm_v2/model/login_model.dart';
import 'package:tokosm_v2/service/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'login_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(LoginInitial());

  void postLogin({required String email, required String password}) async {
    emit(LoginLoading());
    try {
      var loginData =
          await AuthService().postLogin(email: email, password: password);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user credential', "$email||$password");
      emit(LoginSuccess(loginModelData: loginData));
    } catch (e) {
      emit(LoginFailure(error: e.toString()));
    }
  }

  void logout() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.remove("user credential");
  }

  void postChangePassword(
      {required String token,
      required String oldPassword,
      required String newPassword}) async {
    emit(PChangeLoading(state.loginModel));
    try {
      var _ = await AuthService().postChangePassword(
          token: token, oldPassword: oldPassword, newPassword: newPassword);

      emit(PChangeSuccess(state.loginModel));
    } catch (e) {
      emit(PChangeFailure(state.loginModel, e.toString()));
    }
  }
}
