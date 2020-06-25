import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodie/home_screen.dart';
import 'package:foodie/reservations.dart';
import 'package:foodie/views/app_bar/app_bottom_bar.dart';
import 'package:foodie/views/booking/booking_history.dart';
import 'package:foodie/views/home/drawer_state.dart';

class BookingConfirmation extends StatefulWidget
{
  final String restaurant;
  BookingConfirmation({
    Key key,
    this.restaurant
  }) : super(key: key);

  @override
  _BookingConfirmation createState() => new _BookingConfirmation();
}

class _BookingConfirmation extends State<BookingConfirmation>
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
      body: ListView(
        children: <Widget>[
          Center(
            child: Container(
              child: Image.asset("images/reservado.png"),
              width: 200,
              margin: EdgeInsets.only(top: 30),
            ),
          ),
          Center(
            child: Container(
              child: Text(
                  "¡Tu reserva se realizó con éxito!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Quicksand Bold',
                      color: Color.fromRGBO(63, 67, 77, 1),
                      fontSize: 18
                  )
              ),
              width: 250,
              margin: EdgeInsets.only(top: 10),
            ),
          ),
          Center(
            child: Container(
              child: Text(
                  "Para modificar los datos de la reserva ingresa a menú > Mis reservas",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Quicksand Regular',
                      color: Color.fromRGBO(120, 119, 127, 1),
                      fontSize: 12
                  )
              ),
              margin: EdgeInsets.only(top: 10, bottom: 40, right: 20, left: 20),
            ),
          ),
          Row(
            children: <Widget>[
              new Expanded(
                child: new Center(
                  child: Container(
                      child: MaterialButton(
                          child: 
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Image.asset("images/regresar.png", height: 15),
                                  flex: 1,
                                ),
                                Expanded(
                                  child: Text(
                                    "Ir al inicio",
                                    style: TextStyle(
                                      color: Color.fromRGBO(250, 0, 60, 1),
                                      fontSize: 16
                                    ),
                                  ),
                                  flex: 3
                                )
                              ],
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
                            height: 50,
                            minWidth: double.infinity,
                      ),
                      margin: EdgeInsets.only(left: 20, right: 5),
                  )
                ),
                flex: 1,
              ),
              new Expanded(
                child: new Center(
                  child: Container(
                    child: MaterialButton(
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Row(
                          children: <Widget>[
                            Text(
                              "Ver mis reservas",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16
                              ),
                            )
                          ],
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Reservations()),
                        );
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)
                      ),
                      color: Color.fromRGBO(250, 0, 60, 1),
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
                      restaurant["name_owner"],
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
                      restaurant["document_owner"],
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
                      restaurant["phone_owner"],
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
                      restaurant["email_owner"],
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
          Container(
            child: Divider(
              color: Color.fromRGBO(193, 191, 202, 1),
            ),
            margin: EdgeInsets.only(left: 20, right: 20),
          ),
          SizedBox(height: 30.0,),
          Center(
            child: Container(
              child: MaterialButton(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Image.asset("images/mail_icon.png", height: 20,),
                          flex: 1,
                        ),
                        Expanded(
                          child:  Text(
                            "Enviar por correo",
                            style: TextStyle(
                              color: Color.fromRGBO(250, 0, 60, 1),
                              fontSize: 16
                            ),
                          ),
                          flex: 3,
                        )
                      ],
                    ),
                    onPressed: () {
                        
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(50.0),
                      side: BorderSide(color: Color.fromRGBO(250, 0, 60, 1))
                    ),
                    height: 50,
                    minWidth: double.infinity,
              ),
              width: 250,
              margin: EdgeInsets.only(top: 10),
            ),
          ),
          SizedBox(height: 15.0,),
          Center(
            child: Container(
              child: Text(
                  "Modificaciones, cancelaciones y condiciones de la reserva",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Quicksand Bold',
                      color: Color.fromRGBO(63, 67, 77, 1),
                      fontSize: 16
                  )
              ),
              width: 250,
              margin: EdgeInsets.only(top: 10),
            ),
          ),
          SizedBox(height: 15.0,),
          Center(
            child: Container(
              child: Text(
                  """Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim 
                  am, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip
                  ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros
                  et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi.

                  Lorem ipsum dolor sit amet, cons ectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim 
                  veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip
                  ex ea commodo consequat.
                  """,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontFamily: 'Quicksand Regular',
                      color: Color.fromRGBO(120, 119, 127, 1),
                      fontSize: 12
                  )
              ),
              margin: EdgeInsets.only(top: 30, bottom: 40, right: 30, left: 30),
            ),
          ),
        ],
      ),
      endDrawer: DrawerState(),
      bottomNavigationBar: AppBottomBar(tabSelected: 0,)
    );
  }
}