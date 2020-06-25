
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodie/views/planner/planner_list.dart';
import 'package:http/http.dart' as Http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foodie/components/favorites/models/favorite.dart';
import 'package:foodie/components/favorites/favorites_manager.dart';

class ModalBottomWishlist extends StatefulWidget {
  final String restaurant;

  ModalBottomWishlist({
    Key key,
    this.restaurant
  }) : super(key: key);
  
  @override
  _ModalBottomWishlist createState() => new _ModalBottomWishlist();
}

class _ModalBottomWishlist extends State<ModalBottomWishlist> {

  String dropdownValue = '2';
  

  final personController = TextEditingController();
  String dateText     = "DD/MM/AA";
  String timeText     = "00:00 pm";
  bool isFavorite     = false;
  Color favoriteColor = Color.fromRGBO(193, 191, 202, 1);

  Map restaurant;

  @override
  void initState() {
    super.initState();
    setState(() {
      restaurant = jsonDecode(widget.restaurant);
      print(restaurant.toString());
    });
  }

  checkIsFavorite() async {
    FavoritesManager manager = new FavoritesManager();
    Favorite favorite = await manager.getByRestaurantId(
      restaurant["id"]
    );
    if (favorite.runtimeType.toString() != "Null") {
      setState(() {
        isFavorite = true;
      });
    }
  }

  @override
  Widget build(context) {
    return Container(
      height: 250.0,
      width: MediaQuery.of(context).size.width * 0.3,
      child: ListView(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            child: Text(
              "Que deseas hacer?",
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
          SizedBox(height: 20.0,),
          GestureDetector(
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              String id = prefs.getString("id_user");

              //FavoritesManager manager = new FavoritesManager();
              //Favorite favorite = await manager.getByUserIdAndRestaurantId(
              //  int.parse(id),
              //  restaurant["id"]
              //);

              var response = await Http.post(
                'http://api.foodie.quality.datia.co/restaurant/addFavorite',
                body: {
                  "id_user": id.toString(),
                  "id_restaurant": restaurant["id"].toString()
                });

              if (isFavorite) {
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Image.asset(
                      "images/boton_favoritos_red.png",
                      height: 40,
                    )
                  ),
                  flex: 4,
                ),
                Spacer(flex: 1,),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Agregar a mi wishlist",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: 'Quicksand Regular',
                          color: Color.fromRGBO(63, 63, 63, 1),
                          fontSize: 18
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  ),
                  flex: 10,
                )
              ],
            )
          ),
          SizedBox(height: 10.0,),
          GestureDetector(
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              String idUser = prefs.getString("id_user");
              var response = await Http.post(
                  'http://api.foodie.quality.datia.co/planner/Planner',
                body: {
                  "id_accion": "1",
                  "id_restaurant": restaurant["id"].toString(),
                  "id_user": idUser
                });
              Fluttertoast.showToast(
                  msg: "Restaurante agregado a lista del planner",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIos: 2,
                  backgroundColor: Color.fromRGBO(64, 0, 15, 1),
                  textColor: Colors.white,
                  fontSize: 16.0
                );
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) =>  PlannerList()
                ));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Image.asset("images/boton_planner_red.png", height: 40,)
                  ),
                  flex: 4,
                ),
                Spacer(flex: 1,),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Agregar a mi planner",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Quicksand Regular',
                          color: Color.fromRGBO(63, 63, 63, 1),
                          fontSize: 18
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  ),
                  flex: 10,
                )
              ],
            ),
          ),
          SizedBox(height: 10.0,),
          GestureDetector(
            onTap: () {
              Share.share('check out my website https://example.com');
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Align(
                    child: Image.asset("images/boton_compartir_red.png", height: 40,),
                    alignment: Alignment.centerRight
                  ),
                  flex: 4,
                ),
                Spacer(flex: 1,),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Compartir en redes",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: 'Quicksand Regular',
                        color: Color.fromRGBO(63, 63, 63, 1),
                        fontSize: 18
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  ),
                  flex: 10,
                )
              ],
            ),
          ),
        ],
      )
    );
  }
}