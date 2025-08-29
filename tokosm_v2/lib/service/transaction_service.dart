// import 'package:tokosm_v2/shared/utils.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tokosm_v2/model/product_model.dart';
import 'package:tokosm_v2/model/transaction_model.dart';
import 'package:tokosm_v2/shared/utils.dart';

class TransactionService {
  Future<TransactionModel> getTransaction({
    required String token,
    required String cabangId,
    required String status,
    required String search,
    int page = 1,
    int limit = 10,
  }) async {
    var url = Uri.parse(
      "$baseURL/transaksi?cabang=$cabangId&status=$status&q=$search&page=$page&limit=$limit",
    );

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
      final TransactionModel transactionModel = TransactionModel.fromJson(data);

      return transactionModel;
    } else {
      var data = jsonDecode(response.body);
      throw ("${data['message']}");
    }
  }

  Future<TransactionModel> getDetailTransaction({
    required String token,
    required String noInvoice,
  }) async {
    var url = Uri.parse(
      "$baseURL/transaksi/detail/$noInvoice",
    );

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
      final TransactionModel transactionModel = TransactionModel.fromJson(data);

      return transactionModel;
    } else {
      var data = jsonDecode(response.body);
      throw ("${data['message']}");
    }
  }

  Future<void> postTransaction({
    required String token,
    required String cabangId,
    required String userId,
    required String username,
    required String total,
    required String paymentMethod,
    required String addressID,
    required String courier,
    required String courierService,
    required List<DataProduct> products,
  }) async {
    var url = Uri.parse("$baseURL/transaksi");
    var header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      "skip_zrok_interstitial": "true",
    };

    // hitung subtotal dari produk
    num subtotal = products.fold<num>(0, (prev, e) {
      return prev + ((e.jumlah ?? 0) * (e.hargaProduk ?? 0));
    });

    Map<String, dynamic> data = {
      "cabang_id": int.tryParse(cabangId),
      "pelanggan_id": int.tryParse(userId),
      "nama_pelanggan": username,
      "subtotal": subtotal,
      "total_diskon": 5000, // sementara hardcode
      "total_ongkos_kirim": 15000,
      "total": int.tryParse(total),
      "metode_pembayaran":
          paymentMethod.toLowerCase().contains("cod") ? "cod" : "transfer",
      "bank_transfer_id": paymentMethod.toLowerCase().contains("cod")
          ? null
          : paymentMethod.toLowerCase().contains("bank bca")
              ? 1
              : paymentMethod.toLowerCase().contains("bank bri")
                  ? 2
                  : 3,
      "bank_transfer_nama": paymentMethod.toLowerCase() != "cod"
          ? paymentMethod.replaceAll("bank ", "")
          : null,
      "kurir": courier, // toko, jne, j&t
      "layanan_kurir": courierService.toLowerCase(),
      "pengiriman_id": int.tryParse(addressID),
      "produk": products.map((e) => e.toJson()).toList(),
      "bonus": null,
    };

    print("data yang dikirim adalah: $data");

    var body = jsonEncode(data);

    var response = await http.post(
      url,
      headers: header,
      body: body,
    );

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);

      print("isi data adalah $data");

      return data;
    } else {
      var data = jsonDecode(response.body);

      print("isi data adalah $data");

      throw ("${data['message']}");
    }
  }
}
