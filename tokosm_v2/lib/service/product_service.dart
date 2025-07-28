import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tokosm_v2/model/product_model.dart';
import 'package:tokosm_v2/shared/utils.dart';

class ProductService {
  Future<ProductModel> getProduct({
    required String token,
    required String search,
    required int cabangId,
    required String type,
    required String sort,
    required String cat,
    required String minrating,
    required String minprice,
    required String maxprice,
    int page = 1,
    int limit = 10,
  }) async {
    var url = Uri.parse(
      "$baseURL/produk?cabang=$cabangId&type=$type&page=$page&limit=$limit&sort=$sort&cat=$cat&minrating=$minrating&minprice=$minprice&maxprice=$maxprice&q=$search",
    );
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

  Future<ProductModel> getDetailProduct({
    required String token,
    required String productId,
    required int cabangId,
  }) async {
    var url = Uri.parse("$baseURL/produk/detail/$productId?cabang=$cabangId");
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

  Future<ProductModel> getWishlistProduct({
    required String token,
    required int cabangId,
    required String sort,
    String search = "",
    int page = 1,
    limit = 10,
  }) async {
    var url = Uri.parse(
        "$baseURL/favorit?cabang=$cabangId&page=$page&limit=$limit&sort=$sort&q=$search");
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

  Future<Map<String, dynamic>> getProductCategory({
    required String token,
    required String filter,
  }) async {
    var url = Uri.parse(
      filter == ""
          ? "$baseURL/produk/kategori?tree=1"
          : "$baseURL/produk/kategori?filter=$filter",
    );
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
      return data;
    } else {
      var data = jsonDecode(response.body);
      throw ("${data['message']}");
    }
  }

  Future<Map<String, dynamic>> getBannerProduct({required String token}) async {
    var url = Uri.parse("$baseURL/produk/banner");
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
      return data;
    } else {
      var data = jsonDecode(response.body);
      throw ("${data['message']}");
    }
  }
}
