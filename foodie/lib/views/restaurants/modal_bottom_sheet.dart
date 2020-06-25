
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodie/planner.dart';
import 'package:foodie/views/booking/booking.dart';
import 'package:http/http.dart' as Http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodie/components/favorites/models/favorite.dart';
import 'package:foodie/components/favorites/favorites_manager.dart';
import 'package:foodie/components/restaurants/models/restaurant.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ModalBottomSheet extends StatefulWidget {
  final Restaurant restaurant;

  ModalBottomSheet({
    Key key,
    this.restaurant
  }) : super(key: key);
  
  @override
  _ModalBottomSheet createState() => new _ModalBottomSheet();
}

class _ModalBottomSheet extends State<ModalBottomSheet> {

  String dropdownValue = '2';
  String dropdownHorarios = '11:00 am';

  final personController = TextEditingController();
  String dateText     = "AAAA-MM-DD";
  String timeText     = "00:00 pm";
  bool isFavorite     = false;
  Color favoriteColor = Color.fromRGBO(193, 191, 202, 1);

  checkIsFavorite() async {
    FavoritesManager manager = new FavoritesManager();
    Favorite favorite = await manager.getByRestaurantId(
      widget.restaurant.idRestaurant
    );
    if (favorite.runtimeType.toString() != "Null") {
      setState(() {
        isFavorite = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    //checkIsFavorite();
  }

  @override
  Widget build(context) {
    return Container(
      child: new Wrap(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            child: Text(
              "Haz tu reserva",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Quicksand Bold',
                  color: Color.fromRGBO(63, 63, 63, 1),
                  fontSize: 18
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            margin: EdgeInsets.only(left: 20, right: 20, top: 15)
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            margin: EdgeInsets.only(right: 20.0, left: 30.0),
            child: Text("Fecha "),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: new Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  new Expanded(
                    child: new Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: MaterialButton(
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: Text(
                                dateText,
                                style: TextStyle(
                                    color: Color.fromRGBO(193, 191, 202, 1),
                                    fontSize: 16
                                ),
                              ),
                            ),
                            onPressed: () {
                              DatePicker.showDatePicker(
                                context,
                                showTitleActions: true,
                                minTime: DateTime.fromMillisecondsSinceEpoch(
                                  DateTime.now().millisecondsSinceEpoch - 172800
                                ),
                                maxTime: DateTime(2030), 
                                onChanged: (date) {},
                                onConfirm: (date) {
                                  setState(() {
                                    dateText = date.year.toString() + "-" + date.month.toString() + "-" + date.day.toString();
                                  });
                                },
                                locale: LocaleType.es
                              );
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(50.0),
                                side: BorderSide(color: Color.fromRGBO(193, 191, 202, 1))
                            ),
                            height: 50,
                            minWidth: double.infinity,
                          ),
                          margin: EdgeInsets.only(left: 20, right: 5),
                        )
                    ),
                    flex: 1,
                  ),
                ]
            ),
            margin: EdgeInsets.only(left: 5, right: 20, top: 10),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            margin: EdgeInsets.only(right: 20.0, left: 30.0),
            child: Text("Número de personas"),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: EdgeInsets.all(10.0),
              decoration:  BoxDecoration(
                  borderRadius: BorderRadius.all(
                      Radius.circular(40.0)
                  ),
                  border: Border.all(color:  Color.fromRGBO(173, 192, 202, 1)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: dropdownValue,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Color.fromRGBO(173, 192, 202, 1),
                  ),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(
                      color: Color.fromRGBO(173, 192, 202, 1),
                      fontSize: 20
                  ),
                  underline: Container(
                    height: 1,
                    color: Color.fromRGBO(173, 192, 202, 1),
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValue = newValue;
                    });
                  },
                  items: <String>['2','3','4','5','6','7','8','9','10']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                )
              ),
            ),
            margin: EdgeInsets.only(left: 20, right: 20, top: 10.0),
            height: 50.0,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            margin: EdgeInsets.only(right: 20.0, left: 30.0),
            child: Text("Horarios"),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: EdgeInsets.all(10.0),
              decoration:  BoxDecoration(
                borderRadius: BorderRadius.all(
                    Radius.circular(40.0)
                ),
                border: Border.all(color:  Color.fromRGBO(173, 192, 202, 1)),
              ),
              child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: dropdownHorarios,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Color.fromRGBO(173, 192, 202, 1),
                    ),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(
                        color: Color.fromRGBO(173, 192, 202, 1),
                        fontSize: 20
                    ),
                    underline: Container(
                      height: 1,
                      color: Color.fromRGBO(173, 192, 202, 1),
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownHorarios = newValue;
                      });
                    },
                    items: <String>[
                      "11:00 am",
                      "11:15 am",
                      "11:30 am",
                      "11:45 am",
                      "12:00 pm",
                      "12:15 pm",
                      "12:30 pm",
                      "12:45 pm",
                      "13:00 pm",
                      "13:15 pm",
                      "13:30 pm",
                      "13:45 pm",
                      "14:00 pm",
                      "14:15 pm",
                      "14:30 pm",
                      "14:45 pm",
                      "15:00 pm",
                      "15:15 pm",
                      "15:30 pm",
                      "15:45 pm",
                      "16:00 pm",
                      "16:15 pm",
                      "16:30 pm",
                      "16:45 pm",
                      "17:00 pm",
                      "17:15 pm",
                      "17:30 pm",
                      "17:45 pm",
                      "18:00 pm",
                      "18:15 pm",
                      "18:30 pm",
                      "18:45 pm",
                      "19:00 pm",
                      "20:15 pm",
                      "20:30 pm",
                      "20:45 pm",
                      "21:00 pm",
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  )
              ),
            ),
            margin: EdgeInsets.only(left: 20, right: 20, top: 10.0),
            height: 50.0,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: MaterialButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Reservar",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16
                    ),
                  ),
                  Icon(Icons.arrow_forward, color: Colors.white,)
                ],
              ),
              onPressed: () {

                if (dropdownHorarios == "11:00 pm") {
                  Fluttertoast.showToast(
                      msg: "El horario es obligatorio",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIos: 2,
                      backgroundColor: Color.fromRGBO(64, 0, 15, 1),
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                  return;
                }
                
                if (dateText == "DD/MM/AA") {
                  Fluttertoast.showToast(
                      msg: "La fecha es obligatoria",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIos: 2,
                      backgroundColor: Color.fromRGBO(64, 0, 15, 1),
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                  return;
                }

                Map mapRestaurant = widget.restaurant.toMap();
                mapRestaurant["booking_date"] = dateText;
                mapRestaurant["booking_time"] = dropdownHorarios;
                mapRestaurant["person_number"] = dropdownValue;

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Booking(restaurant: jsonEncode(mapRestaurant))),
                );
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)
              ),
              color: Color.fromRGBO(250, 0, 60, 1),
              height: 50,
              minWidth: double.infinity,
            ),
            margin: EdgeInsets.only(left: 20, right: 20, top: 10.0, bottom: 10),
          ),
          Container(
            //width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 10.0, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: FlatButton(
                    child: Container(
                      child: Image.asset(
                        "images/boton_favoritos.png",
                        height: 40,
                      ),
                    ),
                    onPressed: () async {

                      FavoritesManager manager = new FavoritesManager();
                      Favorite favorite = await manager.getByUserIdAndRestaurantId(
                        40,
                        widget.restaurant.idRestaurant
                      );

                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      String id = prefs.getString("id_user");

                      var response = await Http.post(
                        'http://api.foodie.quality.datia.co/restaurant/addFavorite',
                        body: {
                          "id_user": id.toString(),
                          "id_restaurant": widget.restaurant.idRestaurant.toString()
                        });

                      if (isFavorite || favorite.runtimeType.toString() == "Favorite") {
                         Fluttertoast.showToast(
                          msg: "Este restaurante ya está en favoritos",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIos: 2,
                          backgroundColor: Color.fromRGBO(64, 0, 15, 1),
                          textColor: Colors.white,
                          fontSize: 16.0
                        );
                        return;
                      }

                      manager.save({
                        "id_user": 40,
                        "id_restaurant": widget.restaurant.idRestaurant
                      });

                      Fluttertoast.showToast(
                        msg: "Agregado a favoritos",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIos: 2,
                        backgroundColor: Color.fromRGBO(64, 0, 15, 1),
                        textColor: Colors.white,
                        fontSize: 16.0
                      );

                    },
                  ),
                ),
                Container(
                  child: FlatButton(
                    child: Container(
                      child: Image.asset(
                        "images/boton_planner.png",
                        height: 40,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Planner()),
                      );
                    },
                  ),
                  //margin: EdgeInsets.only(left: 20),
                ),
                Container(
                  child: FlatButton(
                    child: Container(
                      child: Image.asset(
                        "images/boton_compartir.png",
                        height: 40,
                      ),
                    ),
                    onPressed: () {
                      Share.share('check out my website https://example.com');
                    },
                  ),
                ),
              ],
            )
          )
        ],
      ),
    );
  }
}