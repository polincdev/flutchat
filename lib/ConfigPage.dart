// @dart=2.9
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import '/constants.dart';
import 'package:loading_overlay/loading_overlay.dart';
import '/RoomPage.dart';
import '/ChatPage.dart';

class ConfigPage extends StatelessWidget {
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();

  void setDataAndGoToChatPage(String name, String bio,BuildContext context) {
    User user=  FirebaseAuth.instance.currentUser;

    user.updateProfile(displayName: name);

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatPage(),
        )
    );
    FirebaseFirestore
        .instance
        .collection("Users")
        .doc(user.uid)
        .set(
        {
          "bio": bio,
          "displayName": name,
          "email": user.email,
        }
    );



  }
  @override
  Widget build(BuildContext context) {

    _nameController.text=DateTime.now().millisecondsSinceEpoch.toString();

    return Scaffold(
      appBar: AppBar(title: Text("Account data")),
      body: Stack(
    children: <Widget>[
    Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF73AEF5),
            Color(0xFF61A4F1),
            Color(0xFF478DE0),
            Color(0xFF398AE5),
          ],
          stops: [0.1, 0.4, 0.7, 0.9],
        ),
      ),
    ),

    Container(
    height: double.infinity,
    padding: EdgeInsets.symmetric(
          horizontal: 40.0,
          vertical: 20.0,
        ),
    child: ListView(
        children: <Widget>[

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Name',
                style: kLabelStyle,
              ),
              SizedBox(height: 10.0),
              Container(
                alignment: Alignment.centerLeft,
                decoration: kBoxDecorationStyle,
                height: 60.0,
                child: TextField(
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'OpenSans',
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 14.0),
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    hintText: 'User name',
                    hintStyle: kHintTextStyle,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 10.0),
            Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
            Text(
            'Trip [OPTIONAL]',
            style: kLabelStyle,
            ),
            SizedBox(height: 10.0),
            Container(
            alignment: Alignment.centerLeft,
            decoration: kBoxDecorationStyle,
            height: 60.0,
            child: TextField(
              controller: _bioController,
            keyboardType: TextInputType.name,
            style: TextStyle(
            color: Colors.white,
            fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14.0),
            prefixIcon: Icon(
            Icons.add_moderator,
            color: Colors.white,
            ),
            hintText: 'Trip',
            hintStyle: kHintTextStyle,
            ),
            ),
            ),
            ],
            ),

             Container(
            padding: EdgeInsets.symmetric(vertical: 25.0),
            width: double.infinity,
            child:  RaisedButton(
            elevation: 5.0,
            onPressed:(){

              var name= _nameController.text;
              if( name==null || name.isEmpty || name.length<3 || name.length>25){
                ScaffoldMessenger.of(context).showSnackBar( SnackBar(content:   Text("Wrong name")));
                return;
              }
              var trip= _bioController.text;
              if(trip.length>20){
                ScaffoldMessenger.of(context).showSnackBar( SnackBar(content:   Text("Wrong trip")));
                return;
              }

              setDataAndGoToChatPage(
                  _nameController.text,
                  _bioController.text, context
              );
            },
            padding: EdgeInsets.all(15.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            color: Colors.white,
            child:Text('ENTER', style: TextStyle(
                color: Color(0xFF527DAA),
                letterSpacing:1.5,
                fontSize:18.0,
                fontWeight:FontWeight.bold,
                fontFamily:'OpenSans'
            )),

          ),
             ),
        ],
      ),
    ),
        ]
     )
    );
  }
}
