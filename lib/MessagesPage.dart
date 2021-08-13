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


class MessagePage extends StatefulWidget {

  @override
  State<MessagePage> createState() => MessagePageState();
}

class MessagePageState extends State<MessagePage> {
  var _messageController =TextEditingController();

  void sendText(String text) {
    User user = FirebaseAuth.instance.currentUser;

    try {
      FirebaseFirestore.instance.collection("Messages").add(
          {
            "from": user.uid,
            "when": Timestamp.fromDate(DateTime.now().toUtc()),
            "msg": text,
            "room":MyChatApp.roomName,

          }
      );
    }
    catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(e.toString())
        ),
      );
      // print("blad="+e.toString());
    }
  }

  Stream<QuerySnapshot> getMessages() =>
      FirebaseFirestore.instance
          .collection("Messages")
          .where('room', isEqualTo: MyChatApp.roomName)
      //  .where('room', isEqualTo: "/Polska/", )
          .where('when',  isGreaterThanOrEqualTo: new DateTime.now().subtract(Duration( hours: 1  ))  )
          .orderBy("when", descending: true)
          .snapshots();

  _goBack(BuildContext context) {
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(



      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
              stream: getMessages(),
              builder: (context, snapshot) {

                print("RET="+ snapshot.hasData.toString());

                return Stack(
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

                      snapshot.hasData ?
                      MessagesList(snapshot.data as QuerySnapshot)
                          :
                      Center(child: CircularProgressIndicator())
                    ]
                );
              },
            ),
          ),

          Row(
            children: <Widget>[

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:

                Container(
                  alignment: Alignment.centerLeft,
                  decoration:  kBoxDecorationStyle,
                  child: TextField(
                  controller: _messageController,
                  keyboardType: TextInputType.text,
                  onSubmitted: (txt) {

                  if( txt==null || txt.isEmpty ||  txt.length>50){
                  ScaffoldMessenger.of(context).showSnackBar( SnackBar(content:   Text("Wrong post")));
                  return;
                  }

                  sendText(txt);
                  _messageController.clear();
                  },
            style: TextStyle(
            color: Colors.white,
            fontFamily: 'OpenSans'
            ),
            decoration: InputDecoration(
            border:InputBorder.none,
            contentPadding: EdgeInsets.only(top:14.0),
            prefixIcon:Icon(
            Icons.email,
            color: Colors.white,
            ),
            hintText:'Enter your post',
            hintStyle: kHintTextStyle,
            ),
            ),
            )

                ),
              ),
              IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    sendText(_messageController.text);
                    _messageController.clear();
                  }
              )
            ],
          )
        ],
      ),
    );
  }
}


class MessagesList extends StatelessWidget {
  MessagesList(this.data);

  final QuerySnapshot data;

  bool areSameDay(Timestamp a, Timestamp b) {
    var date1 = a.toDate().toLocal();
    var date2 = b.toDate().toLocal();
    return
      (date1.year == date2.year)
          &&
          (date1.month == date2.month)
          &&
          (date1.day == date2.day);
  }

  @override
  Widget build(BuildContext context) =>
      ListView.builder(
          reverse: true,
          itemCount: data.docs.length,
          itemBuilder: (context, i) {
            var months = [
              "January",
              "February",
              "March",
              "April",
              "May",
              "June",
              "July",
              "August",
              "September",
              "October",
              "November",
              "December"
            ];

            DateTime when = data
                .docs[i].get("when")
                .toDate()
                .toLocal();

            CollectionReference users = FirebaseFirestore.instance.collection('Users');

            print("PRINT="+when.toString()+" "+data.docs[i].get("from").toString()+" "+users.doc(data.docs[i].get("from")).get().toString());

            var widgetsToShow = <Widget>[
              FutureBuilder<DocumentSnapshot>(
                future: users.doc(data.docs[i].get("from")).get(),
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if( snapshot.hasData) {
                    print("PRINT2a="+snapshot.hasData.toString());

                    print("PRINT2="+(snapshot.data as DocumentSnapshot).data().toString());

                    var mess = Message(
                        from: (snapshot.data as DocumentSnapshot).data(),
                        msg: data.docs[i].get("msg"),
                        when: when,
                        uid: data.docs[i].get("from")
                    );
                    print("PRINT3="+mess.from["displayName"]);

                    return mess;
                  }
                  else {
                    return CircularProgressIndicator();
                  }

                },
              ),
            ];

            if(i == data.docs.length-1) {
              widgetsToShow.insert(
                  0,
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      "${when.day} ${months[when.month-1]} ${when.year}",
                      style: Theme.of(context).textTheme.subhead,
                    ),
                  )
              );
            } else if(
            !areSameDay(
                data.docs[i+1].get("when"),
                data.docs[i].get("when")
            )
            ) {
              widgetsToShow.insert(
                  0,
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                        "${when.day} ${months[when.month-1]} ${when.year}",
                        style: Theme.of(context).textTheme.subhead
                    ),
                  )
              );
            }
            return Column(
                children: widgetsToShow
            );
          }
      );
}

class Message extends StatelessWidget {
  Message({this.from, this.msg, this.when, this.uid});

  final Map<String, dynamic> from;
  final String uid;
  final String msg;
  final DateTime when;

  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser;

    return Container(
        alignment: user.uid == uid
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Container(
          width: MediaQuery
              .of(context)
              .size
              .width / 3 * 2,
          child: Card(
              shape: StadiumBorder(),
              child: ListTile(
                title: user.uid != uid
                    ?
                InkWell(
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 8.0,
                        left: 5.0
                    ),
                    child: Text(
                        from["displayName"],
                        style: Theme
                            .of(context)
                            .textTheme
                            .subtitle
                    ),
                  ),
                  /* onTap: () =>
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage(from)
                          )
                      ),*/
                )
                    :
                InkWell(
                  child: Padding(
                    padding: EdgeInsets.only(left: 5.0),
                    child: Text(
                        "You",
                        style: Theme
                            .of(context)
                            .textTheme
                            .subtitle
                    ),
                  ),
                  onTap: () =>
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage(from)
                          )
                      ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(
                      bottom: 10.0,
                      left: 5.0
                  ),
                  child: Text(
                      msg,
                      style: Theme
                          .of(context)
                          .textTheme
                          .body1
                  ),
                ),
                trailing: Text("${when.hour}:${when.minute}"),
              )
          ),
        )
    );
  }
}
