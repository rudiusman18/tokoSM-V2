import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tokosm_v2/model/address_model.dart';
import 'package:tokosm_v2/shared/utils.dart';

class AddressService {
  Future<AddressModel> getAddress({
    required String token,
  }) async {
    var url = Uri.parse("$baseURL/akun/alamat");
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
      AddressModel addressModel = AddressModel.fromJson(data);
      return addressModel;
    } else {
      var data = jsonDecode(response.body);
      throw ("${data['message']}");
    }
  }

  Future<void> postAddress(
      {required String token,
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
      required bool isUtama}) async {
    var url = Uri.parse("$baseURL/akun/alamat");
    var header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      "skip_zrok_interstitial": "true",
    };

    Map data = {
      "nama_alamat": addressName,
      "nama_penerima": receiverName,
      "telp_penerima": phoneNumber,
      "alamat_lengkap": address,
      "provinsi": province,
      "kabkota": city,
      "kecamatan": district,
      "kelurahan": subdistrict,
      "kodepos": postCode,
      "catatan": note,
      "lat": double.tryParse(lat),
      "lng": double.tryParse(lng),
      "is_utama": isUtama == true ? 1 : 0,
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

  Future<void> updateAddress({
    required String addressID,
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
    required bool isUtama,
  }) async {
    var url = Uri.parse("$baseURL/akun/alamat/$addressID");
    var header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      "skip_zrok_interstitial": "true",
    };

    Map data = {
      "nama_alamat": addressName,
      "nama_penerima": receiverName,
      "telp_penerima": phoneNumber,
      "alamat_lengkap": address,
      "provinsi": province,
      "kabkota": city,
      "kecamatan": district,
      "kelurahan": subdistrict,
      "kodepos": postCode,
      "catatan": note,
      "lat": double.tryParse(lat),
      "lng": double.tryParse(lng),
      "is_utama": isUtama == true ? 1 : 0,
    };

    var body = jsonEncode(data);

    var response = await http.put(
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

  Future<void> deleteAddress({
    required String addressID,
    required String token,
  }) async {
    var url = Uri.parse("$baseURL/akun/alamat/$addressID");
    var header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var response = await http.delete(
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

  Future<Map<String, dynamic>> getMapLocation({required String userID}) async {
    var url =
        Uri.parse("http://10.10.10.98:3000/apipos/v1/map/customer/$userID");
    var header = {
      'Content-Type': 'application/json',
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
