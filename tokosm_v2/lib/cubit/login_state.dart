part of 'login_cubit.dart';

abstract class LoginState {
  final LoginModel loginModel;
  const LoginState({required this.loginModel});
}

class LoginInitial extends LoginState {
  LoginInitial() : super(loginModel: LoginModel());
}

class LoginLoading extends LoginState {
  LoginLoading() : super(loginModel: LoginModel());
}

class LoginSuccess extends LoginState {
  LoginModel loginModelData;
  LoginSuccess({required this.loginModelData})
      : super(loginModel: loginModelData);
}

class LoginFailure extends LoginState {
  String error;
  LoginFailure({required this.error}) : super(loginModel: LoginModel());
}
