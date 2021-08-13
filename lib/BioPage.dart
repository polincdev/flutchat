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
import '/ConfigPage.dart';


class ChangeBioPage extends StatelessWidget {
  final _controller = TextEditingController();

  ChangeBioPage( );

  void _changeBio(String bio)
  {
    User user = FirebaseAuth.instance.currentUser;

    FirebaseFirestore
        .instance
        .collection("Users")
        .doc(user.uid)
        .update(
        {
          "bio": bio
        });
  }


  @override
  Widget build(context) =>
      Scaffold(
          appBar: AppBar(
            title: Text("Change your trip"),
          ),
          body: Center(
            child:
            Stack(
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
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                            controller: _controller,

                            decoration: InputDecoration(
                                labelText: "Trip"
                            ),
                            onSubmitted: (bio) {
                              _changeBio(bio);
                              Navigator.pop(context);
                            }
                        ),
                      ),
                      FlatButton(
                          child: Text("Change Bio"),
                          onPressed: () {
                            _changeBio(_controller.text);
                            Navigator.pop(context);
                          }
                      )
                    ],
                  ),
                ]
            ),
          )
      );
}
