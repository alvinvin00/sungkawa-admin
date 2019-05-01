import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
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

  Post(
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

  Post.fromSnapshot(DocumentSnapshot snapshot) {
    _key = snapshot.documentID;
    _nama = snapshot.data["nama"];
    _umur = snapshot.data["umur"];
    _photo = snapshot.data['photo'];
    _alamat = snapshot.data['alamat'];
    _tanggalMeninggal = snapshot.data["tanggalMeninggal"];
    _prosesi = snapshot.data["prosesi"];
    _lokasi = snapshot.data["lokasi"];
    _tempatDimakamkan = snapshot.data["tempatDimakamkan"];
    _tanggalSemayam = snapshot.data["tanggalSemayam"];
    _waktuSemayam = snapshot.data["waktuSemayam"];
    _keterangan = snapshot.data["keterangan"];
    _timestamp = snapshot.data['timestamp'];
  }
}
