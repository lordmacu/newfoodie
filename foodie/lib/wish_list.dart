
import 'package:flutter/material.dart';
import 'package:foodie/views/app_bar/app_bar_title.dart';
import 'package:foodie/views/app_bar/app_bottom_bar.dart';
import 'package:foodie/views/home/drawer_state.dart';

import 'home_screen.dart';

class WishList extends StatefulWidget {
  @override
  _WishList createState() => new _WishList();
}

class _WishList extends State<WishList> {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return new Container(
                  child: FlatButton(
                    child: Image.asset("images/isotipo.png"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen()
                        ),
                      );
                    },
                  ),
                  margin: EdgeInsets.only(top: 12, bottom: 12)
              );
            },
          ),
          title: AppBarTitle(content: WishList())
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      height: 80.0,
                      child: Text(""),
                      color: Colors.amberAccent,
                    ),
                    Container(
                      height: 80.0,
                      child: Text(""),
                      color: Colors.indigo,
                    )
                  ],
                )
              ],
            )
          ],
        ),
        endDrawer: DrawerState(),
        bottomNavigationBar: AppBottomBar(tabSelected: 1,)
    );
  }
}