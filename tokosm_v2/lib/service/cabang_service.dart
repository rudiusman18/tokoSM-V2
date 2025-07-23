import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tokosm_v2/model/cabang_model.dart';
import 'package:tokosm_v2/shared/utils.dart';

class CabangService {
  Future<CabangModel> getCabangData({
    required String token,
  }) async {
    var url = Uri.parse("$baseURL/pengaturan/cabang");
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
      final CabangModel cabangModel = CabangModel.fromJson(data);
      return cabangModel;
    } else {
      var data = jsonDecode(response.body);
      throw ("${data['message']}");
    }
  }
}
