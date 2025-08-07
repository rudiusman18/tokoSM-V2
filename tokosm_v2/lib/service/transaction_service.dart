// import 'package:tokosm_v2/shared/utils.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;
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



}
