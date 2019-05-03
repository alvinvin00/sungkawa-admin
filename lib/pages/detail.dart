import 'package:Sungkawa/model/post.dart';
import 'package:Sungkawa/pages/comment_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Detail extends StatefulWidget {
  final Post post;

  Detail(this.post);

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
              title: Text(widget.post.nama),
              centerTitle: true,
              background: CachedNetworkImage(
                imageUrl: widget.post.photo,
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
                    "Nama : " + widget.post.nama,
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Text(
                    "Alamat : " + widget.post.alamat,
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Text(
                    "Usia : " + widget.post.usia + " tahun",
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Divider(
                    color: Colors.green,
                  ),
                  Text(
                    "Tanggal Meninggal : " + widget.post.tanggalMeninggal,
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Divider(
                    color: Colors.green,
                  ),
                  Text(
                    'Disemayamkan di ' + widget.post.lokasiSemayam,
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Text(
                    "Tanggal disemayamkan : " + widget.post.tanggalSemayam,
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Divider(
                    color: Colors.green,
                  ),
                  Text(
                    widget.post.prosesi +
                        ' di ' +
                        widget.post.tempatMakam +
                        ' pada ' +
                        widget.post.tanggalSemayam +
                        ' pukul ' +
                        widget.post.waktuSemayam,
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Divider(
                    color: Colors.green,
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CommentPage(widget.post)));
        },
        child: Icon(Icons.comment),
      ),
    );
  }
}
