import 'package:firebase_database/firebase_database.dart';

class Person {
  String _key;
  String _photo;
  String _nama,
      _tempat_dimakamkan,
      _umur,
      _keterangan,
      _tanggal_semayam,
      _lokasi,
      _alamat,
      _tanggalmeninggal,
      _status_pemakaman,
      _waktu_semayam;
  int _timestamp;

  Person(
      this._key,
      this._photo,
      this._alamat,
      this._status_pemakaman,
      this._nama,
      this._tempat_dimakamkan,
      this._umur,
      this._keterangan,
      this._tanggal_semayam,
      this._lokasi,
      this._tanggalmeninggal,
      this._waktu_semayam,
      this._timestamp);

  String get key => _key;

  String get status_pemakaman => _status_pemakaman;

  String get nama => _nama;

  String get alamat => _alamat;

  String get tanggalmeninggal => _tanggalmeninggal;

  String get umur => _umur;

  String get tempat_dimakamkan => _tempat_dimakamkan;

  String get keterangan => _keterangan;

  String get tanggal_semayam => _tanggal_semayam;

  String get lokasi => _lokasi;

  String get waktu_semayam => _waktu_semayam;

  String get photo => _photo;

  int get timestamp => _timestamp;

  Person.fromsnapShot(DataSnapshot snapshot) {
    _key = snapshot.key;
    _nama = snapshot.value["nama"];
    _umur = snapshot.value["usia"];
    _photo = snapshot.value['photo'];
    _alamat = snapshot.value['alamat'];
    _tanggalmeninggal = snapshot.value["tanggal_meninggal"];
    _status_pemakaman = snapshot.value["status_pemakaman"];
    _lokasi = snapshot.value["lokasi_semayam"];
    _tempat_dimakamkan = snapshot.value["tempat_dimakamkan"];
    _tanggal_semayam = snapshot.value["tanggal_semayam"];
    _waktu_semayam = snapshot.value["waktu_semayam"];
    _keterangan = snapshot.value["keterangan"];
    _timestamp = snapshot.value['timestamp'];
  }
}
