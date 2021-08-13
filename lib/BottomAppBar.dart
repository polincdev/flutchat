// @dart=2.9
import 'package:flutter/material.dart';
import '/BottomSheet.dart';
class BottomNavBar extends StatefulWidget {

   Function _onItemTapped;
   BottomNavBarState bottomNavBarState;
  @override
  State<StatefulWidget> createState() {
    bottomNavBarState=BottomNavBarState();
    return bottomNavBarState;
  }

  int getSelectedIndex () {
    if (bottomNavBarState != null) return bottomNavBarState.selectedIndex;
     else return 0;
  }
}
  class BottomNavBarState extends State<BottomNavBar> {
    int selectedIndex = 0;
  Widget build(BuildContext context) {
    return new Theme(
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
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }

}

