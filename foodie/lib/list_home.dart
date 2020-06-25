
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodie/home_screen.dart';
import 'package:foodie/views/app_bar/app_bottom_bar.dart';
import 'package:foodie/views/list/list_detail.dart';
import 'package:foodie/views/list/list_search.dart';
import 'package:foodie/views/restaurants/modal_bottom_wishlist.dart';
import 'package:http/http.dart' as Http;
import 'package:foodie/views/home/drawer_state.dart';
import 'package:foodie/views/app_bar/app_bar_title.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListHome extends StatefulWidget
{
  @override
  _ListHome createState() => new _ListHome();
}

class _ListHome extends State<ListHome>
{
  String defaultTime = "DD/MM/AA";
  String baseImgUrl = "https://foodie.quality.datia.co/";
  final searchController = TextEditingController();

  final PageController pageController = PageController(
      initialPage: 0,
      viewportFraction: 0.5
  );

  final PageController pageCityController = PageController(
      initialPage: 0,
      viewportFraction: 0.5
  );

  final PageController pageOptionsController = PageController(
      initialPage: 0,
      viewportFraction: 0.3
  );

  final PageController pageFavoriteController = PageController(
      initialPage: 0,
      viewportFraction: 0.4
  );

  List lists = [];
  List sliderList = [];
  List listOne = [];
  List<Widget> favoriteItems = [];
  List suggestedList = [Text(""), Text(""), Text("")];

  @override
  initState() {
    super.initState();
    fetchSuggested();
    fetchData();
    fetchRestaurants();
  }

  fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await Http.post(
        'http://api.foodie.quality.datia.co/list/recommendlist',
        body: {
          "id_city": prefs.getInt("selectedCity").toString()
        });

    Map map = jsonDecode(response.body);
    List data = map["data"];

    List aux = [];
    data.forEach((item) => aux.add(item));

