import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:foodie/components/restaurants/models/restaurant.dart';
import 'package:foodie/components/restaurants/restaurants_manager.dart';
import 'package:http/http.dart' as Http;
import 'package:foodie/home_screen.dart';
import 'package:foodie/views/home/drawer_state.dart';
import 'package:foodie/views/app_bar/app_bar_title.dart';
import 'package:foodie/views/app_bar/app_bottom_bar.dart';
import 'package:foodie/views/view_models/home_search.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:foodie/views/restaurants/restaurant_detail.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeSearchResult extends StatefulWidget
{
  final HomeSearch homeSearch;

  HomeSearchResult({
    Key key,
    this.homeSearch
  }) : super(key: key);

  @override
  _HomeSearchResult createState() => new _HomeSearchResult();
}

class _HomeSearchResult extends State<HomeSearchResult>
{
  List<Widget> results = [];
  List<dynamic> dynamicResults = [];
  String baseImgUrl = "http://foodie.develop.datia.co/";
  final searchController = TextEditingController();
  String dropdownValue = 'Bogotá.dc';
  String defaultTime   = "DD/MM/AA";
  ScrollController _controller = new ScrollController();
  Map itemExpanded = {};

  @override
  void initState() {
    super.initState();
    fetchResults();
  }

  fetchResults() async {
    Map map;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (widget.homeSearch.searchContent == "") {
      //print("searhc search content: " + widget.homeSearch.searchContent);
      var response = await Http.post(
        'http://api.foodie.quality.datia.co/restaurant/restaurantList',
        body: {
          "id_city":prefs.getInt("selectedCity").toString()
        });
      map = jsonDecode(response.body);
      //print("da searhc search content: " + map.toString());
    } else {
      //print("searhc find word: " + widget.homeSearch.searchContent);
      var response = await Http.post(
        'http://api.foodie.quality.datia.co/restaurant/filterrestaurantbywords',
        body: {
          "id_city": prefs.getInt("selectedCity").toString(),
          "word": widget.homeSearch.searchContent,
          "date": DateTime.now().toString()
        });

        print("esta es la respuesta ${response.body}");
      map = jsonDecode(response.body);
    }
    
    setState(() {
      List auxMap = [];
      if (map["data"] != null) {
        auxMap = map["data"];
      }
      if (auxMap.length == 0 && map["restaurants"] != null) {
        auxMap = map["restaurants"];
      }
      print("aux " + auxMap.toString());
      dynamicResults = auxMap;
      defaultTime = widget.homeSearch.getDate();
      searchController.text = widget.homeSearch.getSearchContent();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child:  Scaffold(
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
          title: AppBarTitle(content: HomeSearchResult()),
        ),
        body: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                          hintText: "Restaurantes, comidas, experiencias",
                          hintStyle: TextStyle(fontSize: 14, color: Color.fromRGBO(193, 191, 202, 1)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(193, 191, 202, 1),
                                  width: 1
                              ),
                              borderRadius: BorderRadius.circular(50.0)
                          ),
                          focusColor: Colors.amber,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(250, 0, 60, 1),
                                  width: 1
                              ),
                              borderRadius: BorderRadius.circular(50.0)
                          )
                      ),
                  ),
                  margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                  height: 50.0,
                ),
                Container(
                  child: new Row(
                      children: <Widget>[
                        new Expanded(
                            child: new Center(
                                child: Container(
                                  child: MaterialButton(
                                    child: FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text(
                                        defaultTime,
                                        style: TextStyle(
                                            color: Color.fromRGBO(193, 191, 202, 1),
                                            fontSize: 16
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                        DatePicker.showDateTimePicker(
                                          context,
                                          showTitleActions: true,
                                          minTime: DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch - 172800),
                                          maxTime: DateTime(2030), 
                                          onChanged: (date) {
                                            print('change $date in time zone ' +
                                            date.timeZoneOffset.inHours.toString());
                                            
                                          },
                                          onConfirm: (date) {
                                            setState(() {
                                              defaultTime = "${date.day}/${date.month}/${date.year}";
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
                        new Expanded(
                          child: new Center(
                              child: Container(
                                child: MaterialButton(
                                  child: Text(
                                    "Buscar",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16
                                    ),
                                  ),
                                  onPressed: () {
                                    HomeSearch data = new HomeSearch();
                                    data.setDate(defaultTime);
                                    data.setSearchContent(searchController.text);

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HomeSearchResult(homeSearch: data,)
                                      ),
                                    );
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)
                                  ),
                                  color: Color.fromRGBO(250, 0, 60, 1),
                                  height: 50,
                                  minWidth: double.infinity,
                                ),
                              )
                          ),
                          flex: 1,
                        )
                      ]
                  ),
                  margin: EdgeInsets.only(left: 5, right: 20, top: 10),
                ),
                Container(
                  child: Center(
                    child: Text(
                      "Resultados: ${dynamicResults.length} restaurantes",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color.fromRGBO(63, 67, 77, 1),
                          fontSize: 12
                      ),
                      maxLines: 2,
                    ),
                  ),
                  margin: EdgeInsets.only(top: 20),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(right: 20, left: 20, top: 20),
              child: ListView.builder(
                itemBuilder: (context, position) {
                  var item = dynamicResults[position];
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
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: item["image_one"],
                                      //imageUrl: "https://media-cdn.tripadvisor.com/media/photo-f/0e/cc/19/e6/restaurant-chocolat.jpg",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  height: MediaQuery.of(context).size.height * 0.225
                                ),
                                flex: 1,
                              ),
                              Expanded(
                                child: Container(
                                  height: MediaQuery.of(context).size.height * 0.225,
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
                                        height: 10.0,
                                      ),
                                       item["score_user"] != null  ? Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                            Image.asset("images/hat.png", height: 15,),
                                            Container(
                                              child: Text(
                                                  "${item["score_foodie"]}",
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
                                                  "${item["score_user"]}",
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
                                      ): Container(),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                              child: Icon(
                                                Icons.place,
                                                color: Color.fromRGBO(173, 192, 202, 1),
                                                size: 15,
                                              ),
                                              margin: EdgeInsets.only(top: 10.0),
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
                                              margin: EdgeInsets.only(left: 5, top: 5.0),
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
                                                  "aaaa 12pm a 11:30pm",
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
                                            print("from here: " + restaurant.toMap().toString());

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
                                        margin: EdgeInsets.only(top: 5),
                                      )
                                    ],
                                  ),
                                ),
                                flex: 2,
                              )
                            ],
                          ),
                          Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0),
                              ),
                              child: Theme(
                                data: Theme.of(context).copyWith(cardColor: Color.fromRGBO(249, 249, 251, 1)),
                                child: ExpansionPanelList(
                                  expansionCallback: (int index, bool isExpanded) {
                                    setState(() {
                                      dynamicResults[position]["isExpanded"] = isExpanded ? false: true;
                                    });
                                  },
                                  children: <ExpansionPanel>[
                                    ExpansionPanel(
                                      headerBuilder: (BuildContext context, bool isExpanded) {
                                        return Center(
                                          child: Container(
                                            width: double.infinity,
                                            child: Container(
                                              child: Text(
                                                  "Platos populares",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontFamily: 'Quicksand Bold',
                                                      color: Color.fromRGBO(63, 67, 77, 1),
                                                      fontSize: 11
                                                  )
                                              ),
                                              margin: EdgeInsets.only(top: 10, bottom: 10.0, left: 40),
                                            ),
                                          ),
                                        );
                                      },
                                      body: Container(
                                        margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.only(right: 10.0),
                                              child:  Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Image.asset("images/elipse127.png", height: 10, width: 10),
                                                      SizedBox(width: 10,),
                                                      Text(
                                                        "Pulpo en salsa de maní",
                                                        textAlign: TextAlign.left,
                                                        style: TextStyle(
                                                          fontFamily: 'Quicksand Bold',
                                                          color: Color.fromRGBO(63, 67, 77, 1),
                                                          fontSize: 11
                                                        )
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 5.0),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Image.asset("images/elipse127.png", height: 10, width: 10),
                                                      SizedBox(width: 10,),
                                                      Text(
                                                        "Muelitas de cangrejo",
                                                        textAlign: TextAlign.left,
                                                        style: TextStyle(
                                                          fontFamily: 'Quicksand Bold',
                                                          color: Color.fromRGBO(63, 67, 77, 1),
                                                          fontSize: 11
                                                        )
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Image.asset("images/elipse127.png", height: 10, width: 10),
                                                    SizedBox(width: 10,),
                                                    Text(
                                                      "Camarones a la diable",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        fontFamily: 'Quicksand Bold',
                                                        color: Color.fromRGBO(63, 67, 77, 1),
                                                        fontSize: 11
                                                      )
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 5.0),
                                                Row(
                                                    children: <Widget>[
                                                      Image.asset("images/elipse127.png", height: 10, width: 10),
                                                      SizedBox(width: 10,),
                                                      Text(
                                                        "Pulpo en salsa de maní",
                                                        textAlign: TextAlign.left,
                                                        style: TextStyle(
                                                          fontFamily: 'Quicksand Bold',
                                                          color: Color.fromRGBO(63, 67, 77, 1),
                                                          fontSize: 11
                                                        )
                                                      ),
                                                    ],
                                                  )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      isExpanded: dynamicResults[position]["isExpanded"] == null ? false : dynamicResults[position]["isExpanded"],
                                      
                                    )
                                  ],
                                ),
                              )
                            ),
                          ),
                        ],
                      ),
                    );
                },
                itemCount: dynamicResults.length,
                shrinkWrap: true,
                controller: _controller,
              ),
            ),
            /*ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: results,
            )*/
          ]
        ),
        endDrawer: DrawerState(),
        bottomNavigationBar: AppBottomBar(tabSelected: 0,)
      ),
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen()
          ),
        );
        return;
      },
    );
  }
}
