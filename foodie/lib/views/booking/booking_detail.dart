
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as Http;
import 'package:foodie/home_screen.dart';
import 'package:foodie/views/home/drawer_state.dart';
import 'package:foodie/views/app_bar/app_bar_title.dart';
import 'package:foodie/views/app_bar/app_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingDetail extends StatefulWidget
{
  final String booking;

  BookingDetail({
    Key key,
    this.booking
  }) : super(key: key);

  @override
  _BookingDetail createState() => new _BookingDetail();
}

class _BookingDetail extends State<BookingDetail>
{
  Map booking = {};

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  String dropdownValue = 'Bogotá.dc';
  ScrollController _controller = new ScrollController();

  fetchBookings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString("id_user");
    
    var response = await Http.post(
        'http://api.foodie.quality.datia.co/reservations/listReservations',
      body: {
        "id_user": id.toString(),
      });
    
    Map listBookings = jsonDecode(response.body);
    
    setState(() {
      booking = jsonDecode(widget.booking);
    });
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
        title: AppBarTitle(content: BookingDetail())
      ),
      body: Container(
        color: Color.fromRGBO(245, 245, 247, 1),
        child:  ListView(
          children: <Widget>[
            SizedBox(height: 30.0,),
            Center(
              child: Container(
                child: Text(
                    "DATOS TITULAR",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Quicksand Regular',
                        color: Color.fromRGBO(63, 67, 77, 1),
                        fontSize: 16
                    )
                ),
                width: 250,
                margin: EdgeInsets.only(top: 10),
              ),
            ),
            SizedBox(height: 15.0,),
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                        "Reserva a nombre de:",
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
                        "Juan Ignacio Duarte Peña",
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
            Container(
              child: Divider(
                color: Color.fromRGBO(193, 191, 202, 1),
              ),
              margin: EdgeInsets.only(left: 20, right: 20),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                        "Telefono",
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
                        "Calle 00 #00 - 00 Bogotá.dc",
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
            Container(
              child: Divider(
                color: Color.fromRGBO(193, 191, 202, 1),
              ),
              margin: EdgeInsets.only(left: 20, right: 20),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "Celular",
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
                        "10/06/19",
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
            Container(
              child: Divider(
                color: Color.fromRGBO(193, 191, 202, 1),
              ),
              margin: EdgeInsets.only(left: 20, right: 20),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                        "Correo electronico",
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
                        "foodie@foodie.com",
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
            SizedBox(height: 30.0,),
            Center(
              child: Container(
                child: Text(
                    "DATOS RESERVA",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Quicksand Regular',
                        color: Color.fromRGBO(63, 67, 77, 1),
                        fontSize: 16
                    )
                ),
                width: 250,
                margin: EdgeInsets.only(top: 10),
              ),
            ),
            SizedBox(height: 15.0,),
            Container(
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
                        booking["name_restaurant"],
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
            Container(
              child: Divider(
                color: Color.fromRGBO(193, 191, 202, 1),
              ),
              margin: EdgeInsets.only(left: 20, right: 20),
            ),
            Container(
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
                        booking["address"],
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
            Container(
              child: Divider(
                color: Color.fromRGBO(193, 191, 202, 1),
              ),
              margin: EdgeInsets.only(left: 20, right: 20),
            ),
            Container(
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
                        booking["date"],
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
            Container(
              child: Divider(
                color: Color.fromRGBO(193, 191, 202, 1),
              ),
              margin: EdgeInsets.only(left: 20, right: 20),
            ),
            Container(
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
                        booking["hour"].toString(),
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
            Container(
              child: Divider(
                color: Color.fromRGBO(193, 191, 202, 1),
              ),
              margin: EdgeInsets.only(left: 20, right: 20),
            ),
            Container(
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
                        booking["number_people"].toString(),
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
            Container(
              child: Divider(
                color: Color.fromRGBO(193, 191, 202, 1),
              ),
              margin: EdgeInsets.only(left: 20, right: 20),
            ),
            SizedBox(height: 30.0,),
          ],
        ),
      ),
      endDrawer: DrawerState(),
      bottomNavigationBar: AppBottomBar(tabSelected: 4,),
    );
  }
}