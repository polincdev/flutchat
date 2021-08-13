// @dart=2.9
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';


class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
    );
  }
}


class ProfilePage extends StatelessWidget {
  ProfilePage(this.user);

  final Map<String, dynamic> user;

  @override
  Widget build(context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                        user["displayName"],
                        style: Theme.of(context).textTheme.title
                    ),
                    Text(
                        user["bio"],
                        style: Theme.of(context).textTheme.subtitle
                    ),
                    FlatButton.icon(
                        icon: Icon(Icons.email),
                        label: Text("Send an e-mail to ${user["displayName"]}"),
                        onPressed: () async {
                          var url =
                              "mailto:${user["email"]}?body=${user["displayName"]},\n";
                          if(await canLaunch(url)) {
                            launch(url);
                          } else {
                            Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("You don't have any e-mail app"),
                                )
                            );
                          }
                        }
                    )
                  ],
                ),
              ]
          ),
        )
    );
  }
}
