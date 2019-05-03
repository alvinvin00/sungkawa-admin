import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

//class CRUD {
//  CollectionReference postRef = Firestore.instance.collection('posts');
//  CollectionReference commentRef = Firestore.instance.collection('comments');
//
//  Future<void> addPost(postData) async {
//    postRef.add(postData).catchError((e) {
//      print(e);
//    });
//  }
//
//  Future<void> addComment(commentData) async {
//    commentRef.add(commentData).catchError((e) {
//      print(e);
//    });
//  }
//
//  getPost() {
//    return postRef.orderBy("timestamp", descending: true);
//  }
//
//  getComment(postId) {
//    return commentRef.orderBy("timestamp", descending: true).where('postId',isEqualTo: postId);
//  }
//
//  updatePost(postId, postData) {
//    postRef.document(postId).updateData(postData).catchError((e) {
//      print(e);
//    });
//  }
//
//  deletePost(postId) {
//    postRef.document(postId).delete().catchError((e) {
//      print(e);
//    });
//  }
//}
class CRUD {
  DatabaseReference postRef =
      FirebaseDatabase.instance.reference().child('posts');
  DatabaseReference commentRef =
      FirebaseDatabase.instance.reference().child('comments');
  DatabaseReference adminRef =
      FirebaseDatabase.instance.reference().child('admins');

  Future<void> addAdmin(String adminId, adminData) async {
    adminRef.child(adminId).set(adminData);
  }

  Future<void> addPost(postData) async {
    postRef.push().set(postData).catchError((e) {
      print(e);
    });
  }

  Future<void> addComment(postId, commentData) async {
    commentRef.child(postId).push().set(commentData).catchError((e) {
      print(e);
    });
  }

  updatePost(postId, postData) {
    postRef.child(postId).update(postData).catchError((e) {
      print(e);
    });
  }
}
