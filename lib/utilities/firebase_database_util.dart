//import 'dart:async';
//import 'package:firebase_database/firebase_database.dart';
//import 'package:sung/model/person.dart';
//
//class FirebaseDatabaseUtil {
//  DatabaseReference _userRef;
//  StreamSubscription<Event> _messagesSubscription;
//  FirebaseDatabase database = new FirebaseDatabase();
//  DatabaseError error;
//
//  FirebaseDatabaseUtil.internal();
//
//  static final FirebaseDatabaseUtil _instance =
//      new FirebaseDatabaseUtil.internal();
//
//  factory FirebaseDatabaseUtil(){
//    return _instance;
//  }
//  void initState(){
//    _userRef = FirebaseDatabase.instance.reference().child('posts');
//    database.reference().child('posts').once().then((DataSnapshot snapshot){
//      print('Connected to Firebase and read ${snapshot.value}');
//    });
//    database.setPersistenceEnabled(true);
//    database.setPersistenceCacheSizeBytes(100000000);
//
//  }
//  DatabaseError getError(){
//    return error;
//  }
//
//  DatabaseReference getUser(){
//    return _userRef;
//  }
//  void updateUser(Person person)async{
//    await _userRef.child(person.key).update({
//
//      "nama": "" + person.nama,
//      "usia": "" + person.umur,
//      "photo": ""+person.photo,
////      "timestamp":""+person.timestamp,
//      "tanggal_meninggal": ""+person.tanggalmeninggal,
//      "tanggal_semayam": ""+person.tanggal_semayam,
//      "lokasi_semayam": ""+person.lokasi,
//
//
////      'nama': namaController.text,
////      'usia': umurController.text,
////      'photo': _url,
////      'timestamp': timestamp,
////      'userId': userId,
////      'tanggal_meninggal': tanggalmeninggalController.text,
////      'alamat': alamatController.text,
////      'status_pemakaman': _processType.toString(),
////      'tempat_dimakamkan': locationController.text,
////      'tanggal_semayam': tanggal_semayam.text,
////      'lokasi_semayam': lokasi_semayamController.text,
////      'waktu_semayam': waktu_semayamController.text,
////      'keterangan': keteranganController.text
//
//    }).then((_) {
//      print('Transaction Comitted');
//    });
//  }
//
//  void deleteUser(Person person)async{
//    await _userRef.child(person.key).remove().then((_){
//      print('Transaction Comitted');
//    });
//  }
//  void dispose(){
//    _messagesSubscription.cancel();
//  }
//
//
//}
