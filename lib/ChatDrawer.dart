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
import '/main.dart';
import '/BottomAppBar.dart';
import '/ProfilePage.dart';


Widget buildDrawer(){
  User user = FirebaseAuth.instance.currentUser;

  return Drawer(
  child: ListView(
    children:<Widget>[
      UserAccountsDrawerHeader(
        accountName: Text(user.displayName),
        accountEmail: Text(''),
          decoration: BoxDecoration(color:Colors.blueGrey),
        currentAccountPicture: CircleAvatar(child:Text('U'),backgroundColor: Colors.red,),
      ),
      ListTile(
          title:Text("Poster data"),
          subtitle: Text("Name and trip"),
        leading: Icon(Icons.home, color:Colors.blueGrey),
      ),
      SizedBox(
        child:Container(color:Colors.blueGrey),
        height: 1,
          width:double.infinity,
      ),
      ListTile(
        title:Text("Poster data"),
        subtitle: Text("Name and trip"),
        trailing: Icon(Icons.portrait, color:Colors.blueGrey),
      ),
    ],


  ),

  );
}

