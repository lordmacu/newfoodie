
import 'package:foodie/planner.dart';
import 'package:foodie/profile.dart';
import 'package:flutter/material.dart';
import 'package:foodie/favorites.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodie/home_screen.dart';

class AppBottomBar extends StatefulWidget
{
  final int tabSelected;
  AppBottomBar({
    Key key,
    this.tabSelected
  }) : super(key: key);

  @override
  _AppBottomBar createState() => new _AppBottomBar();
}

class _AppBottomBar extends State<AppBottomBar>
{
  Color foodTab;
  Color wishListTab;
  Color cameraTab;
  Color plannerTab;
  Color profileTab;

  @override
  void initState() {
    super.initState();
    paintTab(this.widget.tabSelected);
  }

  paintTab(int index) {
    Color selected = Color.fromRGBO(250, 0, 60, 1);
    switch (index) {
      case 0:
        setState(() {
          unSelectAll();
          foodTab = selected;
        });
        break;
      case 1:
        setState(() {
          unSelectAll();
          wishListTab = selected;
        });
        break;
      case 2:
        setState(() {
          unSelectAll();
          plannerTab = selected;
        });
        break;
      case 3:
        setState(() {
          unSelectAll();
          profileTab = selected;
        });
        break;
      default:
        setState(() {
          unSelectAll();
        });
        break;
    }
  }

  unSelectAll() {
    foodTab     = Color.fromRGBO(193, 191, 202, 1);
    wishListTab = Color.fromRGBO(193, 191, 202, 1);
    plannerTab  = Color.fromRGBO(193, 191, 202, 1);
    profileTab  = Color.fromRGBO(193, 191, 202, 1);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0, // this will be set when a new tab is tapped,
      type: BottomNavigationBarType.fixed,
      onTap: (int index) {
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen()
              ),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Favorites()
              ),
            );
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Planner()
              ),
            );
            break;
          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Profile()
              ),
            );
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: Container(
              child: Image.asset("images/foodicon_01.png", color: foodTab,),
              width: 30,
              margin: EdgeInsets.only(top: 12, bottom: 12)
          ),
          title: new Container(
            height: 0.0,
          ),
        ),
        BottomNavigationBarItem(
          icon: Container(
              child: Image.asset("images/favoritos_01.png", color: wishListTab,),
              width: 20,
              margin: EdgeInsets.only(top: 12, bottom: 12)
          ),
          title: Container(
            height: 0.0,
          ),
        ),
        BottomNavigationBarItem(
          icon: Container(
              child: Image.asset("images/planner_01.png", color: plannerTab),
              width: 20,
              margin: EdgeInsets.only(top: 12, bottom: 12)
          ),
          title: Container(
            height: 0.0,
          ),
        ),
        BottomNavigationBarItem(
          icon: Container(
              child: Image.asset("images/user_01.png", color: profileTab,),
              width: 16,
              margin: EdgeInsets.only(top: 12, bottom: 12)
          ),
          title: Container(
            height: 0.0,
          ),
        ),
      ],
    );
  }

}