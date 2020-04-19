

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loginpagedemo/main.dart';
import 'package:loginpagedemo/services/usermanagement.dart';
import 'package:loginpagedemo/userpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'mainpage.dart';


class signinpage extends StatefulWidget {
  @override
  _signinpageState createState() => _signinpageState();
}

class _signinpageState extends State<signinpage> {

  String _email,_password1,_password2;
  bool state=true;
  final _formkey = GlobalKey<FormState>();
final appbar = AppBar(
    title: Text("Sign Up"),
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
  counterStyle: TextStyle(fontSize: 25,color: Colors.blueAccent,fontWeight: FontWeight.w600,fontStyle: FontStyle.italic,debugLabel: "ENTER",letterSpacing: .3,decorationThickness: 3.0),
  focusColor: Colors.blue,
  hoverColor: Color.fromRGBO(255, 215, 0,50),
  filled: true,
  hintText: "Email ID",
  icon: Icon(Icons.email),
  hintStyle: TextStyle(color: Colors.indigo,),
  labelText: "Email Id ",
  isDense: false,

);


  static final decorationforpasswword = InputDecoration(
    counterStyle: TextStyle(fontSize: 25,color: Colors.blueAccent,fontWeight: FontWeight.w600,fontStyle: FontStyle.italic,debugLabel: "ENTER",letterSpacing: .3,decorationThickness: 3.0),
    focusColor: Colors.blue,
    hoverColor: Color.fromRGBO(255, 215, 0,50),
    filled: true,
    hintText: "Enter Password",
    icon: Icon(Icons.vpn_key),
    hintStyle: TextStyle(fontWeight: FontWeight.w900,),
    labelText: "Enter Your Password",
    isDense: false,

  );

  static final decorationforpasswwordconfirm = InputDecoration(
    counterStyle: TextStyle(fontSize: 25,color: Colors.blueAccent,fontWeight: FontWeight.w600,fontStyle: FontStyle.italic,debugLabel: "ENTER",letterSpacing: .3,decorationThickness: 3.0),
    focusColor: Colors.blue,
    hoverColor: Color.fromRGBO(255, 215, 0,50),
    filled: true,
    hintText: "Confirm Password",
    icon: Icon(Icons.vpn_key),
    hintStyle: TextStyle(fontWeight: FontWeight.w900,),
    labelText: "Confirm your Password",
    isDense: false,

  );


  ProgressDialog progressDialog1;

  @override
  Widget build(BuildContext context) {
    progressDialog1=ProgressDialog(context,type: ProgressDialogType.Normal);
    progressDialog1.style(
      message: "Please Wait",
      maxProgress: 1,
      elevation: 10.0,
      backgroundColor: Colors.deepPurple,
      borderRadius: 10,
      progress: 1,
    );
    return Scaffold(
      appBar: appbar,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image(image: AssetImage("assets/register.jpg"),fit: BoxFit.cover,color: Colors.deepPurple,colorBlendMode: BlendMode.dstATop,),
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 120,horizontal: 0),
            reverse: true,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30,0),
              child: Column(mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Card(
                    child: Form(
                      key: _formkey,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30, 30, 40,30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextFormField(
                              decoration: decoration,
                              validator: (value)
                              {
                                if(value.isEmpty)
                                {
                                  return "Enter Email ";
                                }return null;
                              },
                              onFieldSubmitted: (value)
                              {
                                print("$value");
                              },
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (value)
                              {
                                setState(() {
                                  if(value.contains(" ")==true)
                                    {

                                    }
                                  else
                                    {
                                      _email=value;
                                    }
                                });
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
                                  return "password does not match";
                                }return null;
                              },
                              onFieldSubmitted: (value)
                              {
                                print("$value");

                              },
                              onChanged: (value)
                              {
                                setState(() {

                                  _password1=value;
                                });
                              },


                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,

                            ),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),),
                            TextFormField(
                              decoration: decorationforpasswwordconfirm,
                              enabled: state,
                              validator: (value)
                              {
                                if(value.isEmpty)
                                {
                                  return "password does not match";
                                }return null;
                              },
                              onFieldSubmitted: (value)
                              {
                                print("$value");

                              },
                              onChanged: (value)
                              {
                                setState(() {
                                  _password2=value;
                                });
                              },



                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,

                            ),

                            Padding(padding: EdgeInsets.only(top: 30),),
                            CupertinoButton(
                              padding: EdgeInsets.all(20),
                              child: Text("SIGN UP"),
                              color: Colors.indigo,
                              onPressed: ()
                              {
                                if(_password1==_password2)
                                  {
                                    FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password1).then((signedInUser){
                                      progressDialog1.show();
                                      Future.delayed(Duration(seconds: 2)).then((value){
                                        progressDialog1.hide().whenComplete((){
                                          Navigator.of(context).push(MaterialPageRoute(builder: (c)=>mainpage()));
                                          UserManagement().storeNewUser(signedInUser,context);
                                          progressDialog1.dismiss();
                                        });
                                      });


                                    });
                                  }
                              },
                            ),



                          ],
                        ),
                      ),
                    ),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusDirectional.circular(20)
                    ),
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

