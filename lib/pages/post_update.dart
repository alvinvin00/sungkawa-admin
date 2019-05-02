import 'dart:async';
import 'dart:io';

import 'package:Sungkawa/model/post.dart';
import 'package:Sungkawa/utilities/crud.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class UpdatePost extends StatefulWidget {
  UpdatePost(this.post);

  final Post post;

  @override
  _UpdatePostState createState() => _UpdatePostState();
}

class _UpdatePostState extends State<UpdatePost> {
  String nama;
  String umur;
  String alamat;
  String lokasi;
  String tempatDimakamkan;
  String keterangan;
  DateTime tanggalMeninggal;
  DateTime tanggalSemayam;
  DateTime waktuSemayam;

  @override
  void initState() {
    super.initState();
    nama = widget.post.nama;
    umur = widget.post.umur;
    alamat = widget.post.alamat;
    lokasi = widget.post.lokasi;
    _processType = widget.post.prosesi;
    keterangan = widget.post.keterangan;
    tempatDimakamkan = widget.post.tempatDimakamkan;
    tanggalMeninggal = dateFormat.parse(widget.post.tanggalMeninggal);
    tanggalSemayam = dateFormat.parse(widget.post.tanggalSemayam);
    waktuSemayam = timeFormat.parse(widget.post.waktuSemayam);
  }

  final _formKey = new GlobalKey<FormState>();
  String userId;
  DateTime date = DateTime.now();
  int timestamp;
  bool isUploading = false;
  final dateFormat = DateFormat('dd/MM/yyyy');
  final format = DateFormat("EEEE, MMMM d, yyyy 'at' h:mma");
  final timeFormat = DateFormat('HH:mm');
  double _progress;
  File imageFile;
  var image, _processType;
  bool isLoading = false;

  CRUD crud = new CRUD();

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
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nama',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                maxLength: 50,
                maxLines: 1,
                onSaved: (value) => this.nama = value,
                textCapitalization: TextCapitalization.words,
                initialValue: nama,
              ),
              TextFormField(
                initialValue: umur,
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
                onSaved: (value) => this.umur = value,
                textCapitalization: TextCapitalization.words,
              ),
              DateTimePickerFormField(
                initialValue: tanggalMeninggal,
                inputType: InputType.date,
                editable: false,
                format: dateFormat,
                decoration: InputDecoration(
                  labelText: 'Tanggal Meninggal',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onSaved: (value) => this.tanggalMeninggal = value,
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                initialValue: alamat,
                decoration: InputDecoration(
                  labelText: 'Alamat',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                maxLength: 50,
                maxLines: 1,
                onSaved: (value) => this.alamat = value,
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
                initialValue: lokasi,
                decoration: InputDecoration(
                  labelText: 'Tempat disemayamkan',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                maxLength: 50,
                maxLines: 1,
                onSaved: (value) => this.lokasi = value,
                textCapitalization: TextCapitalization.words,
              ),
              TextFormField(
                initialValue: tempatDimakamkan,
                decoration: InputDecoration(
                  labelText: 'Tempat Pemakaman/Kremasi',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                maxLength: 50,
                maxLines: 1,
                onSaved: (value) => this.tempatDimakamkan = value,
                textCapitalization: TextCapitalization.words,
              ),
              DateTimePickerFormField(
                initialValue: tanggalSemayam,
                inputType: InputType.date,
                editable: false,
                format: dateFormat,
                decoration: InputDecoration(
                  labelText: 'Tanggal Pemakaman/Kremasi',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onSaved: (value) => this.tanggalSemayam = value,
              ),
              SizedBox(
                height: 8.0,
              ),
              DateTimePickerFormField(
                initialValue: waktuSemayam,
                inputType: InputType.time,
                editable: false,
                format: timeFormat,
                decoration: InputDecoration(
                  labelText: 'Jam Pemakaman/Kremasi',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onSaved: (value) => this.waktuSemayam = value,
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                initialValue: keterangan,
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
                onSaved: (value) => this.keterangan = value,
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
                  buildProgressBar(),
                ],
              ),
              imageFile != null
                  ? buildImage()
                  : CachedNetworkImage(imageUrl: widget.post.photo),
            ],
          ),
        )
      ],
    );
  }

  Widget buildProgressBar() {
    if (isUploading == true) {
      return Expanded(
          child: LinearProgressIndicator(
        value: _progress,
      ));
    } else if (isLoading == true) {
      CircularProgressIndicator();
    }
    return Text('');
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
      print('imageFile : $image');
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
      print('imageFile : $image');
      setState(() {
        image = imageFile;
      });
    } catch (e) {
      print('Error $e');
    }
  }

  Future<String> uploadImage(var imageFile) async {
    setState(() {
      isUploading = true;
    });

    timestamp = DateTime.now().millisecondsSinceEpoch;
    String fileName = timestamp.toString() + 'jpg';
    StorageReference storageRef =
        FirebaseStorage.instance.ref().child('image').child(fileName);
    StorageUploadTask task = storageRef.putFile(image);
    task.events.listen((event) {
      setState(() {
        _progress = event.snapshot.bytesTransferred.toDouble() /
            event.snapshot.totalByteCount.toDouble();
      });
    });
    var downloadUrl = await (await task.onComplete).ref.getDownloadURL();
    String _url = downloadUrl.toString();
    return _url;
  }

  void savePost() async {
    _formKey.currentState.save();
    await FirebaseAuth.instance.currentUser().then((user) {
      setState(() {
        userId = user.uid;
      });
    });

    setState(() {
      isLoading = true;
    });

    try {
      if (isUploading == true) {
        uploadImage(imageFile).then((_url) {
          pushData(_url);
        });
      } else
        pushData(widget.post.photo);
    } catch (e) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(e)));
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  void pushData(var photo) {
    crud.updatePost(widget.post.key, {
      'nama': this.nama,
      'umur': this.umur,
      'photo': photo,
      'userId': this.userId,
      'tanggalMeninggal': dateFormat.format(this.tanggalMeninggal),
      'alamat': this.alamat,
      'prosesi': this._processType.toString(),
      'lokasi': this.lokasi,
      'tanggalSemayam': dateFormat.format(this.tanggalSemayam),
      'tempatDimakamkan': this.tempatDimakamkan,
      'waktuSemayam': timeFormat.format(this.waktuSemayam),
      'keterangan': this.keterangan,
      'timestamp': widget.post.timestamp
    }).then((result) => Navigator.pop(context));
  }

  void handleProcessType(value) {
    print('Process type : $value');
    setState(() {
      _processType = value;
    });
  }
}
