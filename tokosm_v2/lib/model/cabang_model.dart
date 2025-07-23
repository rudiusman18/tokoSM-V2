class CabangModel {
  String? message;
  List<DataCabang>? data;

  CabangModel({this.message, this.data});

  CabangModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <DataCabang>[];
      json['data'].forEach((v) {
        data!.add(DataCabang.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataCabang {
  int? id;
  int? cabangKelasId;
  String? namaCabang;
  String? alamatCabang;
  double? latitude;
  double? longitude;
  int? transaksiOffline;
  int? transaksiOnline;
  int? stokIdeal;
  int? maxBudget;
  int? radiusPengiriman;

  DataCabang(
      {this.id,
      this.cabangKelasId,
      this.namaCabang,
      this.alamatCabang,
      this.latitude,
      this.longitude,
      this.transaksiOffline,
      this.transaksiOnline,
      this.stokIdeal,
      this.maxBudget,
      this.radiusPengiriman});

  DataCabang.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cabangKelasId = json['cabang_kelas_id'];
    namaCabang = json['nama_cabang'];
    alamatCabang = json['alamat_cabang'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    transaksiOffline = json['transaksi_offline'];
    transaksiOnline = json['transaksi_online'];
    stokIdeal = json['stok_ideal'];
    maxBudget = json['max_budget'];
    radiusPengiriman = json['radius_pengiriman'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cabang_kelas_id'] = cabangKelasId;
    data['nama_cabang'] = namaCabang;
    data['alamat_cabang'] = alamatCabang;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['transaksi_offline'] = transaksiOffline;
    data['transaksi_online'] = transaksiOnline;
    data['stok_ideal'] = stokIdeal;
    data['max_budget'] = maxBudget;
    data['radius_pengiriman'] = radiusPengiriman;
    return data;
  }
}
