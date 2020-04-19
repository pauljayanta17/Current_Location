import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:location/location.dart';
import 'package:loginpagedemo/userpage.dart';
import 'package:progress_dialog/progress_dialog.dart';



class forgotpassword extends StatefulWidget {
  @override
  _forgotpasswordState createState() => _forgotpasswordState();
}

class _forgotpasswordState extends State<forgotpassword> {

  ProgressDialog progressDialog3;
  TextEditingController _controller;
  final _formkey=GlobalKey<FormState>();
  String _email;
  @override
  Widget build(BuildContext context) {

    progressDialog3=ProgressDialog(context,type: ProgressDialogType.Normal);
    progressDialog3.style(
      progress: 1,
      borderRadius: 10,
      elevation: 10.0,
      backgroundColor: Colors.white,
      message:"Please Wait",
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text("Forgot Password"),automaticallyImplyLeading: false,centerTitle: true,),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image(
              fit: BoxFit.cover,
              image: AssetImage("assets/forgot.jpeg"),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height/2,
                  width: MediaQuery.of(context).size.width/1.5,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusDirectional.circular(20),
                    ),
                    elevation: 10.0,
                    color: Colors.white10,
                    child: Form(
                      key: _formkey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Card(
                            color: Colors.white,
                            elevation: 10.0,
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: "Enter Your Email",
                                labelStyle: TextStyle(
                                    fontSize: 25,
                                    letterSpacing: 1.2,
                                    fontWeight: FontWeight.w600
                                ),
                              ),
                              controller: _controller,
                              onChanged: (value){
                                _email=value;
                              },
                              validator: (value){
                                if(value.isEmpty)
                                {
                                  return "Enter the email";
                                }
                              },

                            ),
                          ),
                          SizedBox(height: 30,),
                          RaisedButton(
                            child: Text("Send "),
                            elevation: 8.0,
                            color: Colors.lightGreen,
                            onPressed: ()
                            {
                              FirebaseAuth.instance.sendPasswordResetEmail(email: _email).then((value){
                                progressDialog3.show();
                                Future.delayed(Duration(seconds: 1)).then((value1){
                                  progressDialog3.hide().whenComplete((){
                                    Fluttertoast.showToast(
                                        msg: "Send email successfully",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 13.0
                                    );
                                    progressDialog3.dismiss();
                                    Navigator.of(context).push(MaterialPageRoute(builder: (consd)=>userpage()));

                                  });

                                });

                              }).catchError((e){
                                if(e.toString().contains("ERROR_INVALID_EMAIL"))
                                {
                                  Fluttertoast.showToast(
                                    msg:"Wrong Email Id",
                                    toastLength: Toast.LENGTH_LONG,
                                    webBgColor: "#e74c3c",
                                    timeInSecForIosWeb: 5,
                                  );
                                }
                              });

                            },
                          )

                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        )

      ),
    );
  }
}
