class TransactionModel {
  String? message;
  List<TransactionData>? data;

  TransactionModel({this.message, this.data});

  TransactionModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];

    if (json['data'] is List) {
      data = (json['data'] as List)
          .map((e) => TransactionData.fromJson(e))
          .toList();
    } else if (json['data'] is Map<String, dynamic>) {
      data = [TransactionData.fromJson(json['data'])];
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }
}

class TransactionData {
  String? id;
  String? noInvoice;
  int? cabangId;
  int? gudangId;
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
  int? sisaBayar;
  String? tglJatuhTempo;
  String? keterangan;
  int? status;
  String? keteranganStatus;
  bool? online;
  String? createdAt;
  String? namaCabang;
  List<Produk>? produk;
  Pengiriman? pengiriman;
  List<Bonus>? bonus;

  TransactionData({
    this.id,
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
    this.sisaBayar,
    this.tglJatuhTempo,
    this.keterangan,
    this.status,
    this.keteranganStatus,
    this.online,
    this.createdAt,
    this.namaCabang,
    this.produk,
    this.pengiriman,
    this.bonus,
  });

  TransactionData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    noInvoice = json['no_invoice'];
    cabangId = json['cabang_id'];
    gudangId = json['gudang_id'];
    pegawaiId = json['pegawai_id'];
    namaPegawai = json['nama_pegawai'];
    pelangganId = json['pelanggan_id'];
    namaPelanggan = json['nama_pelanggan'];
    namaProduk = (json['nama_produk'] as List?)?.cast<String>();
    jumlahProduk = json['jumlah_produk'];
    subtotal = json['subtotal'];
    totalDiskon = json['total_diskon'];
    totalOngkosKirim = json['total_ongkos_kirim'];
    total = json['total'];
    laba = json['laba'];
    metodePembayaran = json['metode_pembayaran'];
    sisaBayar = json['sisa_bayar'];
    tglJatuhTempo = json['tgl_jatuhtempo'];
    keterangan = json['keterangan'];
    status = json['status'];
    keteranganStatus = json['keterangan_status'];
    online = json['online'];
    createdAt = json['created_at'];
    namaCabang = json['nama_cabang'];

    if (json['produk'] != null && json['produk'] is List) {
      produk = (json['produk'] as List).map((e) => Produk.fromJson(e)).toList();
    }

    if (json['pengiriman'] != null &&
        json['pengiriman'] is Map<String, dynamic>) {
      pengiriman = Pengiriman.fromJson(json['pengiriman']);
    }

    if (json['bonus'] != null && json['bonus'] is List) {
      bonus = (json['bonus'] as List).map((e) => Bonus.fromJson(e)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'no_invoice': noInvoice,
      'cabang_id': cabangId,
      'gudang_id': gudangId,
      'pegawai_id': pegawaiId,
      'nama_pegawai': namaPegawai,
      'pelanggan_id': pelangganId,
      'nama_pelanggan': namaPelanggan,
      'nama_produk': namaProduk,
      'jumlah_produk': jumlahProduk,
      'subtotal': subtotal,
      'total_diskon': totalDiskon,
      'total_ongkos_kirim': totalOngkosKirim,
      'total': total,
      'laba': laba,
      'metode_pembayaran': metodePembayaran,
      'sisa_bayar': sisaBayar,
      'tgl_jatuhtempo': tglJatuhTempo,
      'keterangan': keterangan,
      'status': status,
      'keterangan_status': keteranganStatus,
      'online': online,
      'created_at': createdAt,
      'nama_cabang': namaCabang,
      'produk': produk?.map((e) => e.toJson()).toList(),
      'pengiriman': pengiriman?.toJson(),
      'bonus': bonus?.map((e) => e.toJson()).toList(),
    };
  }
}

class Produk {
  String? id;
  String? noInvoice;
  int? cabangId;
  int? gudangId;
  int? produkId;
  String? namaProduk;
  String? gambarProduk;
  String? satuanProduk;
  String? golonganProduk;
  String? rakProduk;
  int? rakBintang;
  String? kategori;
  String? kategoriSlug;
  int? hargaPokok;
  int? hargaProduk;
  List<HargaGrosir>? hargaGrosir;
  int? hargaDiskon;
  int? diskonProduk;
  int? diskonMaxBeli;
  int? jumlah;
  List<dynamic>? jumlahMultisatuan;
  int? jumlahDiskon;
  int? isMultisatuan;
  int? isGrosir;
  bool? grosir;
  int? subtotal;
  int? totalDiskon;
  int? totalHarga;
  int? totalLaba;
  String? createdAt;

