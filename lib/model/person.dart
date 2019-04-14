import 'package:firebase_database/firebase_database.dart';

class Person {
  String _key;
  String _photo;
  String _nama,
      _userId,
      _tempatMakam,
      _keterangan,
      _tanggalSemayam,
      _lokasiSemayam,
      _alamat,
      _tanggalMeninggal,
      _prosesi,
      _waktuSemayam,
      _usia;
  int _timestamp;

  Person(
      this._userId,
      this._key,
      this._photo,
      this._alamat,
      this._prosesi,
      this._nama,
      this._tempatMakam,
      this._usia,
      this._keterangan,
      this._tanggalSemayam,
      this._lokasiSemayam,
      this._tanggalMeninggal,
      this._waktuSemayam,
      this._timestamp);

  String get key => _key;

  String get userId => _userId;

  String get photo => _photo;

  String get nama => _nama;

  String get tempatMakam => _tempatMakam;

  String get usia => _usia;

  String get keterangan => _keterangan;

  String get tanggalSemayam => _tanggalSemayam;

  String get lokasiSemayam => _lokasiSemayam;

  String get alamat => _alamat;

  String get tanggalMeninggal => _tanggalMeninggal;

  String get prosesi => _prosesi;

  String get waktuSemayam => _waktuSemayam;

  int get timestamp => _timestamp;

  Person.fromsnapShot(DataSnapshot snapshot) {
    _key = snapshot.key;
    _userId = snapshot.value["userId"];
    _nama = snapshot.value["nama"];
    _usia = snapshot.value["usia"];
    _photo = snapshot.value['photo'];
    _alamat = snapshot.value['alamat'];
    _tanggalMeninggal = snapshot.value["tanggalMeninggal"];
    _prosesi = snapshot.value["prosesi"];
    _lokasiSemayam = snapshot.value["lokasiSemayam"];
    _tempatMakam = snapshot.value["tempatMakam"];
    _tanggalSemayam = snapshot.value["tanggalSemayam"];
    _waktuSemayam = snapshot.value["waktuSemayam"];
    _keterangan = snapshot.value["keterangan"];
    _timestamp = snapshot.value['timestamp'];
  }
}
