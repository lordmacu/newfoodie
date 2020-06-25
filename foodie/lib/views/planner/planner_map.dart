import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as Http;
import 'package:flutter/cupertino.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodie/views/app_bar/app_bar_title.dart';
import 'package:foodie/views/app_bar/app_bottom_bar.dart';
import 'package:foodie/views/planner/planner_list.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlannerMap extends StatefulWidget
{
  @override
  _PlannerMap createState() => _PlannerMap();
}

class _PlannerMap extends State<PlannerMap>
{
  var _map;
  int cityId;
  int diff = 4;
  Map dataKeys = {};
  String cityName = "";
  List restaurants = [];
  bool accepted = false;
  var horizontalCalendar;
  String toDate = "d/m/a";
  String fromDate = "d/m/a";
  Set<Marker> markers = Set();
  var toDateObj = DateTime.now();
  var fromDateObj = DateTime.now();

  static CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 15.0,
  );
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    _getCity();
    _fetchRestaurants();
  }

  void _getCity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      cityId = prefs.getInt("selectedCity");
      cityName = prefs.getString("selectedCityName");
      print("city: ${cityId.toString()} - ${cityName}");
    });
  }

  void _fetchRestaurants() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String idUser = prefs.getString("id_user");
    var response = await Http.post(
        'http://api.foodie.quality.datia.co/planner/Planner',
      body: {
        "id_accion": "0",
        "id_user": idUser
      });

    List aux = [];
    Map map = jsonDecode(response.body);
    for (int i = 0; i < map["data"].length; i++) {
      var respRestaurants = await Http.post(
        'http://api.foodie.quality.datia.co/restaurant/filterrestaurantbyid',
      body: {
        "id_restaurant": map["data"][i]["id_restaurant"].toString()
      });

      Map mapRes = jsonDecode(respRestaurants.body);
      aux.add(mapRes["data"]);

      var latLng = LatLng(4.710075, -74.070634);
      setState(() {
        restaurants = aux;

        if (restaurants[0] != null) {
          latLng = LatLng(
            double.parse(restaurants[0]["latitude"]),
            double.parse(restaurants[0]["longitude"])
          );
        }

        Set<Marker> auxMarkers = Set();
        restaurants.forEach((item) => auxMarkers.add(Marker(
          markerId: MarkerId(item["name_restaurant"]),
          position: LatLng(double.parse(item["latitude"]), double.parse(item["longitude"])),
          infoWindow: InfoWindow(title: item["name_restaurant"], snippet: item["description"])
        )));
        markers = auxMarkers;

        _kGooglePlex = CameraPosition(
            target: latLng,
            zoom: 12.0,
          );

        _map = GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _kGooglePlex,
          markers: markers,
          onMapCreated: (GoogleMapController controller) {
            try {
              _controller.complete(controller);
            } catch (e) {
              print(e.toString());
            }
          },
          zoomGesturesEnabled: true,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
        title: AppBarTitle(content: PlannerMap()),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => PlannerList()
                          ));
                        },
                        child: Image.asset("images/icon_list_02.png"),
                      )
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
                      child: Image.asset("images/icon_pos_01.png", height: 60.0,),
                    ),
                    flex: 3,
                  ),
                ],
              ),
            ),
            flex: 2
          ),
        Container(
            margin: EdgeInsets.only(left: 40.0, right: 40.0),
            child: Divider(),
          ),
          Expanded(
            child: Container(
              child: _map,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height
            ),
            flex: 10,
          )
        ],
      ),
      bottomNavigationBar: AppBottomBar(tabSelected: 2,)
    );
  }
}