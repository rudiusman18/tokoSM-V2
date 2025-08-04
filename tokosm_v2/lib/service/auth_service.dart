import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tokosm_v2/model/login_model.dart';
import 'package:tokosm_v2/shared/utils.dart';

class AuthService {
  Future<LoginModel> postLogin(
      {required String email, required String password}) async {
    var url = Uri.parse("$baseURL/auth/login");
    var header = {
      'Content-Type': 'application/json',
    };
    Map data = {
      "email": email,
      "password": password,
    };
    var body = jsonEncode(data);
    var response = await http.post(
      url,
      headers: header,
      body: body,
    );

    print(
        'isi response adalah: ${response.statusCode} dengan pesan ${response.body}');

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);
      final LoginModel loginModel = LoginModel.fromJson(data);
      return loginModel;
    } else {
      var data = jsonDecode(response.body);
      throw ("${data['message']}");
    }
  }

  Future<Map<String, dynamic>> postChangePassword({
    required String token,
    required String oldPassword,
    required String newPassword,
  }) async {
    var url = Uri.parse("$baseURL/akun/password");
    var header = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $token",
    };
    Map data = {
      "oldpassword": oldPassword,
      "newpassword": newPassword,
    };
    var body = jsonEncode(data);
    var response = await http.post(
      url,
      headers: header,
      body: body,
    );

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      var data = jsonDecode(response.body);
      throw ("${data['message']}");
    }
  }

  Future<Map<String, dynamic>> postRegister({
    required String fullName,
    required String phoneNumber,
    required String email,
    required String userName,
    required String password,
  }) async {
    var url = Uri.parse("$baseURL/auth/register");
    var header = {
      'Content-Type': 'application/json',
    };
    Map data = {
      "nama_lengkap": fullName,
      "telp": phoneNumber,
      "email": email,
      "username": fullName,
      "password": password,
    };
    var body = jsonEncode(data);
    var response = await http.post(
      url,
      headers: header,
      body: body,
    );

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      var data = jsonDecode(response.body);
      throw ("${data['message']}");
    }
  }
}
