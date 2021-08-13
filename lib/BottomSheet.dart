// @dart=2.9
import 'package:flutter/material.dart';

Future showSettingsModel(BuildContext context) async {

  final option = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context){
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: new Icon(Icons.photo),
              title: new Text('Photo'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Divider(height: 60),
            ListTile(
              leading: new Icon(Icons.music_note),
              title: new Text('Music'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Divider(height: 60),
            ListTile(
              leading: new Icon(Icons.videocam),
              title: new Text('Video'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Divider(height: 60),
            ListTile(
              leading: new Icon(Icons.share),
              title: new Text('Share'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      }

  );

}

