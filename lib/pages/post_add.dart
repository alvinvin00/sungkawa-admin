import 'dart:io';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sung/pages/main.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class PostAdd extends StatefulWidget {
  @override
  _PostAddState createState() => _PostAddState();
}

class _PostAddState extends State<PostAdd> {
  String userId;
  InputType inputType = InputType.date;
  bool editable = true;
  DateTime date = DateTime.now();
  int timestamp;
  final namaController = TextEditingController();
  final umurController = TextEditingController();
  final alamatController = TextEditingController();
  final locationController = TextEditingController();
  final tanggalmeninggalController = TextEditingController();
  final lokasi_semayamController = TextEditingController();
  final keluarga = TextEditingController();
  final tempatsemyamController = TextEditingController();
  final keteranganController = TextEditingController();
  final tanggal_semayam = TextEditingController();
  final tempat_dikebumikan = TextEditingController();
  final waktu_semayamController = TextEditingController();
  final dateformat = DateFormat('dd/MM/yyyy');
  final formats = DateFormat("EEEE, MMMM d, yyyy 'at' h:mma");
  final timeformat = DateFormat('hh.mm.a');
  DateTime TanggalMeninggal ;
  DateTime TanggalSemayam;
  DateTime waktu_semayam;

  File image;
  var imagefile, _processType;
  bool isLoading = false;
  String kubur;

  var radiovalue;

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
              setState(() {
                isLoading = true;
              });
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
                controller: namaController,
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
                controller: umurController,
                textCapitalization: TextCapitalization.words,
              ),
              DateTimePickerFormField(
                inputType: InputType.date,
                editable: false,
                format: dateformat,
                controller: tanggalmeninggalController,
                decoration: InputDecoration(
                  labelText: 'Tanggal Meninggal',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (dt) => setState(() => date = dt),
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
                controller: alamatController,
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
                controller: lokasi_semayamController,
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
                controller: locationController,
                textCapitalization: TextCapitalization.words,
              ),
              DateTimePickerFormField(
                inputType: InputType.date,
                editable: false,
                format: dateformat,
                controller: tanggal_semayam,
                decoration: InputDecoration(
                  labelText: 'Tanggal Pemakaman/Kremasi',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (dt) => setState(() => date = dt),
              ),
              SizedBox(
                height: 8.0,
              ),
              DateTimePickerFormField(
                inputType: InputType.time,
                editable: false,
                format: timeformat,
                controller: waktu_semayamController,
                decoration: InputDecoration(
                  labelText: 'Jam Pemakaman/Kremasi',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (dt) => setState(() => date = dt),
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
                controller: keteranganController,
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
              imagefile != null ? buildImage() : Text(''),
            ],
          ),
        )
      ],
    );
  }

  Widget buildImage() {
    return Container(
      child: Image.file(
        imagefile,
        width: MediaQuery.of(context).size.width,
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
      uploadImage(image).then((_url) {
        var postRef = FirebaseDatabase.instance.reference().child('posts');

        try {
          print('Posting ....');
          postRef.push().set({
            'nama': namaController.text,
            'usia': umurController.text,
            'photo': _url,
            'timestamp': timestamp,
            'userId': userId,
            'tanggal_meninggal': tanggalmeninggalController.text,
            'alamat': alamatController.text,
            'status_pemakaman': _processType.toString(),
            'tempat_dimakamkan': locationController.text,
            'tanggal_semayam': tanggal_semayam.text,
            'lokasi_semayam': lokasi_semayamController.text,
            'waktu_semayam': waktu_semayamController.text,
            'keterangan': keteranganController.text

          }).whenComplete(() {
            print('Posting selesai.......');
            Navigator.pop(context,
                MaterialPageRoute(builder: (context) => DashboardScreen()));
            namaController.clear();
            locationController.clear();
            alamatController.clear();
            waktu_semayamController.clear();
            keteranganController.clear();
            tanggalmeninggalController.clear();
            umurController.clear();
            tanggalmeninggalController.clear();
            lokasi_semayamController.clear();
          });
        } catch (e) {
          print('error : $e');
          isLoading = false;
        }
      });
    } else {
      isLoading = false;
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
