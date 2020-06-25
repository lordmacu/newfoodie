
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:foodie/components/restaurants/models/restaurant.dart';
import 'package:foodie/components/restaurants/restaurants_manager.dart';
import 'package:foodie/list_home.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as Http;
import 'package:foodie/views/home/drawer_state.dart';
import 'package:foodie/views/list/list_detail_map.dart';
import 'package:foodie/views/app_bar/app_bar_title.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:foodie/views/restaurants/restaurant_detail.dart';

import '../../home_screen.dart';

class ListDetail extends StatefulWidget
{
  final int idCity;
  final int idList;

  ListDetail({
    Key key,
    this.idCity,
    this.idList
  }) : super(key: key);

  @override
  _ListDetail createState() => new _ListDetail();
}

class _ListDetail extends State<ListDetail> 
{
  String baseImgUrl = "http://foodie.develop.datia.co/";
  ScrollController _listViewController = new ScrollController();

  var visible = true;
  var cityLat = 4.3634;
  var zoom    = 14.474;
  var cityLng = 74.0454;
  double loadingValue = 0.0;
  var listColor = Color.fromRGBO(250, 0, 60, 1);
  var mapColor  = Color.fromRGBO(193, 191, 202, 1);
  var restaurants = [];
  Set<Marker> _markers = Set();

  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(4.710075, -74.070634),
    zoom: 12.0,
  );
  Completer<GoogleMapController> _controller = Completer();
  //Location _locationService  = new Location();

  @override
  void initState() {
    super.initState();
    fetchMainContent();
  }
  
  fetchMainContent() async {
    if (restaurants.length == 0) {
      List auxRestaurants = [];
      setState(() {
        loadingValue = 0.30;
      });
      Set<Marker> auxMarkers = Set();
      var response = await Http.post(
        'http://api.foodie.quality.datia.co/list/listById',
        body: {
          "id_list": widget.idList.toString()
        });
      Map map = jsonDecode(response.body);
      auxRestaurants = map["data"];
      auxRestaurants.forEach((item) => auxMarkers.add(Marker(
        markerId: MarkerId(item["name_restaurant"]),
        position: LatLng(double.parse(item["latitude"]), double.parse(item["longitude"])),
        infoWindow: InfoWindow(title: item["name_restaurant"], snippet: item["description"])
      )));

      Future.delayed(const Duration(seconds: 1), () => setState(() {
         loadingValue = 0.65;
      }));
      Future.delayed(const Duration(seconds: 2), () => setState(() {
         loadingValue = 1.0;
         visible = false;
      }));

      setState(() {
        _markers = auxMarkers;
        restaurants = auxRestaurants;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
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
          title: AppBarTitle(content: ListDetail())
        ),
        body: ListView(
          children: <Widget>[
            Visibility(
              child: LinearProgressIndicator( value:  loadingValue,),
              visible: visible,
            ),
            Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Text(
                          "Resultados:",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: Color.fromRGBO(63, 67, 77, 1),
                              fontSize: 12,
                              fontFamily: 'Quicksand Bold',
                          ),
                          maxLines: 2,
                        ),
                      ),
                      flex: 6,
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          "10",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color.fromRGBO(63, 67, 77, 1),
                              fontSize: 12,
                              fontFamily: 'Quicksand Regular',
                          ),
                          maxLines: 2,
                        ),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          "restaurantes",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color.fromRGBO(63, 67, 77, 1),
                              fontSize: 12,
                              fontFamily: 'Quicksand Bold',
                          ),
                          maxLines: 2,
                        ),
                      ),
                      flex: 6,
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  child: Divider(),
                  margin: EdgeInsets.only(right: 20, left: 20),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Text(
                          "ORDENAR POR:",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: Color.fromRGBO(63, 67, 77, 1),
                              fontSize: 12,
                              fontFamily: 'Quicksand Bold',
                          ),
                          maxLines: 2,
                        ),
                      ),
                      flex: 3,
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          "10",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color.fromRGBO(63, 67, 77, 1),
                              fontSize: 12,
                              fontFamily: 'Quicksand Regular',
                          ),
                          maxLines: 2,
                        ),
                      ),
                      flex: 5,
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          "restaurantes",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color.fromRGBO(63, 67, 77, 1),
                              fontSize: 12,
                              fontFamily: 'Quicksand Bold',
                          ),
                          maxLines: 2,
                        ),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          "restaurantes",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color.fromRGBO(63, 67, 77, 1),
                              fontSize: 12,
                              fontFamily: 'Quicksand Bold',
                          ),
                          maxLines: 2,
                        ),
                      ),
                      flex: 3,
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: MaterialButton(
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.menu, color: listColor, size: 15.0,),
                                SizedBox(width: 5.0,),
                                Text(
                                  "Listado",
                                  style: TextStyle(
                                    color: listColor,
                                    fontSize: 12
                                  ),
                                )
                              ],
                            ),
                            width: 70.0,
                            margin: EdgeInsets.only(right: 5, left: 5),
                          ),
                          onPressed: () { },
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(50.0),
                            side: BorderSide(color: listColor)
                          ),
                          height: 40,
                        ),
                      ),
                    ),
                    SizedBox(width: 5.0,),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: MaterialButton(
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.place, color: mapColor, size: 15.0,),
                                SizedBox(width: 5.0,),
                                Text(
                                  "Mapa",
                                  style: TextStyle(
                                    color: mapColor,
                                    fontSize: 12
                                  ),
                                )
                              ],
                            ),
                            width: 70.0,
                            margin: EdgeInsets.only(right: 5, left: 5),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ListDetailMap(idCity: widget.idCity, idList: widget.idList,)
                              ),
                            );
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(50.0),
                            side: BorderSide(color: mapColor)
                          ),
                          height: 40,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0,),
              ],
            ),
            Container(
              margin: EdgeInsets.only(right: 20.0, left: 20.0),
              child: ListView.builder(
                shrinkWrap: true,
                controller: _listViewController,
                itemCount: restaurants.length,
                itemBuilder: (context, position) {
                  var item = restaurants[position];
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
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            child: Icon(
                                              Icons.watch_later,
                                              color: Color.fromRGBO(173, 192, 202, 1),
                                              size: 12,
                                            ),
                                            margin: EdgeInsets.only(top: 5),
                                          ),
                                          flex: 1,
                                        ),
                                        Expanded(
                                          child: Container(
                                            child: Text(
                                                "aaaa ddd 12pm a 11:30pm",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    fontFamily: 'Quicksand Regular',
                                                    color: Color.fromRGBO(63, 63, 63, 1),
                                                    fontSize: 9
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                            ),
                                            margin: EdgeInsets.only(left: 5, top: 5),
                                          ),
                                          flex: 10,
                                        )
                                      ],
                                    ),
                                    Container(
                                      child: MaterialButton(
                                        child: Text(
                                          "Reservar",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10
                                          ),
                                        ),
                                        onPressed: () async {
                                          RestaurantsManager manager = new RestaurantsManager();
                                          Restaurant restaurant = manager.encapsulate(item);

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => RestaurantDetail(restaurant: restaurant,)
                                            ),
                                          );
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(50)
                                        ),
                                        color: Color.fromRGBO(250, 0, 60, 1),
                                        height: 30,
                                      ),
                                      margin: EdgeInsets.only(top: 0),
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
            ),
          ],
        ),
        endDrawer: DrawerState(),
      ),
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ListHome()
          ),
        );
        return;
      },
    );
  }
}