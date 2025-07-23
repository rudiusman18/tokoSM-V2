import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tokosm_v2/model/login_model.dart';
import 'package:tokosm_v2/shared/utils.dart';

class LoginService {
  Future<LoginModel> postLogin(
      {required String email, required String password}) async {
    var url = Uri.parse("$baseURL/auth/login");
    var header = {'Content-Type': 'application/json'};
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

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);
      final LoginModel loginModel = LoginModel.fromJson(data);
      return loginModel;
    } else {
      var data = jsonDecode(response.body);
      throw ("${data['message']}");
    }
  }
}
