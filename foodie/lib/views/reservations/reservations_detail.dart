import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodie/home_screen.dart';
import 'package:foodie/views/app_bar/app_bar_title.dart';
import 'package:foodie/views/app_bar/app_bottom_bar.dart';
import 'package:foodie/views/home/drawer_state.dart';

class ReservationsDetail extends StatelessWidget {

  final Map restaurant;
  ReservationsDetail({
    Key key,
    this.restaurant
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
          title: AppBarTitle(content: ReservationsDetail())
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 40.0,),
          Center(
            child: Container(
              child: Text(
                  "DETALLE DE RESERVA",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Quicksand Regular',
                      color: Color.fromRGBO(63, 67, 77, 1),
                      fontSize: 20
                  )
              ),
              width: 250,
              margin: EdgeInsets.only(top: 10),
            ),
          ),
          SizedBox(height: 30.0,),
          Center(
            child: Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Align(
                      child: Icon(Icons.close),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Tu reserva aún no ha sido aprobada por el restaurante",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Quicksand Ligth',
                          color: Color.fromRGBO(63, 67, 77, 1),
                          fontSize: 14
                      )
                    ),
                    flex: 10
                  )
                ],
              ),
              margin: EdgeInsets.only(left: 30.0, right: 30.0),
            ),
          ),
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
                      restaurant["owner_restaurant"] == null ? "" : restaurant["owner_restaurant"].toString(),
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
                      "Documento",
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
                      "", //restaurant["document_owner"],
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
                      "Teléfono",
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
                      restaurant["phone"] == null ? "" : restaurant["phone"].toString(),
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
                      restaurant["email"] == null ? "" : restaurant["email"].toString(),
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
                      restaurant["booking_date"] == null ? "" : restaurant["booking_date"].toString(),
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
                      restaurant["booking_time"] == null ? "" : restaurant["booking_time"].toString(),
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
                      restaurant["person_number"] == null ? "" : restaurant["person_number"].toString(),
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
          )
        ],
      ),
      endDrawer: DrawerState(),
      bottomNavigationBar: AppBottomBar(tabSelected: 1,),
    );
  }
}