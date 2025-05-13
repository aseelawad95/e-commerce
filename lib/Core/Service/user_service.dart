import 'dart:collection';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/Screens/Auth/login_screen.dart';
import 'package:e_commerce/Core/Service/session.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../Models/user_model.dart';

class UserService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = 'UserData';
  User? user;
  int statusCode = 0;
  String msg = '';

  Future<String> signIn(String email, String password) async {
    var msg = '';
    var uid = '';
    try {
      var user = (await _firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
      uid = user!.uid;
      Prefs.setStringValue('uid', uid);
      Prefs.setBooleanValue('loginState', true);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        msg = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        msg = 'Wrong password provided for that user.';
      }
    }
    if (msg.isEmpty) {
      return uid;
    }
    return msg;
  }

  Future<void>  logOut(context) async {
    await Prefs.clear();
    await Prefs.setBool('loginState', false);
    Navigator.push(
            context, MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  Future<String> signUp(HashMap userValues) async {
    var msg = '';
    try {
      var user = (await _firebaseAuth.createUserWithEmailAndPassword(
              email: userValues['email'], password: userValues['password']))
          .user;
      var model = UserModel(
          uid: user!.uid,
          name: userValues['name'],
          email: userValues['email'],
          password: userValues['password'],
          loginState: true,
          state: true);
      msg = user.uid;
      await addUser(model);
      Prefs.setStringValue('uid', model.uid!);
      Prefs.setBooleanValue('loginState', true);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        msg = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        msg = 'The account already exists for that email.';
      }
    } catch (e) {
      msg = '$e';
    }
    return msg;
  }

  Future<void> addUser(UserModel model) async {
    await _firestore
        .collection(collectionName)
        .add(model.toJson())
        .catchError((err) {
      handleAuthErrors(err);
    });
  }

  Future<UserModel> getUser(String uid) async {
    var result = await _firestore
        .collection(collectionName)
        .where('uid', isEqualTo: uid)
        .get();
    return UserModel.fromJson(result.docs[0].data());
  }

  Future<UserModel> getUserData(String uid) async {
    QuerySnapshot query = await _firestore
        .collection(collectionName)
        .where('uid', isEqualTo: uid)
        .get();
    var data = query.docs[0];
    Map<String, dynamic> dataMap = {
      'uid': data.get('uid'),
      'name': data.get('name'),
      'email': data.get('email'),
      'password': data.get('password'),
      'loginState': data.get('loginState'),
      'state': data.get('state'),
    };
    return UserModel.fromJson(dataMap);
  }

  Future<List<UserModel>> getUsers() async {
    List<UserModel> result = [];
    QuerySnapshot query = await _firestore.collection(collectionName).get();
    for (var item in query.docs) {
      result.add(UserModel.fromJson(item.data() as Map<String, dynamic>));
    }
    return result;
  }

  void handleAuthErrors(ArgumentError error) {
    String errorCode = error.message;
    switch (errorCode) {
      case "ABORTED":
        {
          statusCode = 400;
          msg = "The operation was aborted";
        }
        break;
      case "ALREADY_EXISTS":
        {
          statusCode = 400;
          msg = "Some document that we attempted to create already exists.";
        }
        break;
      case "CANCELLED":
        {
          statusCode = 400;
          msg = "The operation was cancelled";
        }
        break;
      case "DATA_LOSS":
        {
          statusCode = 400;
          msg = "Unrecoverable data loss or corruption.";
        }
        break;
      case "PERMISSION_DENIED":
        {
          statusCode = 400;
          msg =
              "The caller does not have permission to execute the specified operation.";
        }
        break;
      default:
        {
          statusCode = 400;
          msg = error.message;
        }
        break;
    }
    log('msg : $msg');
  }
}
