import 'package:flutter/material.dart';
import 'package:sung/model/person.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Detail extends StatefulWidget {
  final Person person;

  Detail(this.person);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 240.0,
            floating: true,
            pinned: true,
            snap: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.person.nama),
              centerTitle: true,
              background: CachedNetworkImage(
                imageUrl: widget.person.photo,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.warning),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverFillRemaining(
            child: Container(
              padding: EdgeInsets.all(16.0),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Telah Meninggal Dunia',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Nama : " + widget.person.nama,
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Text(
                    "Alamat : " + widget.person.alamat,
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Text(
                    "Umur : " + widget.person.umur + " tahun",
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Divider(
                    color: Colors.green,
                  ),
                  Text(
                    "Tanggal Meninggal : " + widget.person.tanggalmeninggal,
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Divider(
                    color: Colors.green,
                  ),
                  Text(
                    'Disemayamkan di ' + widget.person.lokasi,
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Text(
                    "Tanggal disemayamkan : " + widget.person.tanggal_semayam,
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Divider(
                    color: Colors.green,
                  ),
                  Text(
                    widget.person.status_pemakaman +
                        ' di ' +
                        widget.person.tempat_dimakamkan +
                        ' pada ' +
                        widget.person.waktu_semayam +
                        ' pukul ' +
                        widget.person.waktu_semayam,
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Divider(
                    color: Colors.green,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}