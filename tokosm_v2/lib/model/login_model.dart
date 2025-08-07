class LoginModel {
  String? token;
  Data? data;

  LoginModel({this.token, this.data});

  LoginModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  int? cabangId;
  int? cabangRegister;
  int? salesId;
  int? kategoriPelangganId;
  String? username;
  String? password;
  String? namaPelanggan;
  String? tglLahirPelanggan;
  String? jenisKelaminPelanggan;
  String? telpPelanggan;
  String? emailPelanggan;
  String? alamatPelanggan;
  String? provinsi;
  String? kabkota;
  String? kecamatan;
  String? kelurahan;
  dynamic kodepos;
  String? lat;
  String? lng;
  int? cod;
  int? kredit;
  int? transfer;
  int? transaksi;
  int? nominal;
  String? createdBy;
  String? lasttrxAt;
  String? namaCabang;

  Data(
      {this.id,
      this.cabangId,
      this.cabangRegister,
      this.salesId,
      this.kategoriPelangganId,
      this.username,
      this.password,
      this.namaPelanggan,
      this.tglLahirPelanggan,
      this.jenisKelaminPelanggan,
      this.telpPelanggan,
      this.emailPelanggan,
      this.alamatPelanggan,
      this.provinsi,
      this.kabkota,
      this.kecamatan,
      this.kelurahan,
      this.kodepos,
      this.lat,
      this.lng,
      this.cod,
      this.kredit,
      this.transfer,
      this.transaksi,
      this.nominal,
      this.createdBy,
      this.lasttrxAt,
      this.namaCabang});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cabangId = json['cabang_id'];
    cabangRegister = json['cabang_register'];
    salesId = json['sales_id'];
    kategoriPelangganId = json['kategori_pelanggan_id'];
    username = json['username'];
    password = json['password'];
    namaPelanggan = json['nama_pelanggan'];
    tglLahirPelanggan = json['tgl_lahir_pelanggan'];
    jenisKelaminPelanggan = json['jenis_kelamin_pelanggan'];
    telpPelanggan = json['telp_pelanggan'];
    emailPelanggan = json['email_pelanggan'];
    alamatPelanggan = json['alamat_pelanggan'];
    provinsi = json['provinsi'];
    kabkota = json['kabkota'];
    kecamatan = json['kecamatan'];
    kelurahan = json['kelurahan'];
    kodepos = json['kodepos'];
    lat = json['lat'];
    lng = json['lng'];
    cod = json['cod'];
    kredit = json['kredit'];
    transfer = json['transfer'];
    transaksi = json['transaksi'];
    nominal = json['nominal'];
    createdBy = json['created_by'];
    lasttrxAt = json['lasttrx_at'];
    namaCabang = json['nama_cabang'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cabang_id'] = cabangId;
    data['cabang_register'] = cabangRegister;
    data['sales_id'] = salesId;
    data['kategori_pelanggan_id'] = kategoriPelangganId;
    data['username'] = username;
    data['password'] = password;
    data['nama_pelanggan'] = namaPelanggan;
    data['tgl_lahir_pelanggan'] = tglLahirPelanggan;
    data['jenis_kelamin_pelanggan'] = jenisKelaminPelanggan;
    data['telp_pelanggan'] = telpPelanggan;
    data['email_pelanggan'] = emailPelanggan;
    data['alamat_pelanggan'] = alamatPelanggan;
    data['provinsi'] = provinsi;
    data['kabkota'] = kabkota;
    data['kecamatan'] = kecamatan;
    data['kelurahan'] = kelurahan;
    data['kodepos'] = kodepos;
    data['lat'] = lat;
    data['lng'] = lng;
    data['cod'] = cod;
    data['kredit'] = kredit;
    data['transfer'] = transfer;
    data['transaksi'] = transaksi;
    data['nominal'] = nominal;
    data['created_by'] = createdBy;
    data['lasttrx_at'] = lasttrxAt;
    data['nama_cabang'] = namaCabang;
    return data;
  }
}
