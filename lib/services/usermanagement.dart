import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loginpagedemo/mainpage.dart';
class UserManagement{
  storeNewUser(user,context)
  {
    Firestore.instance.collection('/user').add({
      'email': user.email,
      'uid': user.uid

    }).then((value){
      Navigator.pop(context);
    }).catchError((e){
      print(e);
    });
  }
}