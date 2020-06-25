
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodie/views/reservations/reservations_detail.dart';
import 'package:http/http.dart' as Http;
import 'package:foodie/home_screen.dart';
import 'package:foodie/views/home/drawer_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/restaurants/models/restaurant.dart';
import 'package:foodie/views/app_bar/app_bar_title.dart';
import 'package:foodie/views/app_bar/app_bottom_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:foodie/views/restaurants/restaurant_detail.dart';
import 'package:foodie/components/restaurants/restaurants_manager.dart';

class Reservations extends StatefulWidget
{
  @override
  _Reservations createState() => new _Reservations();
}

class _Reservations extends State<Reservations>
{
  bool _visible = false;
  List reservationList = [];
  String dropdownValue = 'Bogotá.dc';
  String baseImgUrl = "http://foodie.develop.datia.co/";
  ScrollController _controller = new ScrollController();

  @override
  void initState() {
    fetchFavorites();
    super.initState();
  }

  fetchFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString("id_user");
    var response = await Http.post(
        'http://api.foodie.quality.datia.co/reservations/listReservations',
        body: {
          "id_user": id.toString()
        });

    Map map = jsonDecode(response.body);
    List list = []; 
    if (map["data"].runtimeType.toString() != "Null") {
      list = map["data"];
    }

    List auxReservations = [];
    list.forEach((item) {
      auxReservations.add(item);
    });

    setState(() {
      reservationList = auxReservations;
      //print("favorite list" + (favoriteList.length == 0).toString());
      if (reservationList.length == 0) {
        _visible = true;
      } else {
        _visible = false;
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
        title: AppBarTitle(content: Reservations())
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 20.0,),
          Center(
            child: Container(
              child: Text(
                  "MIS RESERVAS",
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
          SizedBox(height: 10,),
          Visibility(
            child: Center(
              child: Text("No hay reservas asignadas aun", style: TextStyle(color: Colors.grey),)
            ),
            visible: _visible,
          ),
          Container(
            margin: EdgeInsets.only(right: 20, left: 20, top: 20),
            child: ListView.builder(
              controller: _controller,
              shrinkWrap: true,
              itemCount: reservationList.length,
              itemBuilder: (context, position) {
                var item = reservationList[position];

                return Card(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    )
                  ),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: baseImgUrl + item["image_one"],
                                  //imageUrl: "https://media-cdn.tripadvisor.com/media/photo-f/0e/cc/19/e6/restaurant-chocolat.jpg",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              height: MediaQuery.of(context).size.height * 0.2
                            ),
                            flex: 1,
                          ),
                          Expanded(
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.2,
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      child: Text(
                                          item["name_restaurant"],
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontFamily: 'Quicksand Bold',
                                              color: Color.fromRGBO(63, 67, 77, 1),
                                              fontSize: 14
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                      ),
                                      margin: EdgeInsets.only(top: 5),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                        Image.asset("images/hat.png", height: 15,),
                                        Container(
                                          child: Text(
                                              item["score_foodie"],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: 'Quicksand Regular',
                                                  color: Color.fromRGBO(63, 63, 63, 1),
                                                  fontSize: 12
                                              )
                                          ),
                                          margin: EdgeInsets.only(right: 20, left: 5),
                                        ),
                                        Image.asset("images/cup.png", height: 15,),
                                        Container(
                                          child: Text(
                                              item["score_user"],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: 'Quicksand Regular',
                                                  color: Color.fromRGBO(63, 63, 63, 1),
                                                  fontSize: 12
                                              )
                                          ),
                                          margin: EdgeInsets.only(right: 20, left: 5),
                                        )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          child: Icon(
                                            Icons.place,
                                            color: Color.fromRGBO(173, 192, 202, 1),
                                            size: 15,
                                          ),
                                          margin: EdgeInsets.only(top: 15),
                                        ),
                                        flex: 1,
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: Text(
                                              item["address"],
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontFamily: 'Quicksand Regular',
                                                  color: Color.fromRGBO(63, 63, 63, 1),
                                                  fontSize: 9
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                          ),
                                          margin: EdgeInsets.only(left: 5, top: 20),
                                        ),
                                        flex: 10,
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: 120.0,
                                    child: Center(
                                      child: MaterialButton(
                                        child: Row(
                                          children: <Widget>[
                                            Image.asset("images/eye.png", height: 10.0,),
                                            Text(
                                              "  Ver detalle",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10
                                              ),
                                            ),
                                          ],
                                        ),
                                        onPressed: () async {
                                          RestaurantsManager manager = new RestaurantsManager();
                                          Restaurant restaurant = manager.encapsulate(item);

                                          print("restaurant" + item.toString());

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ReservationsDetail(
                                                restaurant: item,
                                              )
                                            ),
                                          );
                                        },
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(50)
                                        ),
                                        color: Color.fromRGBO(250, 0, 60, 1),
                                        height: 30,
                                      ),
                                    ),
                                    margin: EdgeInsets.only(top: 5),
                                  )
                                ],
                              ),
                            ),
                            flex: 2,
                          )
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
      endDrawer: DrawerState(),
      bottomNavigationBar: AppBottomBar(tabSelected: 1,),
    );
  }
}