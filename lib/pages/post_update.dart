import 'dart:async';
import 'dart:io';
import 'package:Sungkawa/model/person.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
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
      lokasiDisemayamkan,
      tanggalMeninggal,
      keterangan,
      tempatDimakamkan,
      tanggalSemayam,
      waktu_semayam;
  bool isChanged = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _processType = widget.person.prosesi;
    t_semayam = DateFormat('dd/MM/yyyy').parse(widget.person.tanggalSemayam);
    t_meninggal =
        DateFormat('dd/MM/yyyy').parse(widget.person.tanggalMeninggal);
    waktuSemayam = DateFormat('hh.mm.a').parse(widget.person.waktuSemayam);
    nama = widget.person.nama;
    umur = widget.person.umur;
    alamat = widget.person.alamat;
    keterangan = widget.person.keterangan;
    print(waktuSemayam);
  }

  DateTime t_semayam, waktuSemayam, t_meninggal;

  var radiovalue;
  DateTime date, time;
  int timestamp;
  File image;
  var imagefile, _processType;
  bool isLoading = false;
  String kubur;
  final dateformat = DateFormat('dd/MM/yyyy');
  final formats = DateFormat('dd/MM/yyyy');
  final timeformat = DateFormat('hh.mm.a');
  final formkey = GlobalKey<FormState>();

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
//          Container(
//              height: 20,
//              width: 20,
//              child:
//              isLoading == true ? CircularProgressIndicator() : Text('')),
        ],
        backgroundColor: Colors.grey[400],
      ),
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formkey,
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
                initialValue: t_meninggal,
                inputType: InputType.date,
                editable: false,
                format: dateformat,
                onSaved: (value) => t_meninggal = value,
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
                onSaved: (value) => lokasiDisemayamkan = value,
                textCapitalization: TextCapitalization.words,
              ),
              TextFormField(
                initialValue: widget.person.tempatDimakamkan,
                validator: (value) =>
                value.isEmpty ? 'Tempat dimakamkan tidak boleh kosong' : null,
                decoration: InputDecoration(
                  labelText: 'Tempat Pemakaman/Kremasi',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                maxLength: 50,
                maxLines: 1,
                onSaved: (value) => tempatDimakamkan = value,
                textCapitalization: TextCapitalization.words,
              ),
              DateTimePickerFormField(
                inputType: InputType.date,
                editable: false,
                format: dateformat,
                initialValue: t_semayam,
                onSaved: (value) => t_semayam = value,
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
                format: timeformat,
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
              imagefile != null ? buildImage() : Text(''),
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
        imagefile,
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: 240,
        fit: BoxFit.fitWidth,
      ),
    );
  }

  void getImageGallery() async {
    try {
      imagefile = await ImagePicker.pickImage(source: ImageSource.gallery);
      print('imageFile : $imagefile');
      setState(() {
        image = imagefile;
        isChanged = true;
      });
    } catch (e) {
      print('Error $e');
    }
  }

  void getImageCamera() async {
    try {
      imagefile = await ImagePicker.pickImage(source: ImageSource.camera);
      print('imageFile : $imagefile');
      setState(() {
        image = imagefile;
        isChanged = true;
      });
    } catch (e) {
      print('Error $e');
    }
  }

  Future<String> uploadImage(var imageFile) async {
    timestamp = DateTime
        .now()
        .millisecondsSinceEpoch;
    String fileName = timestamp.toString() + 'jpg';
    StorageReference storageRef =
    FirebaseStorage.instance.ref().child('image').child(fileName);
    StorageUploadTask task = storageRef.putFile(image);
    var downloadUrl = await (await task.onComplete).ref.getDownloadURL();
    String _url = downloadUrl.toString();
    return _url;
  }

//  void update(Person person) {
//    setState(() {
//      databaseUtil.updateUser(person);
//    });
//  }

  void UpdatePost() async {
    print('Mencoba Update Posting');

    if (isChanged == true) {
      uploadImage(image).then((_url) {
        var postRef = FirebaseDatabase.instance
            .reference()
            .child('posts')
            .child('-LbxeQpqZFHp4vc0uMJL');

        try {
          print('Updating ....');
          postRef.update({
            'nama': nama,
            'usia': umur,
            'photo': _url,
            'timestamp': timestamp,
            'userId': userId,
            'tanggalMeninggal': tanggalMeninggal.toString(),
            'alamat': alamat,
            'prosesi': _processType.toString(),
            'tempatDimakamkan': tempatDimakamkan,
            'tanggalSemayam': tanggalSemayam.toString(),
            'lokasiSemayam': lokasiDisemayamkan,
            'waktuSemayam': waktuSemayam.toString(),
            'keterangan': keterangan
          }).whenComplete(() {
            print('Updating selesai.......');
            Navigator.pop(context);
          });
        } catch (e) {
          print('error : $e');
          isLoading = false;
        }
      });
    }
  }

  bool validateAndSave() {
    final form = formkey.currentState;
    print('Form Key : $formkey');
    print('Form ' + form.toString());
    form.save();
    print('Nama $nama');
    print('Umur $umur');
    print('Alamat $alamat');
    print('Keterangan $keterangan');
    print('tanggal meninggal $t_meninggal');
    print('tanggal disemayamkan $t_semayam');
    print('tempat disemayamkan $tempatDimakamkan');
    print('jam kre $waktuSemayam');
    print('status pemakaman : $_processType.toString()');

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
        UpdatePost();
      } catch (e) {
        print('Error $e');
      }
    } else {
      formkey.currentState.reset();
    }
  }

}
