import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tokosm_v2/model/product_model.dart';
import 'package:tokosm_v2/shared/utils.dart';

class CartService {
  Future<Map<String, dynamic>> postCart({
    required String token,
    required int cabangId,
    required int productId,
    required int? amount,
    required List<int>? multisatuanJumlah,
    required List<String>? multisatuanUnit,
    required List<int>? jumlahmultiSatuan,
    required bool isMultiCart,
  }) async {
    var url = Uri.parse("$baseURL/keranjang");
    var header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      "skip_zrok_interstitial": "true",
    };
    Map data = {};

    if (isMultiCart) {
      // multi satuan
      data = {
        "cabang_id": cabangId,
        "produk_id": productId,
        "multisatuan_jumlah": multisatuanJumlah,
        "multisatuan_unit": multisatuanUnit,
        "jumlah_multisatuan": jumlahmultiSatuan,
      };
    } else {
      // single satuan
      data = {
        'cabang_id': cabangId,
        'produk_id': productId,
        'jumlah': amount,
      };
    }

    var body = jsonEncode(data);
    var response = await http.post(
      url,
      headers: header,
      body: body,
    );

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);
      print("berhasil dengan isi $data");
      return data;
    } else {
      var data = jsonDecode(response.body);
      print("gagal dengan isi $data");
      throw ("${data['message']}");
    }
  }

  Future<Map<String, dynamic>> updateCart({
    required String token,
    required String cartId,
    required int? amount,
    required List<int>? jumlahmultiSatuan,
    required List<int>? multisatuanjumlah,
    required bool isMultiCart,
  }) async {
    var url = Uri.parse("$baseURL/keranjang/$cartId");
    var header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      "skip_zrok_interstitial": "true",
    };
    Map data = {};

    if (isMultiCart) {
      // multi satuan
      data = {
        "jumlah_multisatuan": jumlahmultiSatuan,
        "multisatuan_jumlah": multisatuanjumlah,
      };
    } else {
      // single satuan
      data = {
        'jumlah': amount,
      };
    }

    var body = jsonEncode(data);
    var response = await http.put(
      url,
      headers: header,
      body: body,
    );

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);
      print("berhasil dengan isi $data");
      return data;
    } else {
      var data = jsonDecode(response.body);
      print("gagal dengan isi $data");
      throw ("${data['message']}");
    }
  }

  Future<Map<String, dynamic>> deleteCart({
    required String token,
    required String cartId,
  }) async {
    var url = Uri.parse("$baseURL/keranjang/$cartId");
    var header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      "skip_zrok_interstitial": "true",
    };
    var response = await http.delete(
      url,
      headers: header,
    );

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);
      print("berhasil dengan isi $data");
      return data;
    } else {
      var data = jsonDecode(response.body);
      print("gagal dengan isi $data");
      throw ("${data['message']}");
    }
  }

  Future<ProductModel> getCart(
      {required String token, required int cabangID}) async {
    var url = Uri.parse("$baseURL/keranjang?cabang=$cabangID");
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
      ProductModel productModel = ProductModel.fromJson(data);
      return productModel;
    } else {
      var data = jsonDecode(response.body);
      throw ("${data['message']}");
    }
  }
}
