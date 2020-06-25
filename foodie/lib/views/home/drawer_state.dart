import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodie/experiences_home.dart';
import 'package:foodie/home_screen.dart';
import 'package:foodie/list_home.dart';
import 'package:foodie/reservations.dart';
import 'package:foodie/views/booking/booking_history.dart';

class DrawerState extends StatefulWidget
{
  @override
  _DrawerState createState() => new _DrawerState();
}

class _DrawerState extends State<DrawerState>
{
  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                child: Text(
                    "Selecciona una opción",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Quicksand Bold',
                        color: Color.fromRGBO(63, 63, 63, 1),
                        fontSize: 18
                    )
                ),
                margin: EdgeInsets.only(top: 20),
              ),
              Container(
                child: Stack(
                  children: <Widget>[
                    Image.asset(
                      "images/img_menu_restaurantes.png",
                      fit: BoxFit.cover,
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Image.asset(
                                "images/foodicon.png",
                                fit: BoxFit.cover,
                              ),
                              width: 30,
                            ),
                            FlatButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => HomeScreen()),
                                  );
                                },
                                child: Text(
                                    "Restaurantes",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20
                                    )
                                )
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                margin: EdgeInsets.only(top: 20, right: 10, left: 10),
              ),
              Container(
                child: Stack(
                  children: <Widget>[
                    Image.asset(
                      "images/img_menu_listas.png",
                      fit: BoxFit.cover,
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Image.asset(
                                "images/listsicon.png",
                                fit: BoxFit.cover,
                              ),
                              width: 30,
                            ),
                            FlatButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ListHome()),
                                  );
                                },
                                child: Text(
                                    "Listas de colombia",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20
                                    )
                                )
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                margin: EdgeInsets.only(top: 5, right: 10, left: 10),
              ),
              Container(
                child: Stack(
                  children: <Widget>[
                    Image.asset(
                      "images/img_menu_experiencias.png",
                      fit: BoxFit.cover,
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Image.asset(
                                "images/certifiedicon.png",
                                fit: BoxFit.cover,
                              ),
                              width: 30,
                            ),
                            FlatButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ExperiencesHome()),
                                  );
                                },
                                child: Text(
                                    "Experiencias",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20
                                    )
                                )
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                margin: EdgeInsets.only(top: 5, right: 10, left: 10),
              ),
              Container(
                child: Stack(
                  children: <Widget>[
                    Image.asset(
                      "images/img_menu_mis_reservas.png",
                      fit: BoxFit.cover,
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Image.asset(
                                "images/planner_01.png",
                                fit: BoxFit.cover,
                              ),
                              width: 30,
                            ),
                            FlatButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Reservations()),
                                  );
                                },
                                child: Text(
                                    "Mis reservas",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20
                                    )
                                )
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                margin: EdgeInsets.only(top: 5, right: 10, left: 10),
              ),
            ],
          )
        ],
      ),
    );
  }
}