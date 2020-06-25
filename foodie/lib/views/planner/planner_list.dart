import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodie/bloc/planner_bloc.dart';
import 'package:foodie/views/planner/modal_bottom_planner.dart';
import 'package:http/http.dart' as Http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodie/views/helpers/horizontal_calendar.dart';
import 'package:foodie/views/planner/planner_map.dart';
import 'package:foodie/views/app_bar/app_bar_title.dart';
import 'package:foodie/views/app_bar/app_bottom_bar.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlannerList extends StatefulWidget
{
  @override
  _PlannerList createState() => _PlannerList();
}

class _PlannerList extends State<PlannerList>
{
  List _whichList = [];
  List restaurants = [];
  List recommended = [];
  Widget _restaurantList;
  bool _restaurantStatus = true;
  var horizontalCalendar;
  var fromDateObj = DateTime.now();
  var toDateObj = DateTime.now();
  String fromDate = "d/m/a";
  String toDate = "d/m/a";
  int diff = 4;
  bool accepted = false;
  Map dataKeys = {};
  Map gridList = {};
  int smallList = 1;
  int cityId;
  String cityName = "";
  PlannerBloc plannerBloc = PlannerBloc();

  @override
  void initState() {
    super.initState();
    buildGrid(
      DateTime(fromDateObj.year, fromDateObj.month, fromDateObj.day),
      DateTime(fromDateObj.year, fromDateObj.month, fromDateObj.day + 5)
    );
    _fetchRestaurants();
    _fetchRecomendedRestaurants();
    _getCity();
  }

