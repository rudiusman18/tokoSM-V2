class TransactionModel {
  String? message;
  List<TransactionData>? data;

  TransactionModel({this.message, this.data});

  TransactionModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      if (json['data'] is List) {
        data = <TransactionData>[];
        json['data'].forEach((v) {
          data!.add(TransactionData.fromJson(v));
        });
      } else {
        data = <TransactionData>[TransactionData.fromJson(json['data'])];
      }
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

class TransactionData {
  String? sId;
  String? noInvoice;
  int? cabangId;
  dynamic gudangId;
  int? pegawaiId;
  String? namaPegawai;
  int? pelangganId;
  String? namaPelanggan;
  List<String>? namaProduk;
  int? jumlahProduk;
  int? subtotal;
  int? totalDiskon;
  int? totalOngkosKirim;
  int? total;
  int? laba;
  String? metodePembayaran;
  DetailPembayaran? detailPembayaran;
  int? sisaBayar;
  dynamic tglJatuhtempo;
  dynamic keterangan;
  int? status;
  String? keteranganStatus;
  Pengiriman? pengiriman;
  bool? online;
  String? createdAt;
  List<Produk>? produk;
  String? namaCabang;
  List<Bonus>? bonus;

  TransactionData(
      {this.sId,
      this.noInvoice,
      this.cabangId,
      this.gudangId,
      this.pegawaiId,
      this.namaPegawai,
      this.pelangganId,
      this.namaPelanggan,
      this.namaProduk,
      this.jumlahProduk,
      this.subtotal,
      this.totalDiskon,
      this.totalOngkosKirim,
      this.total,
      this.laba,
      this.metodePembayaran,
      this.detailPembayaran,
      this.sisaBayar,
      this.tglJatuhtempo,
      this.keterangan,
      this.status,
      this.keteranganStatus,
      this.pengiriman,
      this.online,
      this.createdAt,
      this.produk,
      this.namaCabang,
      this.bonus});

  TransactionData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    noInvoice = json['no_invoice'];
    cabangId = json['cabang_id'];
    gudangId = json['gudang_id'];
    pegawaiId = json['pegawai_id'];
    namaPegawai = json['nama_pegawai'];
    pelangganId = json['pelanggan_id'];
    namaPelanggan = json['nama_pelanggan'];
    namaProduk = json['nama_produk'].cast<String>();
    jumlahProduk = json['jumlah_produk'];
    subtotal = json['subtotal'];
    totalDiskon = json['total_diskon'];
    totalOngkosKirim = json['total_ongkos_kirim'];
    total = json['total'];
    laba = json['laba'];
    metodePembayaran = json['metode_pembayaran'];
    detailPembayaran = json['detail_pembayaran'] != null
        ? DetailPembayaran.fromJson(json['detail_pembayaran'])
        : null;
    sisaBayar = json['sisa_bayar'];
    tglJatuhtempo = json['tgl_jatuhtempo'];
    keterangan = json['keterangan'];
    status = json['status'];
    keteranganStatus = json['keterangan_status'];
    pengiriman = json['pengiriman'] != null
        ? Pengiriman.fromJson(json['pengiriman'])
        : null;
    online = json['online'];
    createdAt = json['created_at'];
    if (json['produk'] != null) {
      produk = <Produk>[];
      json['produk'].forEach((v) {
        produk!.add(Produk.fromJson(v));
      });
    }
    namaCabang = json['nama_cabang'];
    if (json['bonus'] != null) {
      bonus = <Bonus>[];
      json['bonus'].forEach((v) {
        bonus!.add(Bonus.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['no_invoice'] = noInvoice;
    data['cabang_id'] = cabangId;
    data['gudang_id'] = gudangId;
    data['pegawai_id'] = pegawaiId;
    data['nama_pegawai'] = namaPegawai;
    data['pelanggan_id'] = pelangganId;
    data['nama_pelanggan'] = namaPelanggan;
    data['nama_produk'] = namaProduk;
    data['jumlah_produk'] = jumlahProduk;
    data['subtotal'] = subtotal;
    data['total_diskon'] = totalDiskon;
    data['total_ongkos_kirim'] = totalOngkosKirim;
    data['total'] = total;
    data['laba'] = laba;
    data['metode_pembayaran'] = metodePembayaran;
    if (detailPembayaran != null) {
      data['detail_pembayaran'] = detailPembayaran!.toJson();
    }
    data['sisa_bayar'] = sisaBayar;
    data['tgl_jatuhtempo'] = tglJatuhtempo;
    data['keterangan'] = keterangan;
    data['status'] = status;
    data['keterangan_status'] = keteranganStatus;
    if (pengiriman != null) {
      data['pengiriman'] = pengiriman!.toJson();
    }
    data['online'] = online;
    data['created_at'] = createdAt;
    if (produk != null) {
      data['produk'] = produk!.map((v) => v.toJson()).toList();
    }
    data['nama_cabang'] = namaCabang;
    if (bonus != null) {
      data['bonus'] = bonus!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DetailPembayaran {
  dynamic bankId;
  String? namaBank;
  dynamic bankPengirim;
  dynamic norekeningPengirim;
  dynamic namaPengirim;
  dynamic buktiTransfer;

  DetailPembayaran(
      {this.bankId,
      this.namaBank,
      this.bankPengirim,
      this.norekeningPengirim,
      this.namaPengirim,
      this.buktiTransfer});

  DetailPembayaran.fromJson(Map<String, dynamic> json) {
    bankId = json['bank_id'];
    namaBank = json['nama_bank'];
    bankPengirim = json['bank_pengirim'];
    norekeningPengirim = json['norekening_pengirim'];
    namaPengirim = json['nama_pengirim'];
    buktiTransfer = json['bukti_transfer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bank_id'] = bankId;
    data['nama_bank'] = namaBank;
    data['bank_pengirim'] = bankPengirim;
    data['norekening_pengirim'] = norekeningPengirim;
    data['nama_pengirim'] = namaPengirim;
    data['bukti_transfer'] = buktiTransfer;
    return data;
  }
}

class Pengiriman {
  dynamic noResi;
  String? kurir;
  String? namaLayanan;
  String? namaPenerima;
  String? telpPenerima;
  String? alamatLengkap;
  String? catatan;
  dynamic lat;
  dynamic lng;

  Pengiriman(
      {this.noResi,
      this.kurir,
      this.namaLayanan,
      this.namaPenerima,
      this.telpPenerima,
      this.alamatLengkap,
      this.catatan,
      this.lat,
      this.lng});

  Pengiriman.fromJson(Map<String, dynamic> json) {
    noResi = json['no_resi'];
    kurir = json['kurir'];
    namaLayanan = json['nama_layanan'];
    namaPenerima = json['nama_penerima'];
    telpPenerima = json['telp_penerima'];
    alamatLengkap = json['alamat_lengkap'];
    catatan = json['catatan'];
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['no_resi'] = noResi;
    data['kurir'] = kurir;
    data['nama_layanan'] = namaLayanan;
    data['nama_penerima'] = namaPenerima;
    data['telp_penerima'] = telpPenerima;
    data['alamat_lengkap'] = alamatLengkap;
    data['catatan'] = catatan;
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}

class Produk {
  String? sId;
  String? namaProduk;
  String? gambarProduk;
  int? hargaProduk;
  int? jumlah;

  Produk(
      {this.sId,
      this.namaProduk,
      this.gambarProduk,
      this.hargaProduk,
      this.jumlah});

  Produk.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    namaProduk = json['nama_produk'];
    gambarProduk = json['gambar_produk'];
    hargaProduk = json['harga_produk'];
    jumlah = json['jumlah'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['nama_produk'] = namaProduk;
    data['gambar_produk'] = gambarProduk;
    data['harga_produk'] = hargaProduk;
    data['jumlah'] = jumlah;
    return data;
  }
}

class Bonus {
  int? promoId;
  int? bonusId;
  String? tipeBonus;
  String? namaPromo;
  String? namaBonus;
  int? jumlahBonus;

  Bonus(
      {this.promoId,
      this.bonusId,
      this.tipeBonus,
      this.namaPromo,
      this.namaBonus,
      this.jumlahBonus});

  Bonus.fromJson(Map<String, dynamic> json) {
    promoId = json['promo_id'];
    bonusId = json['bonus_id'];
    tipeBonus = json['tipe_bonus'];
    namaPromo = json['nama_promo'];
    namaBonus = json['nama_bonus'];
    jumlahBonus = json['jumlah_bonus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['promo_id'] = promoId;
    data['bonus_id'] = bonusId;
    data['tipe_bonus'] = tipeBonus;
    data['nama_promo'] = namaPromo;
    data['nama_bonus'] = namaBonus;
    data['jumlah_bonus'] = jumlahBonus;
    return data;
  }
}