    setState(() {
      lists = aux;
      pageController.jumpToPage(1);
    });
  }

  fetchSuggested() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await Http.post(
        'http://api.foodie.quality.datia.co/list/listsuggested',
        body: {
          "id_city": prefs.getInt("selectedCity").toString()
        });

    Map result = jsonDecode(response.body);
    List data = result["data"];
    List auxList = [];

    for (var i = 0; i < data.length; i++) {
      auxList.add(GestureDetector(
        onTap: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ListDetail(
                idCity: prefs.getInt("selectedCity"),
                idList: data[i]["id"],
              )
            ),
          );
        },
        child: Column(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage(
                baseImgUrl + "img/" + data[i]["image_list"]
              ),
              radius: 40.0,
            ),
            Container(
              child: Center(
                child: Text(
                    data[i]["name_list"],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Quicksand Regular',
                        color: Color.fromRGBO(63, 63, 63, 1),
                        fontSize: 11
                    )
                ),
              ),
              margin: EdgeInsets.only(left: 5, top: 5, right: 5),
            )
          ],
        ),
      ));
    }

    setState(() {
      suggestedList = auxList;
    });
  }

  fetchRestaurants() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await Http.post(
        'http://api.foodie.quality.datia.co/restaurant/restaurantList',
        body: {
          "id_city": prefs.getInt("selectedCity").toString()
        });

    Map map = jsonDecode(response.body);
    listOne = map["listone"];

    setState(() {
      fetchFavorites(listOne, 0);
      pageFavoriteController.jumpToPage(1);
    });
  }

  fetchFavorites(List<dynamic> list, int position) {
    List<Widget> auxFavoriteWidgets = [];
    list.forEach((item) => auxFavoriteWidgets.add(Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 80,
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0)
                    ),
                    child: CachedNetworkImage(
                      imageUrl: baseImgUrl + item["image_one"],
                      //imageUrl: "https://media-cdn.tripadvisor.com/media/photo-f/0e/cc/19/e6/restaurant-chocolat.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                /*Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(
                      Icons.add_circle,
                      color: Colors.white,
                    ),
                    tooltip: 'Increase volume by 10',
                    onPressed: () {
                      showMenu(jsonEncode(item));
                    },
                  ),
                )*/
              ],
            ),
            SizedBox(
              width: double.infinity,
              height: 8.0,
            ),
            Center(
              child: Text(
                  item["name_restaurant"],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Quicksand Bold',
                      color: Color.fromRGBO(63, 63, 63, 1),
                      fontSize: 10
                  )
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 8.0,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
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
            SizedBox(
              width: double.infinity,
              height: 8.0,
            ),
          ],
        ),
      ),
    )));

    setState(() {
      favoriteItems = auxFavoriteWidgets;
    });
  }

  showMenu(String restaurant) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ModalBottomWishlist(
          restaurant: restaurant
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {

    String dropdownValue = 'Bogotá.dc';

    return new Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return new Container(
                child: Image.asset("images/isotipo.png"),
                margin: EdgeInsets.only(top: 12, bottom: 12)
            );
          },
        ),
        title: AppBarTitle(content: ListHome()),
      ),
      body: WillPopScope(
        //Wrap out body with a `WillPopScope` widget that handles when a user is cosing current route
        onWillPop: () async {
          Future.value(false); //return a `Future` with false value so this route cant be popped or closed.
          return;
        },
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  child: Center(
                    child: Text(
                        "Come bien a donde sea que vayas.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Quicksand Bold',
                            color: Color.fromRGBO(63, 67, 77, 1),
                            fontSize: 14
                        )
                    ),
                  ),
                  margin: EdgeInsets.only(top: 20),
                ),
                Container(
                  child: Center(
                    child: Text(
                        "Que lista estas buscando?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Quicksand Regular',
                            color: Color.fromRGBO(63, 63, 63, 1),
                            fontSize: 12
                        )
                    ),
                  ),
                  margin: EdgeInsets.only(bottom: 20),
                ),
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
                      )
                  ),
                  margin: EdgeInsets.only(left: 20, right: 20),
                  height: 50.0,
                ),
                Container(
                  child: new Row(
                      children: <Widget>[
                        Spacer(flex: 1,),
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
                                  minWidth: double.infinity,
                                ),
                              )
                          ),
                          flex: 2,
                        ),
                        Spacer(flex: 1,),
                      ]
                  ),
                  margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                ),
                Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    child: Text(
                      "Listas sugeridas",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromRGBO(250, 0, 60, 1),
                        fontSize: 18
                      ),
                    ),
                    padding: EdgeInsets.only(bottom: 20.0, top: 10.0),
                  ),
                  margin: EdgeInsets.only(top: 20),
                ),
                Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: suggestedList[0],
                        ),
                        Expanded(
                          child: suggestedList[1],
                        ),
                        Expanded(
                          child: suggestedList[2],
                        )
                      ],
                    ),
                  ),
                  margin: EdgeInsets.only(bottom: 15),
                  padding: EdgeInsets.only(bottom:15)
                ),
                Container(
                  child: Center(
                    child: Text(
                        "PROMOCIÓN DEL DÍA",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Quicksand Bold',
                            color: Color.fromRGBO(193, 191, 202, 1),
                            fontSize: 14
                        )
                    ),
                  ),
                  margin: EdgeInsets.only(top: 15, bottom: 15),
                ),
                Container(
                    child: Image.asset("images/promocion.png"),
                    margin: EdgeInsets.only(left: 20, right: 20)
                ),
                Container(
                  child: Center(
                    child: Text(
                        "NUESTRAS RECOMENDACIONES",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Quicksand Bold',
                            color: Color.fromRGBO(193, 191, 202, 1),
                            fontSize: 14
                        )
                    ),
                  ),
                  margin: EdgeInsets.only(top: 15, bottom: 15),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 250,
                  child: Container(
                    child: PageView.builder(
                      controller: pageController,
                      itemCount:  lists.length,
                      itemBuilder: (context, position) {

                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          color: Colors.white,
                          child: Center(
                            child: Column(
                              children: <Widget>[
                                Stack(
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20.0),
                                          topRight: Radius.circular(20.0)
                                      ),
                                      child: Container(
                                        child: CachedNetworkImage(
                                          imageUrl: baseImgUrl + "img/" + lists[position]["image_list"],
                                          //imageUrl: "https://media-cdn.tripadvisor.com/media/photo-f/0e/cc/19/e6/restaurant-chocolat.jpg",
                                          height: 90,
                                          width: MediaQuery.of(context).size.width,
                                          fit: BoxFit.cover
                                        ),
                                      )
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  height: 8.0,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset("images/hat.png", height: 15,),
                                    Container(
                                      child: Text(
                                          lists[position]["score_foodie"],
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
                                          lists[position]["score_user"],
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
                                SizedBox(
                                  width: double.infinity,
                                  height: 8.0,
                                ),
                                Center(
                                  child: Text(
                                      lists[position]["name_list"],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: 'Quicksand Bold',
                                          color: Color.fromRGBO(63, 63, 63, 1),
                                          fontSize: 10
                                      )
                                  ),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  height: 8.0,
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
                                      var item = lists[position];
                                      SharedPreferences prefs = await SharedPreferences.getInstance();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ListDetail(
                                            idCity: prefs.getInt("selectedCity"),
                                            idList: item["id"],
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
                        );
                      },
                    ),
                  ),
                ),
                Container(
                  child: Center(
                    child: Text(
                        "TE PUEDE INTERESAR",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Quicksand Bold',
                            color: Color.fromRGBO(193, 191, 202, 1),
                            fontSize: 14
                        )
                    ),
                  ),
                  margin: EdgeInsets.only(top: 15, bottom: 15),
                ),
                Container(
                  child: Divider(
                    color: Color.fromRGBO(193, 191, 202, 1),
                  ),
                  margin: EdgeInsets.only(left: 20, right: 20),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 170,
                  child: Container(
                    child: PageView(
                      controller: pageFavoriteController,
                      children:   favoriteItems,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      endDrawer: DrawerState(),
      bottomNavigationBar: AppBottomBar(),
    );
  }
}
