
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodie/home_screen.dart';
import 'package:foodie/views/list/list_detail.dart';
import 'package:http/http.dart' as Http;
import 'package:flutter/rendering.dart';
import 'package:foodie/views/home/drawer_state.dart';
import 'package:foodie/views/app_bar/app_bar_title.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ListDetailMap extends StatefulWidget
{
  final int idCity;
  final int idList;

  ListDetailMap({
    Key key,
    this.idCity,
    this.idList
  }) : super(key: key);

  @override
  _ListDetailMap createState() => new _ListDetailMap();
}

class _ListDetailMap extends State<ListDetailMap> 
{
  String baseImgUrl = "http://foodie.develop.datia.co/";
  ScrollController _listViewController = new ScrollController();

  var _map;
  var cityLat = 4.3634;
  var zoom    = 14.474;
  var cityLng = 74.0454;
  var listColor = Color.fromRGBO(193, 191, 202, 1);
  var mapColor  = Color.fromRGBO(250, 0, 60, 1);
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
      
      var latLng = LatLng(4.710075, -74.070634);
      setState(() {
        _markers = auxMarkers;
        restaurants = auxRestaurants;
        if (auxRestaurants[0] != null) {
          latLng = LatLng(
            double.parse(restaurants[0]["latitude"]),
            double.parse(restaurants[0]["longitude"])
          );
        }

        print("new maybe --->_<_>_> " + restaurants[0]["latitude"] + " - " + restaurants[0]["longitude"]);

        _kGooglePlex = CameraPosition(
          target: latLng,
          zoom: 12.0,
        );

        _map = GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _kGooglePlex,
          markers: _markers,
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

    //await _locationService.changeSettings(accuracy: LocationAccuracy.HIGH, interval: 10000);
    //LocationData location;
    //location = await _locationService.getLocation();
    
    /*_kGooglePlex = CameraPosition(
      target: LatLng(location.latitude, location.longitude),
      zoom: 12.0,
    );*/
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
        title: AppBarTitle(content: ListDetailMap())
      ),
      body: Column(
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
                    "Resultados mapa:",
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ListDetail(
                            idCity: widget.idCity,
                            idList: widget.idList,
                          )
                        ),
                      );
                    },
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
                    onPressed: () {},
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
          Container(
            height: MediaQuery.of(context).size.height * 0.60,
            child: _map,
          )
        ],
      ),
      endDrawer: DrawerState(),
    );
  }
}