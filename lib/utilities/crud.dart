import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class CRUD {
  CollectionReference postRef = Firestore.instance.collection('posts');

  Future<void> addPost(postData) async {
    postRef.add(postData).catchError((e) {
      print(e);
    });
  }

  getPost() async {
    return await postRef.orderBy("timestamp", descending: true).getDocuments();
  }

  updatePost(postId, postData) {
    postRef.document(postId).updateData(postData).catchError((e) {
      print(e);
    });
  }

  deletePost(postId) {
    postRef.document(postId).delete().catchError((e) {
      print(e);
    });
  }
}
