
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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

class Favorites extends StatefulWidget
{
  @override
  _Favorites createState() => new _Favorites();
}

class _Favorites extends State<Favorites>
{
  List favoriteList = []; 
  String dropdownValue = 'Bogotá.dc';
  String baseImgUrl = "http://foodie.develop.datia.co/";
  ScrollController _controller = new ScrollController();

  @override
  void initState() {
    super.initState();
    fetchFavorites();
  }

  fetchFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString("id_user");
    var response = await Http.post(
        'http://api.foodie.quality.datia.co/restaurant/getFavoritesByUser',
        body: {
          "id_user": id.toString()
        });

    Map map = jsonDecode(response.body);
    List list = []; 
    if (map["data"].runtimeType.toString() != "Null") {
      list = map["data"];
    }

    list.forEach((item) async {
      var res = await _getRestaurantById(item);
      item["restaurant"] = res;
    });

    List auxFavorites = [];
    list.forEach((item) {
      var res = _getRestaurantById(item);
      item["restaurant"] = res;
      auxFavorites.add(item);
    });

    setState(() {
      favoriteList = auxFavorites;
    });
  }

  _getRestaurantById(item) async {
    var respRestaurants = await Http.post(
      'http://api.foodie.quality.datia.co/restaurant/filterrestaurantbyid',
    body: {
      "id_restaurant": item["id_restaurant"].toString()
    });

    Map mapRes = jsonDecode(respRestaurants.body);
    return mapRes["data"]; 
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
        title: AppBarTitle(content: Favorites())
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 20.0,),
          Center(
            child: Container(
              child: Text(
                  "MIS FAVORITOS",
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
          Container(
            margin: EdgeInsets.only(right: 20, left: 20, top: 20),
            child: ListView.builder(
              controller: _controller,
              shrinkWrap: true,
              itemCount: favoriteList.length,
              itemBuilder: (context, position) {
                var item = favoriteList[position];

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
                                    child: MaterialButton(
                                      child: Text(
                                        "Ver restaurante",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10
                                        ),
                                      ),
                                      onPressed: () async {
                                        Restaurant restaurant = Restaurant().encapsulate(item["restaurant"]);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => RestaurantDetail(
                                              restaurant: restaurant,
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