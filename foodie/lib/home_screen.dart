
import 'dart:convert';

import 'package:foodie/postulate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as Http;
import 'package:foodie/views/home/drawer_state.dart';
import 'components/restaurants/models/restaurant.dart';
import 'package:foodie/views/app_bar/app_bar_title.dart';
import 'package:foodie/views/app_bar/app_bottom_bar.dart';
import 'package:foodie/views/home/home_search_result.dart';
import 'package:foodie/views/view_models/home_search.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:foodie/views/restaurants/restaurant_detail.dart';
import 'package:foodie/views/restaurants/modal_bottom_wishlist.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:foodie/components/restaurants/restaurants_manager.dart';

class HomeScreen extends StatefulWidget
{
  @override
  _HomeScreen createState() => new _HomeScreen();
}

class _HomeScreen extends State<HomeScreen>
{
  final searchController = TextEditingController();

  final PageController pageController = PageController(
      initialPage: 0,
      viewportFraction: 0.45
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
      viewportFraction: 0.33
  );

  List<String> cities = [
    "Bogotá.dc",
    "Barranquilla",
    "Medellin"
  ];

  List<String> options = [
    "Cena romántica",
    "Con amigos",
    "Fast food",
    "Comida árabe",
    "De pesca"
  ];

  String defaultTime = "DD/MM/AA";
  String baseImgUrl = "https://foodie.quality.datia.co/";

  List<dynamic> restaurants = [];
  List<dynamic> listOne = [];
  List<dynamic> listTwo = [];
  List<dynamic> listThree = [];
  List<dynamic> listFour = [];
  List<dynamic> listFive = [];
  List<Widget> favoriteItems = [];

  var favoriteColoreSelected  = Color.fromRGBO(250, 0, 60, 1);
  var favoriteColoredDisabled = Color.fromRGBO(193, 191, 202, 1);
  var favoritePosition = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await Http.post(
        'http://api.foodie.quality.datia.co/restaurant/restaurantList',
        body: {
          "id_city": prefs.getInt("selectedCity").toString()
        });

    Map map = jsonDecode(response.body);

    listOne   = map["listone"];
    listTwo   = map["listtwo"];
    listThree = map["listthree"];
    listFour  = map["listfour"];
    listFive  = map["listfive"];

