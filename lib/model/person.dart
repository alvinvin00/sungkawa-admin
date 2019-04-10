import 'package:firebase_database/firebase_database.dart';

class Person {
  String _key;
  String _photo;
  String _nama,
      _userId,
      _tempatMakam,
      _umur,
      _keterangan,
      _tanggalSemayam,
      _lokasi,
      _alamat,
      _tanggalMeninggal,
      _prosesi,
      _waktuSemayam;
  int _timestamp;

  Person(
      this._userId,
      this._key,
      this._photo,
      this._alamat,
      this._prosesi,
      this._nama,
      this._tempatMakam,
      this._umur,
      this._keterangan,
      this._tanggalSemayam,
      this._lokasi,
      this._tanggalMeninggal,
      this._waktuSemayam,
      this._timestamp);

  String get key => _key;

  String get userId => _userId;

  String get photo => _photo;

  String get nama => _nama;

  get tempatMakam => _tempatMakam;

  get umur => _umur;

  get keterangan => _keterangan;

  get tanggalSemayam => _tanggalSemayam;

  get lokasi => _lokasi;

  get alamat => _alamat;

  get tanggalMeninggal => _tanggalMeninggal;

  get prosesi => _prosesi;

  get waktuSemayam => _waktuSemayam;

  int get timestamp => _timestamp;

  Person.fromsnapShot(DataSnapshot snapshot) {
    _key = snapshot.key;
    _userId = snapshot.value["userId"];
    _nama = snapshot.value["nama"];
    _umur = snapshot.value["usia"];
    _photo = snapshot.value['photo'];
    _alamat = snapshot.value['alamat'];
    _tanggalMeninggal = snapshot.value["tanggal_meninggal"];
    _prosesi = snapshot.value["prosesi"];
    _lokasi = snapshot.value["lokasi_semayam"];
    _tempatMakam = snapshot.value["tempat_dimakamkan"];
    _tanggalSemayam = snapshot.value["tanggal_semayam"];
    _waktuSemayam = snapshot.value["waktu_semayam"];
    _keterangan = snapshot.value["keterangan"];
    _timestamp = snapshot.value['timestamp'];
  }
}
