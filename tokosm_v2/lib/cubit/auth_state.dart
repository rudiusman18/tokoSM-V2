part of 'auth_cubit.dart';

abstract class AuthState {
  final LoginModel loginModel;
  const AuthState({required this.loginModel});
}

// NOTE: State untuk login
class AuthInitial extends AuthState {
  AuthInitial() : super(loginModel: LoginModel());
}

class AuthLoading extends AuthState {
  AuthLoading() : super(loginModel: LoginModel());
}

class AuthSuccess extends AuthState {
  LoginModel loginModelData;
  AuthSuccess({required this.loginModelData})
      : super(loginModel: loginModelData);
}

class AuthFailure extends AuthState {
  String error;
  AuthFailure({required this.error}) : super(loginModel: LoginModel());
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
