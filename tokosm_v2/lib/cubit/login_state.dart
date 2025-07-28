part of 'login_cubit.dart';

abstract class AuthState {
  final LoginModel loginModel;
  const AuthState({required this.loginModel});
}

class LoginInitial extends AuthState {
  LoginInitial() : super(loginModel: LoginModel());
}

class LoginLoading extends AuthState {
  LoginLoading() : super(loginModel: LoginModel());
}

class LoginSuccess extends AuthState {
  LoginModel loginModelData;
  LoginSuccess({required this.loginModelData})
      : super(loginModel: loginModelData);
}

class LoginFailure extends AuthState {
  String error;
  LoginFailure({required this.error}) : super(loginModel: LoginModel());
}

// NOTE: State untuk change password
class PChangeLoading extends AuthState {
  LoginModel loginModelData;
  PChangeLoading(this.loginModelData) : super(loginModel: loginModelData);
}

class PChangeSuccess extends AuthState {
  LoginModel loginModelData;
  PChangeSuccess(this.loginModelData) : super(loginModel: loginModelData);
}

class PChangeFailure extends AuthState {
  LoginModel loginModelData;
  String error;
  PChangeFailure(this.loginModelData, this.error)
      : super(loginModel: loginModelData);
}
