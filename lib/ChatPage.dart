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
import '/BottomSheet.dart';
import '/ProfilePage.dart';
import '/MessagesPage.dart';
import '/BioPage.dart';
import '/ChatDrawer.dart';

class ChatPage extends StatefulWidget {

  @override
  State<ChatPage> createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {

  _goBack(BuildContext context) {
    Navigator.pop(context);
  }

  List<Widget> _widgetOptions = <Widget>[
    MessagePage(),
    ChangeBioPage(),
  ];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyChatApp.roomName),
        /*leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          iconSize: 20.0,
          onPressed: () {
            _goBack(context);
          },
        ),*/
        actions: [
          IconButton(
            tooltip: "Change your bio",
            icon: Icon(Icons.edit),
            onPressed: () =>
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChangeBioPage()
                    )
                ),
          )
        ],
      ),
      drawer: buildDrawer(),

      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
// sets the background color of the `BottomNavigationBar`
            canvasColor: Colors.blueGrey,
// sets the active color of the `BottomNavigationBar` if `Brightness` is light
            primaryColor: Colors.red,
            textTheme: Theme
                .of(context)
                .textTheme
                .copyWith(caption: new TextStyle(color: Colors.yellow))),
        // sets the inactive color of the `BottomNavigationBar`
        child: BottomNavigationBar(
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[

            BottomNavigationBarItem(
              icon: Icon(Icons.arrow_upward),
              label: 'Messages',
              backgroundColor: Colors.blueAccent,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: 'User',
              backgroundColor: Colors.blueGrey,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
              backgroundColor: Colors.lightBlue,


            ),
          ],
          currentIndex: selectedIndex,
          selectedItemColor: Colors.amber[800],
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            if(index==2)
              showSettingsModel(context);
            else
            setState(() {
              selectedIndex = index;
            });
          },
        ),
      ),

      body: _widgetOptions.elementAt(selectedIndex),
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
