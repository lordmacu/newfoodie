import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as Http;
import 'package:foodie/home_screen.dart';
import 'package:foodie/views/list/list_detail.dart';
import 'package:foodie/views/home/drawer_state.dart';
import 'package:foodie/views/app_bar/app_bar_title.dart';
import 'package:foodie/views/app_bar/app_bottom_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListSearch extends StatefulWidget
{
  final String searchWord;

  ListSearch({
    Key key,
    this.searchWord
  }) : super(key: key);

  @override
  _ListSearch createState() => new _ListSearch();
}

class _ListSearch extends State<ListSearch>
{
  Map itemExpanded = {};
  List<Widget> results = [];
  List<dynamic> dynamicResults = [];
  Map restaurantLists;
  String dropdownValue = 'Bogotá.dc';
  final searchController = TextEditingController();
  String baseImgUrl = "http://foodie.develop.datia.co/";
  ScrollController _controller = new ScrollController();

  @override
  void initState() {
    super.initState();
    fetchResults();
  }

  fetchResults() async {
    Map map;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (widget.searchWord == "" || widget.searchWord == null) {
      var response = await Http.post(
        'http://api.foodie.quality.datia.co/list/recommendlist',
        body: {
          "id_city": prefs.getInt("selectedCity").toString()
        });
      map = jsonDecode(response.body);
    } else {
      var response = await Http.post(
        'http://api.foodie.quality.datia.co/list/filterlistbywords',
        body: {
          "id_city": prefs.getInt("selectedCity").toString(),
          "word": widget.searchWord,
          "date": DateTime.now().toString()
        });
      map = jsonDecode(response.body);
    }

    List auxMap = [];
    if (map["data"] != null) {
      auxMap = map["data"];
    }
    Map auxList = {};
    for (int i = 0; i < auxMap.length; i++) {
      String id = auxMap[i]["id"].toString();
      auxList[id] = await getRestaurantsById(id);
    }
  
    setState(() {
      restaurantLists = auxList;
      print(" -> " + restaurantLists.toString());
      dynamicResults = auxMap;
      searchController.text = widget.searchWord;
    });
  }

  getRestaurantsById(String listId) async {
    var response = await Http.post(
      'http://api.foodie.quality.datia.co/list/listById',
      body: {
        "id_list": listId
      });
    Map map = jsonDecode(response.body);
    List restaurants = [];
    List auxRestaurants = map["data"];
    auxRestaurants.forEach((item) => restaurants.add(item));
    return restaurants;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child:  Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return new Container(
                  child: Image.asset("images/isotipo.png"),
                  margin: EdgeInsets.only(top: 12, bottom: 12)
              );
            },
          ),
          title: AppBarTitle(content: ListSearch()),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                      hintText: "Tipos de comidas, restaurantes",
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
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: MaterialButton(
                              child: Text(
                                "Buscar",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ListSearch(
                                      searchWord: searchController.text,
                                    )),
                                  );
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)
                              ),
                              color: Color.fromRGBO(250, 0, 60, 1),
                              height: 50,
                            ),
                          )
                      ),
                      flex: 1,
                    )
                  ]
              ),
              margin: EdgeInsets.only(left: 20, right: 20, top: 10),
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
            Container(
              margin: EdgeInsets.only(right: 20, left: 20, top: 20),
              child: ListView.builder(
                itemCount: dynamicResults.length,
                shrinkWrap: true,
                controller: _controller,
                itemBuilder: (context, position) {
                  var item = dynamicResults[position];
                  var restaurants = restaurantLists[item["id"].toString()];
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
                                      imageUrl: baseImgUrl + "img/" + item["image_list"],
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
                                              item["name_list"],
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontFamily: 'Quicksand Bold',
                                                  color: Color.fromRGBO(63, 67, 77, 1),
                                                  fontSize: 14
                                              ),
                                              maxLines: 2,
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
                                      Container(
                                        child: MaterialButton(
                                          child: Text(
                                            "Ver esta lista",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10
                                            ),
                                          ),
                                          onPressed: () async {
                                            SharedPreferences prefs = await SharedPreferences.getInstance();
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ListDetail(
                                                  idCity: prefs.getInt("selectedCity"),
                                                  idList: item["id"]
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
                          SingleChildScrollView(
                            child: Container(
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
                                                    "Restaurantes en la lista",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontFamily: 'Quicksand Bold',
                                                        color: Color.fromRGBO(63, 67, 77, 1),
                                                        fontSize: 11
                                                    )
                                                ),
                                                margin: EdgeInsets.only(top: 10, bottom: 10, left: 40),
                                              ),
                                            ),
                                          );
                                        },
                                        body: Container(
                                          width: MediaQuery.of(context).size.width * 0.4,
                                          child: Center(
                                            child: ListView.builder(
                                              itemCount: restaurants.length,
                                              itemBuilder: (context, position) {
                                                return Center(
                                                  child: Row(
                                                    children: <Widget>[
                                                      Image.asset("images/elipse127.png", height: 10, width: 10),
                                                      SizedBox(width: 10,),
                                                      Text(
                                                        restaurants[position]["name_restaurant"],
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontFamily: 'Quicksand Bold',
                                                          color: Color.fromRGBO(63, 67, 77, 1),
                                                          fontSize: 11
                                                        )
                                                      ),
                                                    ],
                                                  )
                                                );
                                              },
                                              shrinkWrap: true,
                                            ),
                                          ),
                                          //color: Colors.amber,
                                          margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                                        ),
                                        isExpanded: dynamicResults[position]["isExpanded"] == null ? false : dynamicResults[position]["isExpanded"],
                                      )
                                    ],
                                  ),
                                )
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                }
              ),
            ),
          ],
        ),
        endDrawer: DrawerState(),
        bottomNavigationBar: AppBottomBar(tabSelected: -1),
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
