class ProductModel {
  String? message;
  List<DataProduct>? data;

  ProductModel({this.message, this.data});

  ProductModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <DataProduct>[];
      json['data'].forEach((v) {
        data!.add(DataProduct.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['message'] = message;
    if (data != null) {
      result['data'] = data!.map((v) => v.toJson()).toList();
    }
    return result;
  }
}

class DataProduct {
  dynamic cartId;
  dynamic id;
  dynamic cabangId;
  dynamic produkKategoriId;
  String? kodeProduk;
  List<String>? barcodeProduk;
  String? namaProduk;
  String? deskripsiProduk;
  dynamic kategoriProduk;
  String? satuanProduk;
  List<String>? golonganProduk;
  String? merkProduk;
  List<String>? dimensiProduk;
  dynamic beratProduk;
  dynamic hargaPokok;
  dynamic hargaProduk;
  dynamic hargaDiskon;
  dynamic hargaGrosir;
  String? grosirProduk;
  dynamic diskon;
  dynamic jumlah;
  String? keteranganPromo;
  List<dynamic>? jumlahMultisatuan;
  List<String>? gambarProduk;
  List<String>? multisatuanJumlah;
  List<String>? multisatuanUnit;
  String? namaPromo;
  dynamic nominalDiskon;
  dynamic diskonMinBeli;
  dynamic diskonMaxBeli;
  dynamic flashsale;
  dynamic flashsaleKuantitas;
  dynamic flashsaleLimit;
  String? kategori;
  String? kategoriSlug;
  dynamic flashsaleTerjual;
  dynamic flashsaleNominal;
  String? flashsaleSatuan;
  String? flashsaleEnd;
  dynamic hargaProdukFlashsale;
  dynamic hargaDiskonFlashsale;
  dynamic isAktiva;
  dynamic isMultisatuan;
  dynamic isGrosir;
  dynamic isDiskon;
  dynamic isPromo;
  dynamic isFlashsale;
  dynamic view;
  dynamic viewMonth;
  dynamic terjual;
  dynamic persentaseDiskon;
  dynamic persentaseFlashsale;
  dynamic rating;

  DataProduct({
    this.cartId,
    this.id,
    this.cabangId,
    this.produkKategoriId,
    this.keteranganPromo,
    this.kodeProduk,
    this.barcodeProduk,
    this.namaProduk,
    this.deskripsiProduk,
    this.kategoriProduk,
    this.satuanProduk,
    this.golonganProduk,
    this.merkProduk,
    this.dimensiProduk,
    this.beratProduk,
    this.hargaPokok,
    this.hargaProduk,
    this.hargaDiskon,
    this.hargaGrosir,
    this.diskon,
    this.gambarProduk,
    this.jumlah,
    this.multisatuanJumlah,
    this.multisatuanUnit,
    this.jumlahMultisatuan,
    this.namaPromo,
    this.nominalDiskon,
    this.diskonMinBeli,
    this.diskonMaxBeli,
    this.flashsale,
    this.flashsaleKuantitas,
    this.flashsaleLimit,
    this.flashsaleTerjual,
    this.flashsaleNominal,
    this.flashsaleSatuan,
    this.flashsaleEnd,
    this.hargaProdukFlashsale,
    this.hargaDiskonFlashsale,
    this.isAktiva,
    this.isMultisatuan,
    this.isGrosir,
    this.isDiskon,
    this.isPromo,
    this.isFlashsale,
    this.view,
    this.kategori,
    this.kategoriSlug,
    this.grosirProduk,
    this.viewMonth,
    this.terjual,
    this.persentaseDiskon,
    this.persentaseFlashsale,
    this.rating,
  });

  DataProduct.fromJson(Map<String, dynamic> json) {
    cartId = json['_id'];
    id = json['id'] ?? json['produk_id'];
    cabangId = json['cabang_id'];
    produkKategoriId = json['produk_kategori_id'];
    kodeProduk = json['kode_produk'];
    keteranganPromo = json['keterangan_promo'];
    kategori = json['kategori'];
    kategoriSlug = json['kategori_slug'];

    // ✅ barcode_produk bisa List atau String
    if (json['barcode_produk'] is List) {
      barcodeProduk =
          (json['barcode_produk'] as List).map((e) => e.toString()).toList();
    } else if (json['barcode_produk'] != null &&
        json['barcode_produk'].toString().isNotEmpty) {
      barcodeProduk = [json['barcode_produk'].toString()];
    }

    namaProduk = json['nama_produk'];
    deskripsiProduk = json['deskripsi_produk'];
    kategoriProduk = json['kategori_produk'];
    satuanProduk = json['satuan_produk'];
    grosirProduk = json['grosir_produk'];

    // ✅ golongan_produk bisa List atau String
    if (json['golongan_produk'] is List) {
      golonganProduk =
          (json['golongan_produk'] as List).map((e) => e.toString()).toList();
    } else if (json['golongan_produk'] != null) {
      golonganProduk = [json['golongan_produk'].toString()];
    }

    merkProduk = json['merk_produk'];

    // ✅ dimensi_produk bisa List atau String
    if (json['dimensi_produk'] is List) {
      dimensiProduk =
          (json['dimensi_produk'] as List).map((e) => e.toString()).toList();
    } else if (json['dimensi_produk'] != null) {
      dimensiProduk = [json['dimensi_produk'].toString()];
    }

    beratProduk = json['berat_produk'];
    hargaPokok = json['harga_pokok'];
    hargaProduk = json['harga_produk'];
    hargaDiskon = json['harga_diskon'];
    hargaGrosir = json['harga_grosir'];
    diskon = json['diskon'];
    jumlah = json['jumlah'];

    // ✅ gambar_produk selalu List
    gambarProduk =
        (json['gambar_produk'] as List?)?.map((e) => e.toString()).toList();

    // ✅ multisatuan bisa List atau null
    multisatuanJumlah = (json['multisatuan_jumlah'] as List?)
        ?.map((e) => e.toString())
        .toList();
    multisatuanUnit =
        (json['multisatuan_unit'] as List?)?.map((e) => e.toString()).toList();

    jumlahMultisatuan = (json['jumlah_multisatuan'] is List)
        ? json['jumlah_multisatuan']
        : null;

    namaPromo = json['nama_promo'];
    nominalDiskon = json['nominal_diskon'];
    diskonMinBeli = json['diskon_min_beli'];
    diskonMaxBeli = json['diskon_max_beli'];
    flashsale = json['flashsale'];
    flashsaleKuantitas = json['flashsale_kuantitas'];
    flashsaleLimit = json['flashsale_limit'];
    flashsaleTerjual = json['flashsale_terjual'];
    flashsaleNominal = json['flashsale_nominal'];
    flashsaleSatuan = json['flashsale_satuan'];
    flashsaleEnd = json['flashsale_end'];
    hargaProdukFlashsale = json['harga_produk_flashsale'];
    hargaDiskonFlashsale = json['harga_diskon_flashsale'];
    isAktiva = json['is_aktiva'];
    isMultisatuan = json['is_multisatuan'];
    isGrosir = json['is_grosir'];
    isDiskon = json['is_diskon'];
    isPromo = json['is_promo'];
    isFlashsale = json['is_flashsale'];
    view = json['view'];
    viewMonth = json['view_month'];
    terjual = json['terjual'];
    persentaseDiskon = (json['persentase_diskon'] is num)
        ? (json['persentase_diskon'] as num).toDouble()
        : null;
    persentaseFlashsale = (json['persentase_flashsale'] is num)
        ? (json['persentase_flashsale'] as num).toDouble()
        : null;
    rating =
        (json['rating'] is num) ? (json['rating'] as num).toDouble() : null;
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': cartId,
      'id': id,
      'cabang_id': cabangId,
      'produk_kategori_id': produkKategoriId,
      'keterangan_promo': keteranganPromo,
      'kode_produk': kodeProduk,
      'barcode_produk': barcodeProduk,
      'nama_produk': namaProduk,
      'deskripsi_produk': deskripsiProduk,
      'kategori_produk': kategoriProduk,
      'satuan_produk': satuanProduk,
      'golongan_produk': golonganProduk,
      'merk_produk': merkProduk,
      'dimensi_produk': dimensiProduk,
      'berat_produk': beratProduk,
      'harga_pokok': hargaPokok,
      'harga_produk': hargaProduk,
      'harga_diskon': hargaDiskon,
      'harga_grosir': hargaGrosir,
      'grosir_produk': grosirProduk,
      'diskon': diskon,
      'jumlah': jumlah,
      'gambar_produk': gambarProduk,
      'multisatuan_jumlah': multisatuanJumlah,
      'multisatuan_unit': multisatuanUnit,
      'jumlah_multisatuan': jumlahMultisatuan,
      'nama_promo': namaPromo,
      'nominal_diskon': nominalDiskon,
      'diskon_min_beli': diskonMinBeli,
      'diskon_max_beli': diskonMaxBeli,
      'flashsale': flashsale,
      'kategori': kategori,
      'kategori_slug': kategoriSlug,
      'flashsale_kuantitas': flashsaleKuantitas,
      'flashsale_limit': flashsaleLimit,
      'flashsale_terjual': flashsaleTerjual,
      'flashsale_nominal': flashsaleNominal,
      'flashsale_satuan': flashsaleSatuan,
      'flashsale_end': flashsaleEnd,
      'harga_produk_flashsale': hargaProdukFlashsale,
      'harga_diskon_flashsale': hargaDiskonFlashsale,
      'is_aktiva': isAktiva,
      'is_multisatuan': isMultisatuan,
      'is_grosir': isGrosir,
      'is_diskon': isDiskon,
      'is_promo': isPromo,
      'is_flashsale': isFlashsale,
      'view': view,
      'view_month': viewMonth,
      'terjual': terjual,
      'persentase_diskon': persentaseDiskon,
      'persentase_flashsale': persentaseFlashsale,
      'rating': rating,
    };
  }
}

class DetailProductModel {
  String? message;
  DataProduct? data;

  DetailProductModel({this.message, this.data});

  DetailProductModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? DataProduct.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    return data;
  }
}
