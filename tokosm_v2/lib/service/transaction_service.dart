// import 'package:tokosm_v2/shared/utils.dart';

// class TransactionService {
//   Future<ProductModel> getProduct({
//     required String token,
//     required String search,
//     required int cabangId,
//     required String type,
//     required String sort,
//     required String cat,
//     required String minrating,
//     required String minprice,
//     required String maxprice,
//     int page = 1,
//     int limit = 10,
//   }) async {
//     var url = Uri.parse(
//       "$baseURL/produk?cabang=$cabangId&type=$type&page=$page&limit=$limit&sort=$sort&cat=$cat&minrating=$minrating&minprice=$minprice&maxprice=$maxprice&q=$search",
//     );
//     var header = {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer $token',
//     };

//     var response = await http.get(
//       url,
//       headers: header,
//     );

//     if (response.statusCode >= 200 && response.statusCode <= 299) {
//       var data = jsonDecode(response.body);
//       final ProductModel productModel = ProductModel.fromJson(data);
//       return productModel;
//     } else {
//       var data = jsonDecode(response.body);
//       throw ("${data['message']}");
//     }
//   }
// }
