import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tokosm_v2/model/product_model.dart';
import 'package:tokosm_v2/shared/themes.dart';
import 'package:tokosm_v2/shared/utils.dart';

class ProductService {
  Future<ProductModel> getProduct({
    required String token,
    required int cabangId,
    required String type,
    int page = 1,
    int limit = 10,
  }) async {
    var url = Uri.parse(
        "$baseURL/produk?cabang=$cabangId&type=$type&page=$page&limit=$limit");
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
      final ProductModel productModel = ProductModel.fromJson(data);
      return productModel;
    } else {
      var data = jsonDecode(response.body);
      throw ("${data['message']}");
    }
  }
}
