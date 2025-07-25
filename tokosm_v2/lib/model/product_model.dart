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
  dynamic id;
  dynamic cabangId;
  dynamic produkKategoriId;
  String? kodeProduk;
  String? barcodeProduk;
  String? namaProduk;
  String? deskripsiProduk;
  String? kategoriProduk;
  String? satuanProduk;
  List<String>? satuanProdukList;
  String? golonganProduk;
  String? merkProduk;
  String? dimensiProduk;
  dynamic beratProduk;
  dynamic hargaPokok;
  dynamic hargaProduk;
  dynamic hargaDiskon;
  dynamic diskon;
  List<String>? gambarProduk;
  String? multisatuanJumlah;
  String? multisatuanUnit;
  List<dynamic>? multisatuanJumlahList;
  List<String>? multisatuanUnitList;
  String? namaPromo;
  String? keteranganPromo;
  dynamic flashsale;
  dynamic flashsaleKuantitas;
  dynamic flashsaleLimit;
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
  String? grosirProduk;

  DataProduct(
      {this.id,
      this.cabangId,
      this.produkKategoriId,
      this.kodeProduk,
      this.barcodeProduk,
      this.namaProduk,
      this.deskripsiProduk,
      this.kategoriProduk,
      this.satuanProduk,
      this.satuanProdukList,
      this.golonganProduk,
      this.merkProduk,
      this.dimensiProduk,
      this.beratProduk,
      this.hargaPokok,
      this.hargaProduk,
      this.hargaDiskon,
      this.diskon,
      this.gambarProduk,
      this.multisatuanJumlah,
      this.multisatuanUnit,
      this.multisatuanJumlahList,
      this.multisatuanUnitList,
      this.namaPromo,
      this.keteranganPromo,
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
      this.viewMonth,
      this.terjual,
      this.persentaseDiskon,
      this.persentaseFlashsale,
      this.rating,
      this.grosirProduk});

  DataProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? json['produk_id'];
    cabangId = json['cabang_id'];
    produkKategoriId = json['produk_kategori_id'];
    kodeProduk = json['kode_produk'];
    barcodeProduk = json['barcode_produk'];
    namaProduk = json['nama_produk'];
    deskripsiProduk = json['deskripsi_produk'];
    kategoriProduk = json['kategori_produk'];
    satuanProduk = json['satuan_produk']?.toString().split(',').first;
    satuanProdukList = (json['satuan_produk'] is String)
        ? json['satuan_produk']
            .toString()
            .split(',')
            .map((e) => e.trim())
            .toList()
        : (json['multisatuan_unit'] as List?)
            ?.map((e) => e.toString())
            .toList();
    golonganProduk = json['golongan_produk'];
    merkProduk = json['merk_produk'];
    dimensiProduk = json['dimensi_produk'];
    beratProduk = json['berat_produk'];
    hargaPokok = json['harga_pokok'];
    hargaProduk = json['harga_produk'];
    hargaDiskon = json['harga_diskon'];
    diskon =
        (json['diskon'] is num) ? (json['diskon'] as num).toDouble() : null;
    gambarProduk =
        (json['gambar_produk'] as List?)?.map((e) => e.toString()).toList();
    multisatuanJumlah = json['multisatuan_jumlah'] is String
        ? json['multisatuan_jumlah']
        : null;
    multisatuanUnit =
        json['multisatuan_unit'] is String ? json['multisatuan_unit'] : null;
    multisatuanJumlahList = (json['multisatuan_jumlah'] is List)
        ? List<double>.from(json['multisatuan_jumlah'])
        : null;
    multisatuanUnitList = (json['multisatuan_unit'] is List)
        ? List<String>.from(json['multisatuan_unit'])
        : null;
    namaPromo = json['nama_promo'];
    keteranganPromo = json['keterangan_promo'];
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
    grosirProduk = json['grosir_produk'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['cabang_id'] = cabangId;
    data['produk_kategori_id'] = produkKategoriId;
    data['kode_produk'] = kodeProduk;
    data['barcode_produk'] = barcodeProduk;
    data['nama_produk'] = namaProduk;
    data['deskripsi_produk'] = deskripsiProduk;
    data['kategori_produk'] = kategoriProduk;
    data['satuan_produk'] = satuanProduk;
    data['satuan_produk_list'] = satuanProdukList;
    data['golongan_produk'] = golonganProduk;
    data['merk_produk'] = merkProduk;
    data['dimensi_produk'] = dimensiProduk;
    data['berat_produk'] = beratProduk;
    data['harga_pokok'] = hargaPokok;
    data['harga_produk'] = hargaProduk;
    data['harga_diskon'] = hargaDiskon;
    data['diskon'] = diskon;
    data['gambar_produk'] = gambarProduk;
    data['multisatuan_jumlah'] = multisatuanJumlah;
    data['multisatuan_unit'] = multisatuanUnit;
    data['multisatuan_jumlah_list'] = multisatuanJumlahList;
    data['multisatuan_unit_list'] = multisatuanUnitList;
    data['nama_promo'] = namaPromo;
    data['keterangan_promo'] = keteranganPromo;
    data['flashsale'] = flashsale;
    data['flashsale_kuantitas'] = flashsaleKuantitas;
    data['flashsale_limit'] = flashsaleLimit;
    data['flashsale_terjual'] = flashsaleTerjual;
    data['flashsale_nominal'] = flashsaleNominal;
    data['flashsale_satuan'] = flashsaleSatuan;
    data['flashsale_end'] = flashsaleEnd;
    data['harga_produk_flashsale'] = hargaProdukFlashsale;
    data['harga_diskon_flashsale'] = hargaDiskonFlashsale;
    data['is_aktiva'] = isAktiva;
    data['is_multisatuan'] = isMultisatuan;
    data['is_grosir'] = isGrosir;
    data['is_diskon'] = isDiskon;
    data['is_promo'] = isPromo;
    data['is_flashsale'] = isFlashsale;
    data['view'] = view;
    data['view_month'] = viewMonth;
    data['terjual'] = terjual;
    data['persentase_diskon'] = persentaseDiskon;
    data['persentase_flashsale'] = persentaseFlashsale;
    data['rating'] = rating;
    data['grosir_produk'] = grosirProduk;
    return data;
  }
}
