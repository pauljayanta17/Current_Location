import 'dart:io';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loginpagedemo/forgotpassword.dart';
import 'package:loginpagedemo/mainpage.dart';
import 'package:loginpagedemo/signinpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class userpage extends StatefulWidget {
  @override
  _userpageState createState() => _userpageState();
}

class _userpageState extends State<userpage> {

  String _email,_password,curr_email="Enter Email ",curr_pass="Enter password";
  bool state=true;
  ProgressDialog progressDialogmain;

  final _formkey = GlobalKey<FormState>();
  final appbar = AppBar(
    title: Text("Login Page"),
    backgroundColor: Colors.indigo[300],
    elevation: 8.0,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.circular(10)
    ),
    automaticallyImplyLeading: false,
    brightness: Brightness.dark,
    bottomOpacity: 20,
    centerTitle: true,
  );


  static final decoration = InputDecoration(
    border: OutlineInputBorder(),
    counterStyle: TextStyle(fontSize: 25,color: Colors.blueAccent,fontWeight: FontWeight.w600,fontStyle: FontStyle.italic,debugLabel: "ENTER",letterSpacing: .3,decorationThickness: 3.0),
    focusColor: Colors.blue,
    hoverColor: Color.fromRGBO(255, 215, 0,50),
    filled: true,
    hintText: "Email ID",
    icon: Icon(Icons.email),
    hintStyle: TextStyle(fontWeight: FontWeight.w900,color: Colors.indigo,),
    labelText: "Email ID",
    isDense: false,

  );


  static final decorationforpasswword = InputDecoration(
    border: OutlineInputBorder(),
    counterStyle: TextStyle(fontSize: 25,color: Colors.blueAccent,fontWeight: FontWeight.w600,fontStyle: FontStyle.italic,debugLabel: "ENTER",letterSpacing: .3,decorationThickness: 3.0),
    focusColor: Colors.blue,
    hoverColor: Color.fromRGBO(255, 215, 0,50),
    filled: true,
    hintText: "Password",
    icon: Icon(Icons.vpn_key),
    hintStyle: TextStyle(fontWeight: FontWeight.w900,),
    labelText: "Enter Your Password",
    isDense: false,

  );



  Future<bool> _onbackpressed(){
    return showDialog(
        context: context,
        builder:(context)=>AlertDialog(


          title: Text("Exit ?",style: TextStyle(fontSize: 25,color: Colors.indigo),),
          actions: <Widget>[
            FlatButton(
              child: Text("Yes"),
              focusColor: Colors.purple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(10),
              ),
              onPressed: ()
              {
                exit(0);
              },
            ),

            FlatButton(
                child: Text("No"),
                focusColor: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusDirectional.circular(10),
                ),
                onPressed: () {

                  Navigator.pop(context,false);

                }

            ),
          ],
        )

    );
  }





  @override
  Widget build(BuildContext context) {

    progressDialogmain=ProgressDialog(context, type: ProgressDialogType.Normal);
    progressDialogmain.style(
      message: "Please Wait",
      borderRadius: 6,
      backgroundColor: Colors.white,
      elevation: 10.0,
      maxProgress: 1,

    );
    return WillPopScope(
      onWillPop: _onbackpressed,
      child: Scaffold(
        appBar: appbar,
        body: Stack(
          fit: StackFit.expand,

          children: <Widget>[
            Image(image: AssetImage("assets/login.jpg"),fit: BoxFit.cover,color: Colors.lightBlue,colorBlendMode: BlendMode.plus,),
            SingleChildScrollView(
             padding: EdgeInsets.symmetric(vertical: 120,horizontal: 0),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30,0),
                child: Column(mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Form(
                      key: _formkey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextFormField(
                            decoration: decoration,
                            validator: (value)
                            {
                              if(value.isEmpty)
                              {
                                return curr_email;
                              }return null;
                            },
                            onFieldSubmitted: (value)
                            {
                              print("$value");
                            },
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (val)
                            {
                              if(val.contains(" ")==true)
                                {
                                }
                              else{
                                _email=val;
                              }

                            },

                          ),


                          Padding(padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),),
                          TextFormField(
                            decoration: decorationforpasswword,
                            enabled: state,
                            validator: (value)
                            {
                              if(value.isEmpty)
                              {
                                return curr_pass;
                              }return null;
                            },
                            onFieldSubmitted: (value)
                            {
                              print("$value");

                            },

                            onChanged: (val)
                            {
                              _password=val;
                            },

                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,

                          ),


                          SizedBox(
                            height:90,
                            width: 300,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(60, 30, 30,0),
                              child: CupertinoButton(
                                child: Text("Login"),
                                color: Colors.blue,
                                onPressed: ()
                                {
                                  if(_formkey.currentState.validate())

                                  {
                                    FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password).then((FirebaseUser){
                                      progressDialogmain.show();
                                      Future.delayed(Duration(seconds: 2)).then((onValue){
                                        progressDialogmain.hide().whenComplete((){
                                          Fluttertoast.showToast(
                                              msg: "Login Successfully",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 13.0
                                          );
                                          Navigator.of(context).push(MaterialPageRoute(builder: (cont)=>mainpage()));
                                          progressDialogmain.dismiss();
                                          _formkey.currentState.save();
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

                                     if(e.toString().contains("WRONG_PASSWORD"))
                                        {
                                          Fluttertoast.showToast(
                                            msg:"Wrong Password",
                                            toastLength: Toast.LENGTH_LONG,
                                            webBgColor: "#e74c3c",
                                            timeInSecForIosWeb: 5,
                                          );
                                        }


                                     if(e.toString().contains("ERROR_USER_NOT_FOUND"))
                                       {
                                              Fluttertoast.showToast(msg: "Account not register",
                                              backgroundColor: Colors.white,
                                                fontSize: 15,
                                                webBgColor: Colors.deepPurple,
                                                toastLength: Toast.LENGTH_LONG
                                              );
                                       }

                                      print(e);


                                    });

                                  }

                                },
                              ),
                            ),

                          ),


                          SizedBox(
                            height:70,
                            width: 230,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(60, 30, 30,0),
                              child: MaterialButton(
                                child: Text("Sign Up"),
                                color: Colors.lightGreenAccent,
                                onPressed: ()
                                {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>signinpage()));
                                },
                              ),
                            ),

                          ),


                          SizedBox(
                            height:60,
                            width: 220,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(60, 30, 30,0),
                              child: RaisedButton(
                                child: Text("Forgot Password"),
                                color: Colors.amberAccent
                                ,
                                onPressed: ()
                                {
                                    Navigator.push(context, MaterialPageRoute(builder: (c)=>forgotpassword()));
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

