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
import '/main.dart';
import '/ConfigPage.dart';
import '/BottomAppBar.dart';
class RoomPage extends StatefulWidget {

  @override
  State<RoomPage> createState() => _RoomPageState();

}


/// This is the private State class that goes with MyStatefulWidget.
class _RoomPageState extends State<RoomPage> {

final _roomController = TextEditingController();


void goToConfigPage(String room, BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ConfigPage(),
      )
  );
}


  @override
  Widget build(BuildContext context) {
    _roomController.text="/def/";
    return Scaffold(
      appBar: AppBar(title: Text("Enter room name eg. /def/")),
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
                        'Room',
                        style: kLabelStyle,
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        alignment: Alignment.centerLeft,
                        decoration: kBoxDecorationStyle,
                        height: 60.0,
                        child: TextField(
                          controller: _roomController,
                          keyboardType: TextInputType.text,
                          inputFormatters: [
                            LowerCaseTextFormatter(),
                          ],
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(top: 14.0),
                            prefixIcon: Icon(
                              Icons.house,
                              color: Colors.white,
                            ),
                            hintText: '/def/',
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

                        var roomName= _roomController.text;
                        if( roomName==null ||  roomName.isEmpty ||  roomName.length<3 ||  roomName.length>20){
                          ScaffoldMessenger.of(context).showSnackBar( SnackBar(content:   Text("Empty room name")));
                          return;
                        }
                        if(!roomName.startsWith("/") && !roomName.endsWith("/") ){
                          ScaffoldMessenger.of(context).showSnackBar( SnackBar(content:   Text("Room name should start and end with '/'")));
                          return;
                        }

                        MyChatApp.roomName= _roomController.text.toLowerCase();

                        goToConfigPage(
                            _roomController.text,
                            context
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
      ),

    );
  }

}

class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
    );
  }
}