  Produk.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    noInvoice = json['no_invoice'];
    cabangId = json['cabang_id'];
    gudangId = json['gudang_id'];
    produkId = json['produk_id'];
    namaProduk = json['nama_produk'];
    gambarProduk = json['gambar_produk'];
    satuanProduk = json['satuan_produk'];
    golonganProduk = json['golongan_produk'];
    rakProduk = json['rak_produk'];
    rakBintang = json['rak_bintang'];
    kategori = json['kategori'];
    kategoriSlug = json['kategori_slug'];
    hargaPokok = json['harga_pokok'];
    hargaProduk = json['harga_produk'];
    hargaDiskon = json['harga_diskon'];
    diskonProduk = json['diskon_produk'];
    diskonMaxBeli = json['diskon_max_beli'];
    jumlah = json['jumlah'];
    jumlahMultisatuan = json['jumlah_multisatuan'];
    jumlahDiskon = json['jumlah_diskon'];
    isMultisatuan = json['is_multisatuan'];
    isGrosir = json['is_grosir'];
    grosir = json['grosir'];
    subtotal = json['subtotal'];
    totalDiskon = json['total_diskon'];
    totalHarga = json['total_harga'];
    totalLaba = json['total_laba'];
    createdAt = json['created_at'];

    if (json['harga_grosir'] != null) {
      hargaGrosir = (json['harga_grosir'] as List)
          .map((e) => HargaGrosir.fromJson(e))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'no_invoice': noInvoice,
      'cabang_id': cabangId,
      'gudang_id': gudangId,
      'produk_id': produkId,
      'nama_produk': namaProduk,
      'gambar_produk': gambarProduk,
      'satuan_produk': satuanProduk,
      'golongan_produk': golonganProduk,
      'rak_produk': rakProduk,
      'rak_bintang': rakBintang,
      'kategori': kategori,
      'kategori_slug': kategoriSlug,
      'harga_pokok': hargaPokok,
      'harga_produk': hargaProduk,
      'harga_grosir': hargaGrosir?.map((e) => e.toJson()).toList(),
      'harga_diskon': hargaDiskon,
      'diskon_produk': diskonProduk,
      'diskon_max_beli': diskonMaxBeli,
      'jumlah': jumlah,
      'jumlah_multisatuan': jumlahMultisatuan,
      'jumlah_diskon': jumlahDiskon,
      'is_multisatuan': isMultisatuan,
      'is_grosir': isGrosir,
      'grosir': grosir,
      'subtotal': subtotal,
      'total_diskon': totalDiskon,
      'total_harga': totalHarga,
      'total_laba': totalLaba,
      'created_at': createdAt,
    };
  }
}

class HargaGrosir {
  int? min;
  int? harga;

  HargaGrosir({this.min, this.harga});

  HargaGrosir.fromJson(Map<String, dynamic> json) {
    min = json['min'];
    harga = json['harga'];
  }

  Map<String, dynamic> toJson() {
    return {
      'min': min,
      'harga': harga,
    };
  }
}

class Pengiriman {
  String? namaPenerima;
  String? telpPenerima;
  String? alamatLengkap;
  String? catatan;
  String? kurir;
  String? noresi;
  double? lat;
  double? lng;

  Pengiriman.fromJson(Map<String, dynamic> json) {
    namaPenerima = json['nama_penerima'];
    telpPenerima = json['telp_penerima'];
    alamatLengkap = json['alamat_lengkap'];
    catatan = json['catatan'];
    kurir = json['kurir'];
    noresi = json['no_resi'];
    lat = (json['lat'] is int) ? (json['lat'] as int).toDouble() : json['lat'];
    lng = (json['lng'] is int) ? (json['lng'] as int).toDouble() : json['lng'];
  }

  Map<String, dynamic> toJson() {
    return {
      'nama_penerima': namaPenerima,
      'telp_penerima': telpPenerima,
      'alamat_lengkap': alamatLengkap,
      'catatan': catatan,
      'lat': lat,
      'lng': lng,
      'kurir': kurir,
      'no_resi': noresi,
    };
  }
}

class Bonus {
  int? promoId;
  int? bonusId;
  String? tipeBonus;
  String? namaPromo;
  String? namaBonus;
  int? jumlahBonus;

  Bonus.fromJson(Map<String, dynamic> json) {
    promoId = json['promo_id'];
    bonusId = json['bonus_id'];
    tipeBonus = json['tipe_bonus'];
    namaPromo = json['nama_promo'];
    namaBonus = json['nama_bonus'];
    jumlahBonus = json['jumlah_bonus'];
  }

  Map<String, dynamic> toJson() {
    return {
      'promo_id': promoId,
      'bonus_id': bonusId,
      'tipe_bonus': tipeBonus,
      'nama_promo': namaPromo,
      'nama_bonus': namaBonus,
      'jumlah_bonus': jumlahBonus,
    };
  }
}
