import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tokosm_v2/shared/utils.dart';

class DeliveryService {
  Future<Map<String, dynamic>> getCourier(
      {required String token, required int cabangID}) async {
    var url = Uri.parse("$baseURL/transaksi/kurir?cabang=$cabangID");
    var header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      "skip_zrok_interstitial": "true",
    };

    var response = await http.get(
      url,
      headers: header,
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
