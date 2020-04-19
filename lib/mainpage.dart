import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:location/location.dart';
import 'package:loginpagedemo/main.dart';
import 'package:search_map_place/search_map_place.dart';
import 'package:loginpagedemo/userpage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:progress_dialog/progress_dialog.dart';


main()=>runApp(mainpage());

class mainpage extends StatefulWidget {
  @override
  _mainpageState createState() => _mainpageState();
}

class _mainpageState extends State<mainpage> {
  ProgressDialog progressDialog2;

  var lat = 20.5937,
      lang = 78.9629;

  // for on back pressed show notification

  final _formkey = GlobalKey<FormState>();

  Future<bool> _onbackpressed() {
    return showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(


              title: Text("Log Out ?",
                style: TextStyle(fontSize: 25, color: Colors.indigo),),
              actions: <Widget>[
                FlatButton(
                  child: Text("Yes"),
                  focusColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.circular(10),
                  ),
                  onPressed: () {

                  },
                ),

                FlatButton(
                    child: Text("No"),
                    focusColor: Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusDirectional.circular(10),
                    ),
                    onPressed: () {
                      Navigator.pop(context, false);
                    }

                ),
              ],
            )

    );
  }


  // for google map location

  // StreamSubscription _locationsubscription;
  Completer<GoogleMapController> _mapController = Completer();
  GoogleMapController _controller;
  Location _locationtracker = Location();
  final Set<Marker> _makers={};
  Circle circle;
  String searchaddress;
  TextEditingController _controllertext;

  final CameraPosition _initialCamera = CameraPosition(
    target: LatLng(-20.3000, -40.2990),
    zoom: 14.0000,
  );

  @override
  Widget build(BuildContext context) {
    progressDialog2=ProgressDialog(context, type: ProgressDialogType.Normal);
    progressDialog2.style(
      message: "Please Wait",
      borderRadius: 6,
      backgroundColor: Colors.white,
      elevation: 10.0,
      maxProgress: 1,

    );
    return WillPopScope(
      onWillPop: () =>
          showDialog(
              context: context,
              builder: (context) =>
                  AlertDialog(


                    title: Text("Log Out ?",
                      style: TextStyle(fontSize: 25, color: Colors.indigo),),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("Yes"),
                        focusColor: Colors.purple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusDirectional.circular(10),
                        ),
                        onPressed: () {
                          FirebaseAuth.instance.signOut().then((value) {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (cob) => userpage()));
                          }).catchError((r) {
                            print(r);
                          });
                        },
                      ),

                      FlatButton(
                          child: Text("No"),
                          focusColor: Colors.purple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusDirectional.circular(10),
                          ),
                          onPressed: () {
                            Navigator.pop(context, false);
                          }

                      ),
                    ],
                  )

          ),






      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepPurple,
            title: Text("MainPage"),
            automaticallyImplyLeading: false,
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) =>
                          AlertDialog(


                            title: Text("Log Out ?", style: TextStyle(
                                fontSize: 25, color: Colors.indigo),),
                            actions: <Widget>[
                              FlatButton(
                                child: Text("Yes"),
                                focusColor: Colors.purple,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadiusDirectional
                                      .circular(10),
                                ),
                                onPressed: () {

                                  setState(() {
                                    FirebaseAuth.instance.signOut().then((value) {
                                      progressDialog2.show();
                                      Future.delayed(Duration(seconds: 1)).then((onValue){
                                        progressDialog2.hide().whenComplete((){
                                          Fluttertoast.showToast(
                                              msg: "Logout Successfully",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 13.0
                                          );
                                          Navigator.push(
                                              context,MaterialPageRoute(
                                              builder: (cob) => userpage()));
                                          progressDialog2.dismiss();
                                        }).catchError((){
                                          progressDialog2.hide();
                                        });

                                      });

                                    }).catchError((r) {
                                      print(r);
                                    });
                                  });

                                },
                              ),

                              FlatButton(
                                  child: Text("No"),
                                  focusColor: Colors.purple,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadiusDirectional
                                        .circular(10),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context, false);
                                  }

                              ),
                            ],
                          )

                  );
                },
                icon: Icon(Icons.power_settings_new),
                color: Colors.red,
              ),
            ],
          ),
          body: Stack(
            children: <Widget>[


              GoogleMap(
                initialCameraPosition: _initialCamera,
                mapType: MapType.hybrid,
                onMapCreated: _onmapcreaed,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                markers: Set.from(_makers),
                compassEnabled: true,
                trafficEnabled: true,
                zoomGesturesEnabled: true,
              ),



            Positioned(

              top: 30,
              left: 15,
              right: 15,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white
                ),
                child: Form(
                  key: _formkey,
                  child: TextFormField(
                    validator: (validator){
                      if(validator.isEmpty){
                        return "Enter address";
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "Enter an Address",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(top: 15.0,left: 15.0),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: (){
                          setState(() {
                            if(_formkey.currentState.validate())
                            {
                              _searchadd();
                            }


                          });

                        },
                        color: Colors.purple,
                        iconSize: 30,
                      ),
                    ),
                    onChanged: (val){
                      setState(() {
                        searchaddress=val;
                      });
                    },
                  ),
                ),
              ),

            ),

            ],
          ),
          floatingActionButton: FloatingActionButton(
              child: Icon(Icons.location_on),
              onPressed: () {
                setState(() {
                  mylocation();
                });

              }

          ),
        ),
      ),
    );
  }


  void _onmapcreaed(GoogleMapController controller) {
    setState(() {
      _mapController.complete(controller);
    });
  }


  void mylocation() async {
    final GoogleMapController controller = await _mapController.future;
    var pos = await _locationtracker.getLocation();

    setState(() {
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(pos.latitude,pos.longitude),
        zoom: 19.0,
      )));
    });
  }


  void _searchadd() async{
    final GoogleMapController controller = await _mapController.future;

    setState(() {
      Geolocator().placemarkFromAddress(searchaddress).then((Value){

        _makers.clear();
        _makers.add(Marker(
          markerId: MarkerId(searchaddress),
          position: LatLng(Value[0].position.latitude,Value[0].position.longitude),

        ));

        controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(Value[0].position.latitude,Value[0].position.longitude),
          zoom: 10.0,
          tilt: 10.0
        )));

    });
    });
  }
}