  void _getCity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      cityId = prefs.getInt("selectedCity");
      cityName = prefs.getString("selectedCityName");
    });
  }

  void _fetchRecomendedRestaurants() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String idUser = prefs.getString("id_user");
    var response = await Http.post(
        'http://api.foodie.quality.datia.co/planner/plannerMisRestaurantes',
      body: {
        "id_accion": "0",
        "id_user": idUser
      });

    Map mapRes = jsonDecode(response.body);

    setState(() {
      recommended = mapRes["data"];
    });

    print("aqu esta recomendados  ${response.body}");
  }

  _fetchRestaurants() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String idUser = prefs.getString("id_user");
    var response = await Http.post(
        'http://api.foodie.quality.datia.co/planner/Planner',
      body: {
        "id_accion": "0",
        "id_user": idUser
      });

    List aux = [];
    _restaurantList = Center(child: CircularProgressIndicator());
    Map map = jsonDecode(response.body);
    for (int i = 0; i < map["data"].length; i++) {
      var respRestaurants = await Http.post(
        'http://api.foodie.quality.datia.co/restaurant/filterrestaurantbyid',
      body: {
        "id_restaurant": map["data"][i]["id_restaurant"].toString()
      });

      Map mapRes = jsonDecode(respRestaurants.body);
      aux.add(mapRes["data"]);
    }
    print("aqu esta normales  ${aux}");

    setState(() {
      restaurants = aux;
      _whichList = restaurants;
      _restaurantList = _getRestaurantList();
    });
  }

  Widget _getRestaurantList() {
    return ListView.builder(
      itemCount: restaurants.length,
      itemBuilder: (context, position) {
        Map item = restaurants[position];
        return cellContent(item);
      },
    );
  }

  Widget _getRecomendedList() {
    return ListView.builder(
      itemCount: recommended.length,
      itemBuilder: (context, position) {
        Map item = recommended[position];
        return cellContent(item);
      },
    );
  }

  void _restaurantClickEvent(wut) {
    if (wut == "recomended") {
      setState(() {
        _restaurantStatus = false;
        _whichList = recommended;
        _restaurantList = _getRecomendedList();
      });
    } else {
      setState(() {
        _restaurantStatus = true;
        _whichList = restaurants;
        _restaurantList = _getRestaurantList();
      });
    }
  }

  Widget _getRestaurantSmallList(fnDialog) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        itemCount: _whichList.length,
        itemBuilder: (context, position) {
          Map item = _whichList[position];
          return Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    item["name_restaurant"],
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: 'Quicksand Bold',
                        color: Color.fromRGBO(120, 119, 127, 1),
                        fontSize: 12
                    )
                  ),
                  flex: 3
                ),
                Expanded(
                  child: IconButton(
                    onPressed: () {
                      fnDialog(item);
                    },
                    icon: Icon(Icons.add),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  contentDropped(item, date, hour, number) {
    return Stack(
      children: <Widget>[
        Container(
          width: 120,
          height: 55,
          child: Center(
            child: Text(
              "sss",
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'Quicksand Regular',
                color: Color.fromRGBO(63, 63, 63, 1),
                fontSize: 10
              )
            )
          ),
          decoration: BoxDecoration(
            border: Border.all(color: Color.fromRGBO(193, 191, 202, 1))
          ),
        ),
        Positioned(
          bottom: 3,
          top: 3,
          left: 3,
          right: 3,
           child: Container(
              width: 110,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(6.0)),
                border: Border.all(
                    width: 1, //
                    color: Color.fromRGBO(193, 191, 202, 1)
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5.0,
                  )
                ]
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      item["name_restaurant"],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Quicksand Bold',
                          color: Color.fromRGBO(63, 63, 63, 1),
                          fontSize: 9
                      )
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Text(
                      "Sin validar",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Quicksand Light',
                          color: Color.fromRGBO(63, 63, 63, 1),
                          fontSize: 8
                      )
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Container(
                      width: 120,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(248, 248, 248, 1),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(5)
                        ),
                        border: Border.all(
                            width: 1, //
                            color: Color.fromRGBO(248, 248, 248, 1)
                        )
                      ),
                      child: Text(
                        "${hour.toString()} ${number.toString()} personas",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Quicksand Regular',
                            color: Color.fromRGBO(63, 63, 63, 1),
                            fontSize: 9
                        )
                      ),
                    ),
                    flex: 1,
                  )
                ],
              ),
            )
        )
      ],
    );
  }

  buildGrid(DateTime start, DateTime to) {
    var difference = to.difference(start).inDays;
    setState(() {
      fromDate = "${start.day}/${start.month}/${start.year}";
      toDate = "${to.day}/${to.month}/${to.year}";
      diff = difference;
      horizontalCalendar = HorizontalCalendar(
        height: 80,
        monthTextStyle: TextStyle(
          fontSize: 10
        ),
        dateTextStyle: TextStyle(
          fontSize: 14
        ),
        weekDayTextStyle: TextStyle(
          fontSize: 10
        ),
        key: UniqueKey(),
        firstDate: start,
        lastDate: to,
        spacingBetweenDates: 0.0,
        breakFastOnPressed: (parent, date, index, content) {
          showDialog(
              context: context,
              builder: (BuildContext ctx) {
                return AlertDialog(
                  title: Text("(Desayuno) Escoge un restaurante"),
                  content: _getRestaurantSmallList((restaurant) {
                    //parent.setState(() {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext ctx2) {
                          return ModalBottomPlanner(
                            onPressed: (date, hour, number) {
                              parent.setState(() {
                                content[index] = contentDropped(
                                  restaurant,
                                  date,
                                  hour,
                                  number
                                );
                              });
                              Navigator.of(ctx).pop();
                              Navigator.of(ctx2).pop();
                            },
                          );
                        }
                      );
                      //
                    //});
                  }),
                );
              }
          );
        },
        launchOnPressed: (parent, date, index, content) {
          showDialog(
              context: context,
              builder: (BuildContext ctx) {
                return AlertDialog(
                  title: Text("(Almuerzo) Escoge un restaurante"),
                  content: _getRestaurantSmallList((restaurant) {
                    //parent.setState(() {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext ctx2) {
                          return ModalBottomPlanner(
                            onPressed: (date, hour, number) {
                              parent.setState(() {
                                content[index] = contentDropped(
                                  restaurant,
                                  date,
                                  hour,
                                  number
                                );
                              });
                              Navigator.of(ctx).pop();
                              Navigator.of(ctx2).pop();
                            },
                          );
                        }
                      );
                      //
                    //});
                  }),
                );
              }
          );
        },
        dinnerOnPressed: (parent, date, index, content) {
          showDialog(
              context: context,
              builder: (BuildContext ctx) {
                return AlertDialog(
                  title: Text("(Cena) Escoge un restaurante"),
                  content: _getRestaurantSmallList((restaurant) {
                    //parent.setState(() {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext ctx2) {
                          return ModalBottomPlanner(
                            onPressed: (date, hour, number) {
                              parent.setState(() {
                                content[index] = contentDropped(
                                  restaurant,
                                  date,
                                  hour,
                                  number
                                );
                              });
                              
                              Navigator.of(ctx).pop();
                              Navigator.of(ctx2).pop();
                            },
                          );
                        }
                      );
                      //
                    //});
                  }),
                );
              }
          );
        }
      );
    });
  }

  cellContent(item) {
    return Container(
      margin: EdgeInsets.only(left: 30.0, right: 20.0),
      height: 70.0,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    item["name_restaurant"],
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: 'Quicksand Bold',
                        color: Color.fromRGBO(120, 119, 127, 1),
                        fontSize: 12
                    )
                  ),
                  flex: 4,
                ),
                Expanded(
                  child: Container(
                    child: Icon(
                      Icons.place,
                      color: Color.fromRGBO(173, 192, 202, 1),
                      size: 15,
                    ),
                    margin: EdgeInsets.only(left: 15, right: 15),
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Text(
                    item["address"],
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontFamily: 'Quicksand Regular',
                        color: Color.fromRGBO(120, 119, 127, 1),
                        fontSize: 12
                    )
                  ),
                  flex: 3,
                )
              ],
            ),
          ),
          Spacer(flex: 1,),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Image.asset("images/hat.png", height: 15,),
                  flex: 1,
                ),
                Expanded(
                  child: Container(
                    child: Text(
                        item["score_foodie"],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Quicksand Regular',
                            color: Color.fromRGBO(63, 63, 63, 1),
                            fontSize: 10
                        )
                    ),
                    margin: EdgeInsets.only(right: 20, left: 5),
                  ),
                  flex: 3,
                ),
                Expanded(
                  child: Image.asset("images/cup.png", height: 15,),
                  flex: 1,
                ),
                Expanded(
                  child: Container(
                    child: Text(
                        item["score_user"],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Quicksand Regular',
                            color: Color.fromRGBO(63, 63, 63, 1),
                            fontSize: 10
                        )
                    ),
                    margin: EdgeInsets.only(right: 20, left: 5),
                  ),
                  flex: 3,
                ),
                Expanded(
                  child: Text(""),
                  flex: 3,
                ),
                Expanded(
                  child: Container(
                    child: Icon(
                      Icons.watch_later,
                      color: Color.fromRGBO(173, 192, 202, 1),
                      size: 15,
                    ),
                    margin: EdgeInsets.only(left: 15, right: 15),
                  ),
                  flex: 3,
                ),
                Expanded(
                  child: Text(
                    "asdfasdf 12pm a 11:30pm",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: 'Quicksand Regular',
                        color: Color.fromRGBO(120, 119, 127, 1),
                        fontSize: 12
                    )
                  ),
                  flex: 8,
                )
              ],
            ),
          ),
          Divider()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    double _getWidth(context) {
      return MediaQuery.of(context).size.width;
    }

    double _getHeight(context) {
      return MediaQuery.of(context).size.height;
    }

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return new Container(
                child: Image.asset("images/isotipo.png"),
                margin: EdgeInsets.only(top: 12, bottom: 12)
            );
          },
        ),
        title: AppBarTitle(content: PlannerList(),),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => PlannerList()
                            ));
                          },
                          child: Image.asset("images/icon_list_01.png"),
                        )
                      ),
                    ),
                    flex: 3,
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: 5),
                      child: Text(
                        "Ciudad de destino: ",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontFamily: 'Quicksand Regular',
                            color: Color.fromRGBO(63, 63, 63, 1),
                            fontSize: 12
                        )
                      ),
                    ),
                    flex: 7,
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        cityName,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontFamily: 'Quicksand Bold',
                            color: Color.fromRGBO(63, 63, 63, 1),
                            fontSize: 12
                        )
                      ),
                    ),
                    flex: 6,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => PlannerMap()
                        ));
                      },
                      child: Image.asset("images/icon_pos_02.png", height: 60.0,),
                    ),
                    flex: 3,
                  ),
                ],
              ),
            ),
            flex: 2
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 40.0, right: 40.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "Desde:",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Quicksand Regular',
                          color: Color.fromRGBO(63, 63, 63, 1),
                          fontSize: 12
                      )
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        DatePicker.showDatePicker(
                          context,
                          showTitleActions: true,
                          minTime: DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch),
                          maxTime: DateTime(2030), 
                          onChanged: (date) {},
                          onConfirm: (date) {
                            setState(() {
                              fromDateObj = date;
                              fromDate = "${date.day}/${date.month}/${date.year}";
                            });
                          },
                          locale: LocaleType.es
                        );
                      },
                      child: Text(
                        fromDate,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontFamily: 'Quicksand Bold',
                            color: Color.fromRGBO(63, 63, 63, 1),
                            fontSize: 14
                        )
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Hasta:",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Quicksand Regular',
                          color: Color.fromRGBO(63, 63, 63, 1),
                          fontSize: 12
                      )
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        DatePicker.showDatePicker(
                          context,
                          showTitleActions: true,
                          minTime: DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch),
                          maxTime: DateTime(2030), 
                          onChanged: (date) {},
                          onConfirm: (date) {
                            if (fromDateObj.millisecondsSinceEpoch > date.millisecondsSinceEpoch) {
                              Fluttertoast.showToast(
                                msg: "'Hasta' debe ser mayor a 'Desde'",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIos: 2,
                                backgroundColor: Color.fromRGBO(64, 0, 15, 1),
                                textColor: Colors.white,
                                fontSize: 16.0
                              );
                              return;
                            }
                            setState(() {
                              toDate = "${date.day}/${date.month}/${date.year}";
                              toDateObj = date;
                              buildGrid(fromDateObj, toDateObj);
                            });
                          },
                          locale: LocaleType.es
                        );
                      },
                      child: Text(
                        toDate,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontFamily: 'Quicksand Bold',
                            color: Color.fromRGBO(63, 63, 63, 1),
                            fontSize: 14
                        )
                      ),
                    ),
                  )
                ],
              ),
            ),
            flex: 1,
          ),
          Container(
            margin: EdgeInsets.only(left: 40.0, right: 40.0),
            child: Divider(),
          ),
          Container(
            margin: EdgeInsets.only(left: 20.0),
            child: horizontalCalendar,
            height: 250,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 30.0, right: 20.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "Mi lista de restaurantes",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: 'Quicksand Bold',
                          color: Color.fromRGBO(63, 63, 63, 1),
                          fontSize: 11
                      )
                    ),
                    flex: 5,
                  ),
                  Visibility(
                    visible: false,
                    child: Stack(
                      children: <Widget>[
                        Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _restaurantClickEvent("agregados");
                      },
                      child: Text(
                        "Agregados",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: 'Quicksand Bold',
                          color: _restaurantStatus ? Color.fromRGBO(250, 0, 60, 1) : Color.fromRGBO(63, 63, 63, 1),
                          fontSize: 10
                        ),
                      ),
                    ),
                    flex: 2,
                  ),
                  SizedBox(width: 10.0,),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _restaurantClickEvent("recomended");
                      },
                      child: Text(
                        "Recomendados",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: !_restaurantStatus ? Color.fromRGBO(250, 0, 60, 1) : Color.fromRGBO(63, 63, 63, 1),
                            fontFamily: 'Quicksand Bold',
                            fontSize: 10
                        )
                      ),
                    ),
                    flex: 3,
                  )
                      ],
                    ),
                  )
                ],
              ),
            )
          ),
          Divider(),
          Expanded(
            child: Container(
              child: _restaurantList
            ),
            flex: 5,
          )
        ],
      ),
      bottomNavigationBar: AppBottomBar(tabSelected: 2,)
    );
  }
}