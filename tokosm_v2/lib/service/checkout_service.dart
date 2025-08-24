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

  Future<void> postAddress({
    required String token,
    required String addressName,
    required String receiverName,
    required String phoneNumber,
    required String address,
    required String province,
    required String city,
    required String district,
    required String subdistrict,
    required String postCode,
    required String note,
    required String lat,
    required String lng,
  }) async {
    var url = Uri.parse("$baseURL/akun/alamat");
    var header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    Map data = {
      "nama_alamat": addressName,
      "nama_penerima": receiverName,
      "telp_penerima": phoneNumber,
      "alamat_lengkap": addressName,
      "provinsi": province,
      "kabkota": city,
      "kecamatan": district,
      "kelurahan": subdistrict,
      "kodepos": postCode,
      "catatan": note,
      "lat": double.tryParse(lat),
      "lng": double.tryParse(lng),
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
