import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tokosm_v2/model/area_model.dart';
import 'package:tokosm_v2/shared/utils.dart';

class SettingService {
  Future<AreaModel> getAreaData({
    required String token,
    required String kabKota,
  }) async {
    var url = Uri.parse("$baseURL/pengaturan/wilayah?kabkota=$kabKota");
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

      final AreaModel areaModel = AreaModel.fromJson(data);
      return areaModel;
    } else {
      var data = jsonDecode(response.body);
      throw ("${data['message']}");
    }
  }
}
