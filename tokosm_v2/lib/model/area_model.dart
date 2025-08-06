// ignore_for_file: unnecessary_new, unnecessary_this, prefer_collection_literals

class AreaModel {
  String? message;
  List<Data>? data;

  AreaModel({this.message, this.data});

  AreaModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? kemendagri;
  String? kodepos;
  String? kelurahan;
  String? kecamatan;
  String? kota;
  String? provinsi;

  Data(
      {this.kemendagri,
      this.kodepos,
      this.kelurahan,
      this.kecamatan,
      this.kota,
      this.provinsi});

  Data.fromJson(Map<String, dynamic> json) {
    kemendagri = json['kemendagri'];
    kodepos = json['kodepos'];
    kelurahan = json['kelurahan'];
    kecamatan = json['kecamatan'];
    kota = json['kota'];
    provinsi = json['provinsi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kemendagri'] = this.kemendagri;
    data['kodepos'] = this.kodepos;
    data['kelurahan'] = this.kelurahan;
    data['kecamatan'] = this.kecamatan;
    data['kota'] = this.kota;
    data['provinsi'] = this.provinsi;
    return data;
  }
}
