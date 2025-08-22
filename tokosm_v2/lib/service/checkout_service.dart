import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tokosm_v2/model/address_model.dart';
import 'package:tokosm_v2/shared/utils.dart';

class CheckoutService {
  Future<AddressModel> getAddress({
    required String token,
  }) async {
    var url = Uri.parse("$baseURL/akun/alamat");
    var header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var response = await http.get(
      url,
      headers: header,
    );

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);
      AddressModel addressModel = AddressModel.fromJson(data);
      return addressModel;
    } else {
      var data = jsonDecode(response.body);
      throw ("${data['message']}");
    }
  }
}
