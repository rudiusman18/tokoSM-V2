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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataProduct {
  dynamic id;
  dynamic produkKategoriId;
  String? kodeProduk;
  String? barcodeProduk;
  String? namaProduk;
  String? satuanProduk;
  String? golonganProduk;
  String? merkProduk;
  String? deskripsiProduk;
  String? dimensiProduk;
  dynamic beratProduk;
  dynamic hargaPokok;
  String? multisatuanJumlah;
  String? multisatuanUnit;
  String? gambar1;
  String? gambar2;
  String? gambar3;
  String? gambar4;
  String? gambar5;
  dynamic isAktiva;
  dynamic isMultisatuan;
  dynamic view;
  dynamic viewMonth;
  String? laststockedAt;
  String? rating;
  dynamic hargaJual;
  String? namaPromo;
  dynamic diskon;
  dynamic flashsale;
  dynamic flashsaleKuantitas;
  dynamic flashsaleLimit;
  dynamic flashsaleTerjual;
  dynamic flashsaleNominal;
  String? flashsaleSatuan;
  String? flashsaleEnd;
  dynamic hargaProduk;
  dynamic hargaDiskon;
  List<String>? gambarProduk;
  dynamic isDiskon;
  dynamic isPromo;
  dynamic isFlashsale;
  dynamic persentaseFlashsale;
  dynamic hargaFlashsale;
  dynamic persentaseDiskon;

  DataProduct(
      {this.id,
      this.produkKategoriId,
      this.kodeProduk,
      this.barcodeProduk,
      this.namaProduk,
      this.satuanProduk,
      this.golonganProduk,
      this.merkProduk,
      this.deskripsiProduk,
      this.dimensiProduk,
      this.beratProduk,
      this.hargaPokok,
      this.multisatuanJumlah,
      this.multisatuanUnit,
      this.gambar1,
      this.gambar2,
      this.gambar3,
      this.gambar4,
      this.gambar5,
      this.isAktiva,
      this.isMultisatuan,
      this.view,
      this.viewMonth,
      this.laststockedAt,
      this.rating,
      this.hargaJual,
      this.namaPromo,
      this.diskon,
      this.flashsale,
      this.flashsaleKuantitas,
      this.flashsaleLimit,
      this.flashsaleTerjual,
      this.flashsaleNominal,
      this.flashsaleSatuan,
      this.flashsaleEnd,
      this.hargaProduk,
      this.hargaDiskon,
      this.gambarProduk,
      this.isDiskon,
      this.isPromo,
      this.isFlashsale,
      this.persentaseFlashsale,
      this.hargaFlashsale,
      this.persentaseDiskon});

  DataProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    produkKategoriId = json['produk_kategori_id'];
    kodeProduk = json['kode_produk'];
    barcodeProduk = json['barcode_produk'];
    namaProduk = json['nama_produk'];
    satuanProduk = json['satuan_produk'];
    golonganProduk = json['golongan_produk'];
    merkProduk = json['merk_produk'];
    deskripsiProduk = json['deskripsi_produk'];
    dimensiProduk = json['dimensi_produk'];
    beratProduk = json['berat_produk'];
    hargaPokok = json['harga_pokok'];
    multisatuanJumlah = json['multisatuan_jumlah'];
    multisatuanUnit = json['multisatuan_unit'];
    gambar1 = json['gambar1'];
    gambar2 = json['gambar2'];
    gambar3 = json['gambar3'];
    gambar4 = json['gambar4'];
    gambar5 = json['gambar5'];
    isAktiva = json['is_aktiva'];
    isMultisatuan = json['is_multisatuan'];
    view = json['view'];
    viewMonth = json['view_month'];
    laststockedAt = json['laststocked_at'];
    rating = json['rating'];
    hargaJual = json['harga_jual'];
    namaPromo = json['nama_promo'];
    diskon = json['diskon'];
    flashsale = json['flashsale'];
    flashsaleKuantitas = json['flashsale_kuantitas'];
    flashsaleLimit = json['flashsale_limit'];
    flashsaleTerjual = json['flashsale_terjual'];
    flashsaleNominal = json['flashsale_nominal'];
    flashsaleSatuan = json['flashsale_satuan'];
    flashsaleEnd = json['flashsale_end'];
    hargaProduk = json['harga_produk'];
    hargaDiskon = json['harga_diskon'];
    gambarProduk = json['gambar_produk'].cast<String>();
    isDiskon = json['is_diskon'];
    isPromo = json['is_promo'];
    isFlashsale = json['is_flashsale'];
    persentaseFlashsale = json['persentase_flashsale'];
    hargaFlashsale = json['harga_flashsale'];
    persentaseDiskon = json['persentase_diskon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['produk_kategori_id'] = produkKategoriId;
    data['kode_produk'] = kodeProduk;
    data['barcode_produk'] = barcodeProduk;
    data['nama_produk'] = namaProduk;
    data['satuan_produk'] = satuanProduk;
    data['golongan_produk'] = golonganProduk;
    data['merk_produk'] = merkProduk;
    data['deskripsi_produk'] = deskripsiProduk;
    data['dimensi_produk'] = dimensiProduk;
    data['berat_produk'] = beratProduk;
    data['harga_pokok'] = hargaPokok;
    data['multisatuan_jumlah'] = multisatuanJumlah;
    data['multisatuan_unit'] = multisatuanUnit;
    data['gambar1'] = gambar1;
    data['gambar2'] = gambar2;
    data['gambar3'] = gambar3;
    data['gambar4'] = gambar4;
    data['gambar5'] = gambar5;
    data['is_aktiva'] = isAktiva;
    data['is_multisatuan'] = isMultisatuan;
    data['view'] = view;
    data['view_month'] = viewMonth;
    data['laststocked_at'] = laststockedAt;
    data['rating'] = rating;
    data['harga_jual'] = hargaJual;
    data['nama_promo'] = namaPromo;
    data['diskon'] = diskon;
    data['flashsale'] = flashsale;
    data['flashsale_kuantitas'] = flashsaleKuantitas;
    data['flashsale_limit'] = flashsaleLimit;
    data['flashsale_terjual'] = flashsaleTerjual;
    data['flashsale_nominal'] = flashsaleNominal;
    data['flashsale_satuan'] = flashsaleSatuan;
    data['flashsale_end'] = flashsaleEnd;
    data['harga_produk'] = hargaProduk;
    data['harga_diskon'] = hargaDiskon;
    data['gambar_produk'] = gambarProduk;
    data['is_diskon'] = isDiskon;
    data['is_promo'] = isPromo;
    data['is_flashsale'] = isFlashsale;
    data['persentase_flashsale'] = persentaseFlashsale;
    data['harga_flashsale'] = hargaFlashsale;
    data['persentase_diskon'] = persentaseDiskon;
    return data;
  }
}
