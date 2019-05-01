import 'dart:async';
import 'dart:io';

import 'package:Sungkawa/utilities/crud.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class PostAdd extends StatefulWidget {
  @override
  _PostAddState createState() => _PostAddState();
}

class _PostAddState extends State<PostAdd> {
  String userId;
  DateTime date = DateTime.now();
  int timestamp;

  final dateFormat = DateFormat('dd/MM/yyyy');
  final format = DateFormat("EEEE, MMMM d, yyyy 'at' h:mma");
  final timeFormat = DateFormat('HH:mm');

  File image;
  var imageFile, _processType;
  bool isLoading = false;

  CRUD crud = new CRUD();

  String nama;
  String umur;
  String alamat;
  String lokasiSemayam;
  String lokasi;
  String keterangan;
  DateTime tanggalMeninggal;
  DateTime tanggalSemayam;
  DateTime waktuSemayam;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambahkan posting',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.grey[350],
        actions: <Widget>[
          IconButton(
            color: Colors.black,
            icon: Icon(Icons.check),
            onPressed: () {
              savePost();
            },
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(16.0),
        child: buildFormField(),
      ),
    );
  }

  ListView buildFormField() {
    return ListView(
      padding: EdgeInsets.only(top: 8.0),
      children: <Widget>[
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  labelText: 'Nama',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                maxLength: 50,
                maxLines: 1,
                onChanged: (value) => this.nama = value,
                textCapitalization: TextCapitalization.words,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Usia',
                  hintText: 'Tulis usia dalam satuan tahun',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                keyboardType: TextInputType.number,
                maxLength: 3,
                maxLines: 1,
                onChanged: (value) => this.umur = value,
                textCapitalization: TextCapitalization.words,
              ),
              DateTimePickerFormField(
                inputType: InputType.date,
                editable: false,
                format: dateFormat,
                decoration: InputDecoration(
                  labelText: 'Tanggal Meninggal',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (value) => this.tanggalMeninggal = value,
              ),
              SizedBox(
                height: 10.0,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Alamat',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                maxLength: 50,
                maxLines: 1,
                onChanged: (value) => this.alamat = value,
                textCapitalization: TextCapitalization.words,
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    height: 8.0,
                  ),
                  new Radio(
                    value: 'Dimakamkan',
                    onChanged: handleProcessType,
                    activeColor: Colors.green,
                    groupValue: _processType,
                  ),
                  Text('Dimakamkan'),
                  SizedBox(
                    height: 8.0,
                  ),
                  new Radio(
                    value: 'Dikremasi',
                    onChanged: handleProcessType,
                    activeColor: Colors.green,
                    groupValue: _processType,
                  ),
                  Text('Dikremasi'),
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Tempat disemayamkan',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                maxLength: 50,
                maxLines: 1,
                onChanged: (value) => this.lokasiSemayam = value,
                textCapitalization: TextCapitalization.words,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Tempat Pemakaman/Kremasi',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                maxLength: 50,
                maxLines: 1,
                onChanged: (value) => this.lokasi = value,
                textCapitalization: TextCapitalization.words,
              ),
              DateTimePickerFormField(
                inputType: InputType.date,
                editable: false,
                format: dateFormat,
                decoration: InputDecoration(
                  labelText: 'Tanggal Pemakaman/Kremasi',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (value) => this.tanggalSemayam = value,
              ),
              SizedBox(
                height: 8.0,
              ),
              DateTimePickerFormField(
                inputType: InputType.time,
                editable: false,
                format: timeFormat,
                decoration: InputDecoration(
                  labelText: 'Jam Pemakaman/Kremasi',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (value) => this.waktuSemayam = value,
              ),
              SizedBox(
                height: 10.0,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Keterangan',
                  hintText: 'Tulis keterangan...',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                maxLength: 200,
                maxLines: 6,
                onChanged: (value) => this.keterangan = value,
                textCapitalization: TextCapitalization.sentences,
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.camera_alt,
                      color: Colors.grey,
                    ),
                    onPressed: getImageCamera,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.image,
                      color: Colors.grey,
                    ),
                    onPressed: getImageGallery,
                  ),
                  Container(
                      height: 20,
                      width: 20,
                      child: isLoading == true
                          ? CircularProgressIndicator()
                          : Text('')),
                ],
              ),
              imageFile != null ? buildImage() : Text(''),
            ],
          ),
        )
      ],
    );
  }

  Widget buildImage() {
    return Container(
      child: Image.file(
        imageFile,
        width: MediaQuery.of(context).size.width,
        height: 240,
        fit: BoxFit.fitWidth,
      ),
    );
  }

  void getImageGallery() async {
    try {
      imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
      print('imageFile : $imageFile');
      setState(() {
        image = imageFile;
      });
    } catch (e) {
      print('Error $e');
    }
  }

  void getImageCamera() async {
    try {
      imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
      print('imageFile : $imageFile');
      setState(() {
        image = imageFile;
      });
    } catch (e) {
      print('Error $e');
    }
  }

  Future<String> uploadImage(var imageFile) async {
    timestamp = DateTime.now().millisecondsSinceEpoch;
    String fileName = timestamp.toString() + 'jpg';
    StorageReference storageRef =
        FirebaseStorage.instance.ref().child('image').child(fileName);
    StorageUploadTask task = storageRef.putFile(image);
    var downloadUrl = await (await task.onComplete).ref.getDownloadURL();
    String _url = downloadUrl.toString();
    return _url;
  }

  void savePost() async {
    await FirebaseAuth.instance.currentUser().then((user) {
      setState(() {
        userId = user.uid;
      });
    });
    if (image != null) {
      setState(() {
        isLoading = true;
      });
      uploadImage(image).then((_url) {
        try {
          crud.addPost({
            'nama': this.nama,
            'umur': this.umur,
            'photo': _url,
            'timestamp': this.timestamp,
            'userId': this.userId,
            'tanggalMeninggal': dateFormat.format(this.tanggalMeninggal),
            'alamat': this.alamat,
            'prosesi': this._processType.toString(),
            'tempatDimakamkan': this.lokasi,
            'tanggalSemayam': dateFormat.format(this.tanggalSemayam),
            'lokasiSemayam': this.lokasiSemayam,
            'waktuSemayam': timeFormat.format(this.waktuSemayam),
            'keterangan': this.keterangan
          }).then((result) => Navigator.pop(context));
        } catch (e) {
          Scaffold.of(context).showSnackBar(SnackBar(content: Text(e)));
          print(e);
          setState(() {
            isLoading = false;
          });
        }
      });
    } else {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Gambar harus ada')));
    }
  }

  void handleProcessType(value) {
    print('Process type : $value');
    setState(() {
      _processType = value;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _processType = 'Dimakamkan';
  }
}