    setState(() {
      restaurants = map["restaurants"];
      pageController.jumpToPage(3);
      pageCityController.jumpToPage(2);
      pageFavoriteController.jumpToPage(2);
      fetchFavorites(listOne, 0);
    });
  }

  fetchFavorites(List<dynamic> list, int position) {
    List<Widget> auxFavoriteWidgets = [];
    list.forEach((item) => auxFavoriteWidgets.add(GestureDetector(
      onTap: () {
        RestaurantsManager manager = new RestaurantsManager();
        Restaurant restaurant = manager.encapsulate(item);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RestaurantDetail(restaurant: restaurant,)
          ),
        );
      },
      child: Card(
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
                  )
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
      )),
    ));

    setState(() {
      favoriteItems = auxFavoriteWidgets;
      favoritePosition = position;
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
        title: AppBarTitle(content: HomeScreen()),
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
                        "Quieres probar algo nuevo?",
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
                      )
                  ),
                  margin: EdgeInsets.only(left: 20, right: 20),
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
                                      MaterialPageRoute(builder: (context) => HomeSearchResult(homeSearch: data,)),
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
                      itemCount:  restaurants.length,
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
                                          imageUrl: baseImgUrl + restaurants[position]["image_one"],
                                          //imageUrl: "https://media-cdn.tripadvisor.com/media/photo-f/0e/cc/19/e6/restaurant-chocolat.jpg",
                                          height: 90,
                                          width: MediaQuery.of(context).size.width,
                                          fit: BoxFit.cover
                                        ),
                                      )
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.add_circle,
                                          color: Colors.white,
                                        ),
                                        tooltip: 'Increase volume by 10',
                                        onPressed: () {
                                          showMenu(jsonEncode(restaurants[position]));
                                        },
                                      ),
                                    )
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
                                          "${restaurants[position]["score_foodie"]}",
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
                                          "${restaurants[position]["score_user"]}",
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
                                      restaurants[position]["name_restaurant"],
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
                                  children: <Widget>[
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
                                      child: Container(
                                        child: Text(
                                            restaurants[position]["address"],
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontFamily: 'Quicksand Regular',
                                                color: Color.fromRGBO(63, 63, 63, 1),
                                                fontSize: 9
                                            )
                                        ),
                                        margin: EdgeInsets.only(left: 20, right: 20),
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
                                        margin: EdgeInsets.only(left: 17, right: 15),
                                      ),
                                      flex: 1,
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Text(
                                            "12pm a 11:30pm",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontFamily: 'Quicksand Regular',
                                                color: Color.fromRGBO(63, 63, 63, 1),
                                                fontSize: 9
                                            )
                                        ),
                                        margin: EdgeInsets.only(left: 20, right: 20),
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
                                      var item = restaurants[position];

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
                        "EXPERIENCIAS",
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
                  child: Stack(
                    children: <Widget>[
                      Image.asset(
                        "images/group_5.png",
                        fit: BoxFit.cover,
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: Text(
                                  "Los mejores desayunos de Bogotá",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color.fromRGBO(120, 119, 127, 1),
                                      fontSize: 20
                                  )
                                ),
                                width: 200,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Center(
                    child: Text(
                        "LISTAS DE COLOMBIA",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Quicksand Bold',
                            color: Color.fromRGBO(193, 191, 202, 1),
                            fontSize: 14
                        )
                    ),
                  ),
                  margin: EdgeInsets.only(top: 20, bottom: 10),
                ),
                Container(
                  child: Divider(
                    color: Color.fromRGBO(193, 191, 202, 1),
                  ),
                  margin: EdgeInsets.only(left: 20, right: 20),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 20,
                  child: Container(
                    child: PageView.builder(
                        controller: pageCityController,
                        itemCount: cities.length,
                        itemBuilder: (context, position) {
                          return Text(
                              cities[position],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Quicksand Bold',
                                  fontSize: 14
                              )
                          );
                        }
                    ),
                  ),
                ),
                Container(
                  child: Divider(
                    color: Color.fromRGBO(193, 191, 202, 1),
                  ),
                  margin: EdgeInsets.only(left: 20, right: 20),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Container(
                      child: PageView.builder(
                          controller: pageOptionsController,
                          itemCount: options.length,
                          itemBuilder: (context, position) {
                            var itemColor;
                            if (position == favoritePosition) {
                              itemColor = favoriteColoreSelected;
                            } else {
                              itemColor = favoriteColoredDisabled;
                            }

                            return Padding(
                              padding: EdgeInsets.only(right: 10, top: 10, bottom: 10),
                              child: MaterialButton(
                                  child: Text(
                                    options[position],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 8
                                    ),
                                  ),
                                  onPressed: () {
                                    //print("->-> " + position.toString());
                                    setState(() {
                                      favoritePosition = position;
                                      switch (position) {
                                        case 0:
                                          fetchFavorites(listOne, position);
                                          break;
                                        case 1:
                                          fetchFavorites(listTwo, position);
                                          break;
                                        case 2:
                                          fetchFavorites(listThree, position);
                                          break;
                                        case 3:
                                          fetchFavorites(listFour, position);
                                          break;
                                        case 4:
                                          fetchFavorites(listFive, position);
                                          break;
                                      }
                                    });
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)
                                  ),
                                  color: itemColor,
                              )
                            );
                          }
                      ),
                    ),
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
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Postulate()
                      ),
                    );
                  },
                  child: Stack(
                    children: <Widget>[
                      Container(
                        child: Image.asset("images/postular_rest.png"),
                        margin: EdgeInsets.only(left: 20, right: 20, top: 20)
                      ),
                      Positioned(
                        bottom: 35.0,
                        left: 100.0,
                        child: MaterialButton(
                          child: Text(
                            "Postúlalo ya",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Postulate()
                              ),
                            );
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)
                          ),
                          color: Color.fromRGBO(250, 0, 60, 1),
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
      endDrawer: DrawerState(),
      bottomNavigationBar: AppBottomBar(tabSelected: 0,)
    );
  }
}
