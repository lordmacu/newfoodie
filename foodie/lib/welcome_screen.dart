import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodie/components/persistence/entity_manager.dart';
import 'package:foodie/login_screen.dart';
//import 'package:permission/permission.dart';
import 'package:foodie/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreen createState() => _WelcomeScreen();
}

class _WelcomeScreen extends State<WelcomeScreen> {

  var timer;
  int _currentPage   = 0;
  String _background1 = "images/elipse127.png";
  String _background2 = "images/elipse128.png";
  String _background3 = "images/elipse128.png";

  PageController _pageController = PageController(
    initialPage: 0,
  );

  doPersistence() async {
    EntityManager em = new EntityManager();
    await em.createTables();
  }

  _saveSelectedCity(int city, String cityName) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt("selectedCity", city);
    pref.setString("selectedCityName", cityName);
  }

  @override
  void initState() {
    _saveSelectedCity(98, "BARRANQUILLA");
    //print("creançao de tables ->");
    //doPersistence();
    //print("<- creançao de tables");

    this.timer = Timer.periodic(Duration(seconds: 4), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      try {
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      } catch (e) { }
    });
    //requestPermissions();
    super.initState();
  }

  @override
  void deactivate() {
    super.deactivate();
    if (this.timer != null) {
      this.timer.cancel();
    }
  } 

  /*requestPermissions() async {
    await Permission.requestPermissions([
      PermissionName.Internet,
      PermissionName.Location,
      PermissionName.Camera
    ]);
  }*/

  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
      appBar: null,
      body: WillPopScope(
        //Wrap out body with a `WillPopScope` widget that handles when a user is cosing current route
        onWillPop: () async {
          Future.value(false); //return a `Future` with false value so this route cant be popped or closed.
          return;
        },
        child: Container(
          child: Stack(
            children: <Widget>[
              PageView(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('images/6327.png'),
                            fit: BoxFit.cover
                        )
                    ),
                  ),
                  Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('images/6328.png'),
                              fit: BoxFit.cover
                          )
                      )
                  ),
                  Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('images/6329.png'),
                              fit: BoxFit.cover
                          )
                      )
                  ),
                ],
                controller: _pageController,
                onPageChanged: (current) {
                  switch (current) {
                    case 0:
                      setState(() {
                        _background1 = "images/elipse127.png";
                        _background2 = "images/elipse128.png";
                        _background3 = "images/elipse128.png";
                      });
                      break;
                    case 1:
                      setState(() {
                        _background1 = "images/elipse128.png";
                        _background2 = "images/elipse127.png";
                        _background3 = "images/elipse128.png";
                      });
                      break;
                    case 2:
                      setState(() {
                        _background1 = "images/elipse128.png";
                        _background2 = "images/elipse128.png";
                        _background3 = "images/elipse127.png";
                      });
                      break;
                  }
                },
              ),
              new Positioned(
                  bottom: 0.0,
                  child: new Container(
                      color: Color.fromRGBO(255, 255, 255, 0.7),
                      width: MediaQuery.of(context).size.width,
                      height: 250.0,
                      child: new Column(
                        children: <Widget>[
                            new Container(
                              child: Text(
                                "Descubre los mejores restaurantes y platos a tu alrededor.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color.fromRGBO(63, 63, 63, 1),
                                  fontSize: 16,
                                ),
                              ),
                              margin: EdgeInsets.only(
                                top: 40.0,
                                left: 30.0,
                                right: 30.0,
                                bottom: 10.0
                              ),
                            ),
                            Spacer(flex: 1,),
                            new Row(
                              children: <Widget>[
                                new Expanded(
                                  child: new Center(
                                    child: Container(
                                      child: MaterialButton(
                                        child: FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Text(
                                            "Inicia sesión",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16
                                            ),
                                          ),
                                        ),
                                        onPressed: () {

                                          print("aqui estoy iniciando ");
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => LogginScreen()),
                                          );
                                        },
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(50)
                                        ),
                                        color: Color.fromRGBO(250, 0, 60, 1),
                                        height: 50,
                                        minWidth: double.infinity,
                                      ),
                                      margin: EdgeInsets.only(left: 20, right: 5),
                                    )
                                  ),
                                  flex: 1,
                                ),
                                new Expanded(
                                  child: Center(
                                    child: Container(
                                        child: MaterialButton(
                                          child: Text(
                                              "¡Soy nuevo!",
                                              style: TextStyle(
                                                color: Color.fromRGBO(250, 0, 60, 1),
                                                fontSize: 16
                                              ),
                                            ),
                                            onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                                                );
                                            },
                                            shape: RoundedRectangleBorder(
                                              borderRadius: new BorderRadius.circular(50.0),
                                              side: BorderSide(color: Color.fromRGBO(250, 0, 60, 1))
                                            ),
                                            height: 50,
                                            minWidth: double.infinity,
                                      ),
                                      margin: EdgeInsets.only(right: 20, left: 5),
                                    )
                                  ),
                                  flex: 1,
                                )
                              ]
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    child: Image(image: AssetImage(_background1)),
                                    height: 20,
                                  ),
                                  Container(
                                    child: Image(image: AssetImage(_background2)),
                                    height: 20,
                                  ),
                                  Container(
                                    child: Image(image: AssetImage(_background3)),
                                    height: 20,
                                  ),
                                ],
                              ),
                              margin: EdgeInsets.only(
                                  top: 20.0,
                              ),
                            ),
                            Spacer(flex: 1,)
                        ],
                      )
                  )
              )
            ]
          )
        ),
      )
    );
  }
}

