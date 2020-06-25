import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as Http;
import 'package:foodie/home_screen.dart';
import 'package:foodie/views/booking/booking_detail.dart';
import 'package:foodie/views/home/drawer_state.dart';
import 'package:foodie/views/app_bar/app_bar_title.dart';
import 'package:foodie/views/app_bar/app_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingHistory extends StatefulWidget
{
  @override
  _BookingHistory createState() => new _BookingHistory();
}

class _BookingHistory extends State<BookingHistory>
{

  List bookings = [];

  @override
  void initState() {
    fetchBookings();
    super.initState();
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
      if (listBookings["data"].runtimeType.toString() != "Null") {
        bookings = listBookings["data"];
      }
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
        title: AppBarTitle(content: BookingHistory())
      ),
      body: Container(
        color: Color.fromRGBO(245, 245, 247, 1),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 20.0,),
            Center(
              child: Container(
                color: Color.fromRGBO(245, 245, 247, 1),
                child: Center(
                  child: Text(
                      "HISTORIAL RESERVAS",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Quicksand Bold',
                          color: Color.fromRGBO(63, 67, 77, 1),
                          fontSize: 16
                      )
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                height: 70,
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 30, left: 30),
              color: Color.fromRGBO(245, 245, 247, 1),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Text(
                        "Tipo reserva",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontFamily: "Quick Light",
                            color: Color.fromRGBO(193, 191, 202, 1),
                            fontSize: 11
                        )
                      ),
                    ),
                    flex: 3,
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        "Lugar",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "Quick Light",
                            color: Color.fromRGBO(193, 191, 202, 1),
                            fontSize: 11
                        )
                      ),
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    child: Container(
                      height: 20,
                      child: Text(
                        "# de personas",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "Quick Light",
                            color: Color.fromRGBO(193, 191, 202, 1),
                            fontSize: 11
                        )
                      ),
                    ),
                    flex: 3,
                  ),
                  Spacer(flex: 2,)
                ],
              ),
            ),
            Container(
              child: Divider(
                color: Color.fromRGBO(193, 191, 202, 1),
              ),
              margin: EdgeInsets.only(bottom: 10),
            ),
            Container(
              child: ListView.builder(
                controller: _controller,
                shrinkWrap: true,
                itemCount: bookings.length,
                itemBuilder: (context, position) {
                  var item = bookings[position];
                  Color backgroundColor = Color.fromRGBO(245, 245, 247, 1);
                  if (position % 2 == 0) {
                    backgroundColor = Colors.white;
                  }
                  return Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 25.0,
                              color: backgroundColor,
                              child: Container(
                                margin: EdgeInsets.only(right: 30, left: 30),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        child: Text(
                                          "Restaurante",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontFamily: 'Quicksand Bold',
                                              color: Color.fromRGBO(63, 67, 77, 1),
                                              fontSize: 11
                                          )
                                        ),
                                      ),
                                      flex: 4,
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Text(
                                          item["name_restaurant"],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: "Quicksand Regular",
                                              color: Color.fromRGBO(193, 191, 202, 1),
                                              fontSize: 11
                                          )
                                        ),
                                      ),
                                      flex: 3,
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Text(
                                          item["number_people"].toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: "Quicksand Bold",
                                              color: Color.fromRGBO(193, 191, 202, 1),
                                              fontSize: 11
                                          )
                                        ),
                                      ),
                                      flex: 3,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              color: backgroundColor,
                              child: Container(
                                child: Divider(
                                  color: Color.fromRGBO(193, 191, 202, 1),
                                ),
                              ),
                            ),
                            Container(
                              color: backgroundColor,
                              height: 25.0,
                              child: Container(
                                margin: EdgeInsets.only(right: 30, left: 30),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        child: Text(
                                          item["address"],
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontFamily: "Quicksand Regular",
                                              color: Color.fromRGBO(193, 191, 202, 1),
                                              fontSize: 11
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      flex: 5,
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Text(
                                          item["date"],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: "Quicksand Regular",
                                              color: Color.fromRGBO(193, 191, 202, 1),
                                              fontSize: 11
                                          ),
                                           overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      flex: 5,
                                    ),
                                  ],
                                ),
                              )
                            ),
                          ],
                        ),
                        flex: 8,
                      ),
                      Expanded(
                        child: Container(
                          color: backgroundColor,
                          height: 66,
                          child: Center(
                            child: FlatButton(
                              child: Container(
                                child: Image.asset(
                                  "images/detalle_02.png",
                                  height: 20,
                                ),
                              ),
                              onPressed: () {
                                String booking = jsonEncode(item);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => BookingDetail(booking: booking,))
                                );
                              },
                            ),
                          ),
                        ),
                        flex: 2,
                      )
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
      endDrawer: DrawerState(),
      bottomNavigationBar: AppBottomBar(tabSelected: 4,),
    );
  }
}