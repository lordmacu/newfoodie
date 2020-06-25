import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodie/home_screen.dart';
import 'package:foodie/views/booking/runway.dart';
import 'package:foodie/views/home/drawer_state.dart';

class Booking extends StatefulWidget
{
  final String restaurant;

  Booking({
    Key key,
    this.restaurant
  }) : super(key: key);

  @override
  _Booking createState() => new _Booking();
}

class _Booking extends State<Booking>
{
  Map restaurant;
  @override
  void initState() {
    super.initState();
    setState(() {
      restaurant = jsonDecode(widget.restaurant);
      print(restaurant.toString());
    });
  }

  String dropdownValue = "'Bogotá.dc'";

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
        title: Text(""),
      ),
      body: Column(
        children: <Widget>[
          Spacer(flex: 1,),
          Expanded(
            child: Center(
              child: Container(
                child: Text(
                    "CONFIRMACIÓN DE DATOS DE RESERVA",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color.fromRGBO(173, 173, 173, 1),
                        fontSize: 18
                    )
                ),
                margin: EdgeInsets.only(left: 40.0, right: 40.0),
              ),
            ),
            flex: 10,
          ),
          Expanded(
            child: Container(
              child: Text(
                  "Confirma tus datos de reserva y continúa.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Quicksand Regular',
                      color: Color.fromRGBO(120, 119, 127, 1),
                      fontSize: 12
                  )
              ),
            ),
          ),
          Spacer(flex: 4,),
          Expanded(
            child: Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                        "Restaurante",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontFamily: 'Quicksand Bold',
                            color: Color.fromRGBO(120, 119, 127, 1),
                            fontSize: 12
                        )
                    ),
                  ),
                  Expanded(
                    child: Text(
                        restaurant["name_restaurant"],
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontFamily: 'Quicksand Regular',
                            color: Color.fromRGBO(120, 119, 127, 1),
                            fontSize: 12
                        )
                    ),
                  )
                ],
              ),
              margin: EdgeInsets.only(left: 20, right: 20),
            ),
            flex: 2,
          ),
          Expanded(
            child: Container(
              child: Divider(
                color: Color.fromRGBO(193, 191, 202, 1),
              ),
              margin: EdgeInsets.only(left: 20, right: 20),
            )
          ),
          Expanded(
            child: Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                        "Lugar",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontFamily: 'Quicksand Bold',
                            color: Color.fromRGBO(120, 119, 127, 1),
                            fontSize: 12
                        )
                    ),
                  ),
                  Expanded(
                    child: Text(
                        restaurant["address"],
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontFamily: 'Quicksand Regular',
                            color: Color.fromRGBO(120, 119, 127, 1),
                            fontSize: 12
                        )
                    ),
                  )
                ],
              ),
              margin: EdgeInsets.only(left: 20, right: 20),
            ),
            flex: 2,
          ),
          Expanded(
            child: Container(
              child: Divider(
                color: Color.fromRGBO(193, 191, 202, 1),
              ),
              margin: EdgeInsets.only(left: 20, right: 20),
            )
          ),
          Expanded(
            child: Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                        "Fecha",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontFamily: 'Quicksand Bold',
                            color: Color.fromRGBO(120, 119, 127, 1),
                            fontSize: 12
                        )
                    ),
                  ),
                  Expanded(
                    child: Text(
                        restaurant["booking_date"],
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontFamily: 'Quicksand Regular',
                            color: Color.fromRGBO(120, 119, 127, 1),
                            fontSize: 12
                        )
                    ),
                  )
                ],
              ),
              margin: EdgeInsets.only(left: 20, right: 20),
            ),
            flex: 2,
          ),
          Expanded(
            child: Container(
              child: Divider(
                color: Color.fromRGBO(193, 191, 202, 1),
              ),
              margin: EdgeInsets.only(left: 20, right: 20),
            )
          ),
          Expanded(
            child: Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                        "Hora",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontFamily: 'Quicksand Bold',
                            color: Color.fromRGBO(120, 119, 127, 1),
                            fontSize: 12
                        )
                    ),
                  ),
                  Expanded(
                    child: Text(
                        restaurant["booking_time"],
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontFamily: 'Quicksand Regular',
                            color: Color.fromRGBO(120, 119, 127, 1),
                            fontSize: 12
                        )
                    ),
                  )
                ],
              ),
              margin: EdgeInsets.only(left: 20.0, right: 20.0),
            ),
            flex: 2,
          ),
          Expanded(
            child: Container(
              child: Divider(
                color: Color.fromRGBO(193, 191, 202, 1),
              ),
              margin: EdgeInsets.only(left: 20, right: 20),
            )
          ),
          Expanded(
            child: Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                        "# de personas",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontFamily: 'Quicksand Bold',
                            color: Color.fromRGBO(120, 119, 127, 1),
                            fontSize: 12
                        )
                    ),
                  ),
                  Expanded(
                    child: Text(
                        restaurant["person_number"],
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontFamily: 'Quicksand Regular',
                            color: Color.fromRGBO(120, 119, 127, 1),
                            fontSize: 12
                        )
                    ),
                  )
                ],
              ),
              margin: EdgeInsets.only(left: 20, right: 20),
            ),
            flex: 2,
          ),
          Expanded(
            child: Container(
              child: Divider(
                color: Color.fromRGBO(193, 191, 202, 1),
              ),
              margin: EdgeInsets.only(left: 20, right: 20),
            )
          ),
          Expanded(
            child: Center(
              child: Container(
                child: Text(
                    "Confirma los datos de tu reserva y continua; si quieres modificarla después podrás hacerlo desde tu panel de reservas.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Quicksand Regular',
                        color: Color.fromRGBO(120, 119, 127, 1),
                        fontSize: 12
                    )
                ),
              ),
            ),
            flex: 4,
          ),
          Spacer(flex: 10,),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 50.0,
            child: new MaterialButton(
              child: Text(
                "Continuar",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Runway(restaurant: widget.restaurant)),
                );
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)
              ),
              color: Color.fromRGBO(250, 0, 60, 1),
              height: 50,
            ),
            //),
            margin: EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              bottom: 10.0
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: MaterialButton(
              child: Text(
                "Volver al detalle",
                style: TextStyle(
                    color: Color.fromRGBO(250, 0, 60, 1),
                    fontSize: 16
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(50.0),
                  side: BorderSide(color: Color.fromRGBO(250, 0, 60, 1))
              ),
            ),
            margin: EdgeInsets.only(
              left: 20.0,
              right: 20.0
            ),
          ),
          SizedBox(height: 40.0,)
        ],
      ),
      endDrawer: DrawerState()
    );
  }
}