import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class CRUD {
  CollectionReference postRef = Firestore.instance.collection('posts');
  CollectionReference commentRef = Firestore.instance.collection('comments');

  Future<void> addPost(postData) async {
    postRef.add(postData).catchError((e) {
      print(e);
    });
  }

  Future<void> addComment(commentData) async {
    commentRef.add(commentData).catchError((e) {
      print(e);
    });
  }

  getPost() {
    return postRef.orderBy("timestamp", descending: true);
  }

  getComment(postId) {
    return commentRef.orderBy("timestamp", descending: true).where('postId',isEqualTo: postId);
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
