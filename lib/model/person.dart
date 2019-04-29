import 'package:firebase_database/firebase_database.dart';

class Person {
  String _key;
  String _photo;
  String _nama,
      _tempatDimakamkan,
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
      this._key,
      this._photo,
      this._alamat,
      this._prosesi,
      this._nama,
      this._tempatDimakamkan,
      this._umur,
      this._keterangan,
      this._tanggalSemayam,
      this._lokasi,
      this._tanggalMeninggal,
      this._waktuSemayam,
      this._timestamp);

  String get key => _key;

  String get prosesi => _prosesi;

  String get nama => _nama;

  String get alamat => _alamat;

  String get tanggalMeninggal => _tanggalMeninggal;

  String get umur => _umur;

  String get tempatDimakamkan => _tempatDimakamkan;

  String get keterangan => _keterangan;

  String get tanggalSemayam => _tanggalSemayam;

  String get lokasi => _lokasi;

  String get waktuSemayam => _waktuSemayam;

  String get photo => _photo;

  int get timestamp => _timestamp;

  Person.fromsnapShot(DataSnapshot snapshot) {
    _key = snapshot.key;
    _nama = snapshot.value["nama"];
    _umur = snapshot.value["usia"];
    _photo = snapshot.value['photo'];
    _alamat = snapshot.value['alamat'];
    _tanggalMeninggal = snapshot.value["tanggalMeninggal"];
    _prosesi = snapshot.value["prosesi"];
    _lokasi = snapshot.value["lokasiSemayam"];
    _tempatDimakamkan = snapshot.value["tempatDimakamkan"];
    _tanggalSemayam = snapshot.value["tanggalSemayam"];
    _waktuSemayam = snapshot.value["waktuSemayam"];
    _keterangan = snapshot.value["keterangan"];
    _timestamp = snapshot.value['timestamp'];
  }


}
