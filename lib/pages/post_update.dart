import 'dart:async';
import 'dart:io';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sung/model/person.dart';
import 'package:cached_network_image/cached_network_image.dart';
//import 'package:sung/utilities/firebase_database_util.dart';

class UpdatePost extends StatefulWidget {
  final Person person;

  UpdatePost(this.person);

  @override
  _UpdatePostState createState() => _UpdatePostState();
}

class _UpdatePostState extends State<UpdatePost> {
  String userId;
  String nama,
      umur,
      alamat,
      lokasi_disemayamkan,
      tanggal_meninggal,
      keterangan,
      tempatMakam,
      tanggal_semayam,
      waktu_semayam;
  bool isChanged = false;
  String key;
  var postRef;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    postRef = FirebaseDatabase.instance.reference().child('posts').child(key);
    key = widget.person.key;
    print(key);
    _processType = widget.person.statusPemakaman;
    tempatSemayam = dateFormat.parse(widget.person.tanggalSemayam);
    tempatMeninggal = dateFormat.parse(widget.person.tanggalMeninggal);
    waktuSemayam = timeFormat.parse(widget.person.waktuSemayam);
    nama = widget.person.nama;
    umur = widget.person.umur;
    alamat = widget.person.alamat;
    keterangan = widget.person.keterangan;
    print(waktuSemayam);
  }

  DateTime tempatSemayam, waktuSemayam, tempatMeninggal;

  var radioValue;
  DateTime date, time;
  int timestamp;
  File image;
  var imageFile, _processType;
  bool isLoading = false;
  String kubur;
  final dateFormat = DateFormat('dd/MM/yyyy');
  final timeFormat = DateFormat('hh.mm.a');
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Posting"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              isLoading = true;
              validateAndSubmit();
            },
          ),
        ],
        backgroundColor: Colors.grey[400],
      ),
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: new ListView(
            children: <Widget>[
              CachedNetworkImage(
                imageUrl: widget.person.photo,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.warning),
              ),
              SizedBox(
                height: 5,
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
              SizedBox(
                height: 5,
              ),
              TextFormField(
                initialValue: nama,
                onSaved: (value) => nama = value,
                validator: (value) =>
                    value.isEmpty ? 'Nama tidak boleh kosong' : null,
                decoration: InputDecoration(
                  labelText: 'Nama',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                maxLength: 50,
                maxLines: 1,
                textCapitalization: TextCapitalization.words,
              ),
              TextFormField(
                initialValue: umur,
                validator: (value) =>
                    value.isEmpty ? 'Umur tidak boleh kosong' : null,
                onSaved: (value) => umur = value,
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
                textCapitalization: TextCapitalization.words,
              ),
              DateTimePickerFormField(
                initialValue: tempatMeninggal,
                inputType: InputType.date,
                editable: false,
                format: dateFormat,
                onSaved: (value) => tempatMeninggal = value,
                decoration: InputDecoration(
                  labelText: 'Tanggal Meninggal',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
//              onChanged: (dt) => setState(() => date = dt),
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                initialValue: widget.person.alamat,
                validator: (value) =>
                    value.isEmpty ? 'Alamat tidak boleh kosong' : null,
                decoration: InputDecoration(
                  labelText: 'Alamat',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                maxLength: 50,
                maxLines: 1,
                onSaved: (value) => alamat = value,
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
              TextFormField(
                initialValue: widget.person.lokasi,
                validator: (value) =>
                    value.isEmpty ? 'Lokasi tidak boleh kosong' : null,
                decoration: InputDecoration(
                  labelText: 'Tempat disemayamkan',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                maxLength: 50,
                maxLines: 1,
                onSaved: (value) => lokasi_disemayamkan = value,
                textCapitalization: TextCapitalization.words,
              ),
              TextFormField(
                initialValue: widget.person.tempatMakam,
                validator: (value) => value.isEmpty
                    ? 'Tempat dimakamkan tidak boleh kosong'
                    : null,
                decoration: InputDecoration(
                  labelText: 'Tempat Pemakaman/Kremasi',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                maxLength: 50,
                maxLines: 1,
                onSaved: (value) => tempatMakam = value,
                textCapitalization: TextCapitalization.words,
              ),
              DateTimePickerFormField(
                inputType: InputType.date,
                editable: false,
                format: dateFormat,
                initialValue: tempatSemayam,
                onSaved: (value) => tempatSemayam = value,
                decoration: InputDecoration(
                  labelText: 'Tanggal Pemakaman/Kremasi',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
//              onChanged: (dt) => setState(() => date = dt),
              ),
              SizedBox(
                height: 10.0,
              ),
              DateTimePickerFormField(
                inputType: InputType.time,
                editable: false,
                format: timeFormat,
                initialValue: waktuSemayam,
                onSaved: (value) => waktuSemayam = value,
                decoration: InputDecoration(
                  labelText: 'Jam Pemakaman/Kremasi',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
//              onChanged: (dt) => setState(() => time = dt),
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                initialValue: widget.person.keterangan,
                validator: (value) =>
                    value.isEmpty ? 'Keterangan tidak boleh kosong' : null,
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
                onSaved: (value) => keterangan = value,
                textCapitalization: TextCapitalization.sentences,
              ),
              imageFile != null ? buildImage() : Text(''),
            ],
          ),
        ),
      ),
    );
  }

  void handleProcessType(value) {
    print('Process type : $value');
    setState(() {
      _processType = value;
    });
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
        isChanged = true;
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
        isChanged = true;
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

  void updatePost() async {
    print('Mencoba Update Posting');

    if (isChanged == true) {
      uploadImage(image).then((_url) {
        pushData(_url);
      });
    } else
      pushData(widget.person.photo);
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    print('Form Key : $formKey');
    print('Form ' + form.toString());
    form.save();
    print('Nama $nama');
    print('Umur $umur');
    print('Alamat $alamat');
    print('Keterangan $keterangan');
    print('tanggal meninggal $tempatMeninggal');
    print('tanggal disemayamkan $tempatSemayam');
    print('tempat disemayamkan $tempatMakam');
    print('jam kre $waktuSemayam');
    print('status pemakaman : ${_processType.toString()}');

    if (form.validate()) {
      print('Posting valid');
      return true;
    } else {
      print('Posting tidak valid');
      return false;
    }
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        FirebaseUser user = await FirebaseAuth.instance.currentUser();
        updatePost();
      } catch (e) {
        print('Error $e');
      }
    } else {
      formKey.currentState.reset();
    }
  }

  void pushData(_url) {
    try {
      print('Updating ....');
      postRef.update({
        'nama': nama,
        'usia': umur,
        'photo': _url,
        'timestamp': timestamp,
        'userId': userId,
        'tanggal_meninggal': tanggal_meninggal.toString(),
        'alamat': alamat,
        'status_pemakaman': _processType.toString(),
        'tempat_dimakamkan': tempatMakam,
        'tanggal_semayam': tanggal_semayam.toString(),
        'lokasi_semayam': lokasi_disemayamkan,
        'waktu_semayam': waktuSemayam.toString(),
        'keterangan': keterangan
      }).whenComplete(() {
        print('Updating selesai.......');
        Navigator.pop(context);
      });
    } catch (e) {
      print('error : $e');
      isLoading = false;
    }
  }
}
