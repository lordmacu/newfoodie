
import 'package:flutter/material.dart';
import 'package:foodie/home_screen.dart';
import 'package:foodie/pqrs.dart';
import 'package:foodie/views/app_bar/app_bar_title.dart';
import 'package:foodie/views/app_bar/app_bottom_bar.dart';
import 'package:foodie/views/booking/booking_history.dart';
import 'package:foodie/views/home/drawer_state.dart';
import 'package:foodie/views/profile/profile_detail.dart';
import 'package:foodie/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  _Profile createState() => new _Profile();
}

class _Profile extends State<Profile> {

  var circleAvatarProperty;
  var userName;

  @override
  void initState() {
    circleAvatarProperty = Container(
      child: Image.asset(
        "images/man.png",
        height: 116.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(40.0),
        ),
      )
    );
    fetchUserData();
    super.initState();
  }

  fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      String url = prefs.getString("image");
      if (url.runtimeType.toString() == "Null") {
        circleAvatarProperty = Container(
          child: Image.asset(
            "images/man.png",
            height: 116.0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.horizontal(
              left: Radius.circular(40.0),
            ),
          )
        );
      } else {
        circleAvatarProperty = CircleAvatar(
          backgroundImage: NetworkImage(url),
          child: Text(''),
          radius: 58.0,
        );
      }
      userName = prefs.getString("name");
    });
  }

  clearPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setBool(
      'session',
      false
    );
    await prefs.setString(
      'email',
      ""
    );
    await prefs.setString(
      'token',
      ""
    );
    await prefs.setString(
      'image',
      ""
    );
    await prefs.setString(
      'name',
      ""
    );
  }

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
          title: AppBarTitle(content: Profile())
        ),
        body: WillPopScope(
        //Wrap out body with a `WillPopScope` widget that handles when a user is cosing current route
        onWillPop: () async {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen())
            );//return a `Future` with false value so this route cant be popped or closed.
            return;
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 110.0,
                        child: Text(""),
                        color: Color.fromRGBO(242, 242, 242, 1),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 110.0,
                        child: Text(""),
                      )
                    ],
                  ),
                  Positioned(
                    top: 50,
                    bottom: 50,
                    left: 50,
                    right: 50,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Container(
                          child: circleAvatarProperty,
                        )
                      ],
                    ),
                  )
                ],
              ),
              Container(
                child: Text(
                  "MOVIMIENTOS",
                  textAlign: TextAlign.start,style: TextStyle(
                      fontFamily: "Quick Light",
                      color: Color.fromRGBO(193, 191, 202, 1),
                      fontSize: 14
                  )
                ),
                margin: EdgeInsets.only(right: 20.0, left: 30.0),
                width: double.infinity,
              ),
              Container(
                child: FlatButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                        child: Image.asset(
                          "images/back_icon_02.png", 
                          height: 20,
                        ),
                        margin: EdgeInsets.only(right: 20),
                      ),
                      Text(
                        "Historial de reservas",
                        textAlign: TextAlign.start,style: TextStyle(
                          color: Color.fromRGBO(120, 119, 127, 1),
                          fontSize: 12
                        )
                      )
                    ],
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BookingHistory())
                    );
                  },
                ),
                margin: EdgeInsets.only(right: 20.0, left: 30.0),
                width: double.infinity,
              ),
              Container(
                child: Divider(),
                margin: EdgeInsets.only(right: 30.0, left: 30.0),
              ),
              Container(
                child: Text(
                  "CONFIGURACIÓN",
                  textAlign: TextAlign.start,style: TextStyle(
                      fontFamily: "Quick Light",
                      color: Color.fromRGBO(193, 191, 202, 1),
                      fontSize: 14
                  )
                ),
                margin: EdgeInsets.only(right: 20.0, left: 30.0),
                width: double.infinity,
              ),
              Container(
                child: FlatButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                        child: Icon(Icons.people, color: Color.fromRGBO(120, 119, 127, 1)),
                        margin: EdgeInsets.only(right: 20),
                      ),
                      Text(
                        "Perfil",
                        textAlign: TextAlign.start,style: TextStyle(
                          color: Color.fromRGBO(120, 119, 127, 1),
                          fontSize: 12
                        )
                      )
                    ],
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => ProfileDetail()
                    ));
                  },
                ),
                margin: EdgeInsets.only(right: 20.0, left: 30.0),
                width: double.infinity,
              ),
              Container(
                child: Divider(),
                margin: EdgeInsets.only(right: 30.0, left: 30.0),
              ),
              Container(
                child: Text(
                  "SOPORTE",
                  textAlign: TextAlign.start,style: TextStyle(
                      fontFamily: "Quick Light",
                      color: Color.fromRGBO(193, 191, 202, 1),
                      fontSize: 14
                  )
                ),
                margin: EdgeInsets.only(right: 20.0, left: 30.0),
                width: double.infinity,
              ),
              Container(
                child: FlatButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                        child: Icon(Icons.message, color: Color.fromRGBO(120, 119, 127, 1)),
                        margin: EdgeInsets.only(right: 20),
                      ),
                      Text(
                        "PQRS",
                        textAlign: TextAlign.start,style: TextStyle(
                          color: Color.fromRGBO(120, 119, 127, 1),
                          fontSize: 12
                        )
                      )
                    ],
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => Pqrs()
                    ));
                  },
                ),
                margin: EdgeInsets.only(right: 20.0, left: 30.0),
                width: double.infinity,
              ),
              Container(
                child: Divider(),
                margin: EdgeInsets.only(right: 30.0, left: 30.0),
              ),
              Container(
                child: FlatButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                        child: Icon(Icons.exit_to_app, color: Color.fromRGBO(120, 119, 127, 1)),
                        margin: EdgeInsets.only(right: 20),
                      ),
                      Text(
                        "Salir",
                        textAlign: TextAlign.start,style: TextStyle(
                          color: Color.fromRGBO(120, 119, 127, 1),
                          fontSize: 12
                        )
                      )
                    ],
                  ),
                  onPressed: () {
                    clearPreferences();
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WelcomeScreen())
                    );
                  },
                ),
                margin: EdgeInsets.only(right: 20.0, left: 30.0),
                width: double.infinity,
              ),
            ],
          ),
        ),
        endDrawer: DrawerState(),
        bottomNavigationBar: AppBottomBar(tabSelected: 3,)
    );
  }
}