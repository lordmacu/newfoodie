
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foodie/components/restaurants/models/restaurant.dart';
import 'package:foodie/home_screen.dart';
import 'package:foodie/views/app_bar/app_bar_title.dart';
import 'package:foodie/views/helpers/video_player.dart';
import 'package:foodie/views/home/drawer_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:foodie/views/restaurants/modal_bottom_sheet.dart';
import 'package:intl/intl.dart';
import 'package:after_layout/after_layout.dart';

class RestaurantDetail extends StatefulWidget
{
  final Restaurant restaurant;

  RestaurantDetail({
    Key key,
    this.restaurant
  }) : super(key: key);

  @override
  _RestaurantDetail createState() => new _RestaurantDetail();
}

class _RestaurantDetail extends State<RestaurantDetail>  with AfterLayoutMixin<RestaurantDetail>
{
  String baseImgUrl = "http://foodie.develop.datia.co/";
  
  PageController _pageController = PageController(
    initialPage: 0,
  );

  List<Widget> elipses = [];
  List<String> images  = [];
  Set<Marker> markers = Set();
  String elipseEnable  = "images/elipse127.png";
  String elipseDisable = "images/elipse128.png";
  String startDay;
  String endDay;

 int sizeImages=0;
  static CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 15.0,
  );

  var restaurant;
  var restaurantMenu;
  Completer<GoogleMapController> _controller = Completer();

  getRestaurant() {

    print("este es el restaurante3 ${widget.restaurant}");
    var imagesList = [];
    imagesList = widget.restaurant.images.split(",");
    setState(() {
      sizeImages=imagesList.length;
    });

    elipses = [];
    for (int i = 0; i < imagesList.length; i++) {
     
      elipses.add(Container(
        child: Image(image: AssetImage(elipseDisable)),
        height: 20,
      ));
      images.add(imagesList[i]);
    }
    elipses[0] = Container(
      child: Image(image: AssetImage(elipseEnable)),
      height: 20,
    );

    _kGooglePlex = CameraPosition(
      target: LatLng(
        double.parse(widget.restaurant.latitude),
        double.parse(widget.restaurant.longitude),
      ),
      zoom: 15.0,
    );

    markers.add(Marker(
      markerId: MarkerId(widget.restaurant.nameRestaurant),
      position: LatLng(
        double.parse(widget.restaurant.latitude),
        double.parse(widget.restaurant.longitude)
      ),
      infoWindow: InfoWindow(
        title: widget.restaurant.nameRestaurant, 
        snippet: widget.restaurant.description
      )
    ));
  }
  
  @override
  initState() {


    _pageController = PageController(
      initialPage: 0,
    );

    super.initState();


        print("este es el restaurante3 ${widget.restaurant.imagesList}");
        var date = DateTime.now();
        

        var day=DateFormat('EEEE').format(date);
        if(day=="Monday"){
            startDay=widget.restaurant.mondayStart;
            endDay=widget.restaurant.mondayEnd;
        }
          if(day=="Tuesday"){
            startDay=widget.restaurant.tuesdayStart;
            endDay=widget.restaurant.tuesdayEnd;
        }
          if(day=="Wednesday"){
            startDay=widget.restaurant.wednesdayStart;
            endDay=widget.restaurant.wednesdayEnd;
        }
          if(day=="Thursday"){
            startDay=widget.restaurant.thursdayStart;
            endDay=widget.restaurant.thursdayEnd;
        }
          if(day=="Friday"){
            startDay=widget.restaurant.fridayStart;
            endDay=widget.restaurant.fridayEnd;
        }
          if(day=="Saturday"){
            startDay=widget.restaurant.saturdayStart;
            endDay=widget.restaurant.saturdayEnd;
        }

           if(day=="Sunday"){
            startDay=widget.restaurant.sundayStart;
            endDay=widget.restaurant.sundayEnd;
        }
  }

  showMenu() {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ModalBottomSheet(
          restaurant: widget.restaurant,
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
          appBar: AppBar(
            leading: Builder(
              builder: (BuildContext context) {
                return new Container(
                    child: Image.asset("images/isotipo.png"),
                    margin: EdgeInsets.only(top: 12, bottom: 12)
                );
              },
            ),
            title: AppBarTitle(content: RestaurantDetail()),
          ),
          body: ListView(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    child: PageView.builder(
                      controller:  _pageController,
                      itemCount:   images.length,
                      itemBuilder: (context, position) {
                        return CachedNetworkImage(
                          imageUrl: baseImgUrl + "img/" + images[position],
                          //imageUrl: "https://media-cdn.tripadvisor.com/media/photo-f/0e/cc/0e/db/terras-restaurant-chocolat.jpg",
                          height: MediaQuery.of(context).size.height,
                          fit: BoxFit.cover
                        );
                      },
                      onPageChanged: (current) {
                        setState(() {
                          elipses = [];
                          for (int i = 0; i < images.length; i++) {
                            elipses.add(Container(
                              child: Image(image: AssetImage(elipseDisable)),
                              height: 20,
                            ));
                          }
                          elipses[current] = Container(
                            child: Image(image: AssetImage(elipseEnable)),
                            height: 20,
                          );
                        });
                      },
                    ),
                  ),
                  /*Positioned(
                    bottom: 5.0,
                    left: 5.0,
                    child: GestureDetector(
                      child: Container(
                        height: 25.0,
                        child: Image.asset("images/icon_gallery.png")
                      ),
                    )
                  ),*/
                  Positioned(
                    width: MediaQuery.of(context).size.width,
                    bottom: 0.0,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0)
                            ),
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: elipses,
                              ),
                              width: MediaQuery.of(context).size.width * 0.3,
                              color: Color.fromRGBO(255, 255, 255, 0.8),
                            ),
                          )
                        ],
                      ),
                    )
                  ),
                  Positioned(
                    bottom: 5.0,
                    right: 5.0,
                    child: GestureDetector(
                      onTap: () {
                        print("video player: " + baseImgUrl + widget.restaurant.videos.toString());
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => VideoPlayerScreen(videoUrl: baseImgUrl + widget.restaurant.videos.toString())
                        ));
                      },
                      child:  Container(
                        height: 25.0,
                        child: Image.asset("images/icon_video.png")
                      ),
                    )
                  ),
                ],
              ),
              SizedBox(height: 12,),
              Container(
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Text(
                        widget.restaurant.nameRestaurant,
                        style: TextStyle(
                          color: Color.fromRGBO(250, 0, 60, 1),
                          fontSize: 18
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        widget.restaurant.typeFood,
                        style: TextStyle(
                          color: Color.fromRGBO(63, 63, 63, 1),
                          fontSize: 12
                        ),
                        textAlign: TextAlign.start,
                      ),
                      margin: EdgeInsets.only(left: 5, top: 5),
                    ),
                  ],
                ),
                margin: EdgeInsets.only(left: 20, right: 20)
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                      Image.asset("images/hat.png", height: 15,),
                      Container(
                        child: Text(
                            widget.restaurant.scoreFoodie,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Quicksand Regular',
                                color: Color.fromRGBO(63, 63, 63, 1),
                                fontSize: 12
                            )
                        ),
                        margin: EdgeInsets.only(right: 5, left: 5),
                      ),
                      Container(
                        child: Text(
                            "FOODIE PRO",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Quicksand Bold',
                                color: Color.fromRGBO(63, 63, 63, 1),
                                fontSize: 12
                            )
                        ),
                        margin: EdgeInsets.only(right: 5, left: 5),
                      ),
                      Image.asset("images/cup.png", height: 15,),
                      Container(
                        child: Text(
                            widget.restaurant.scoreUser,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Quicksand Regular',
                                color: Color.fromRGBO(63, 63, 63, 1),
                                fontSize: 12
                            )
                        ),
                        margin: EdgeInsets.only(right: 5, left: 5),
                      ),
                      Container(
                        child: Text(
                          "COMENSALES",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Quicksand Bold',
                              color: Color.fromRGBO(63, 63, 63, 1),
                              fontSize: 12
                          )
                        ),
                        margin: EdgeInsets.only(right: 10, left: 5),
                      ),
                  ],
                ),
                margin: EdgeInsets.only(left: 20, right: 20, top: 15)
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.place,
                        color: Color.fromRGBO(173, 192, 202, 1),
                        size: 15,
                      ),
                    ),
                    SizedBox(width: 5,),
                    Container(
                      width: 120,
                      child: Text(
                          widget.restaurant.address,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontFamily: 'Quicksand Regular',
                              color: Color.fromRGBO(63, 63, 63, 1),
                              fontSize: 10
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 10,),
                    startDay!=null ? Container(
                      child: Icon(
                        Icons.watch_later,
                        color: Color.fromRGBO(173, 192, 202, 1),
                        size: 12,
                      ),
                    ):Container(),
                    SizedBox(width: 5,),
                    startDay!=null ? Container(
                      width: 100.0,
                      child: Text(
                          "${startDay}  ${endDay}",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontFamily: 'Quicksand Regular',
                              color: Color.fromRGBO(63, 63, 63, 1),
                              fontSize: 10
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                      ),
                    ) : Container(),
                    SizedBox(width: 10,),
                    Container(
                      child: Icon(
                        Icons.monetization_on,
                        color: Color.fromRGBO(173, 192, 202, 1),
                        size: 12,
                      ),
                    ),
                    SizedBox(width: 5,),
                    Container(
                      child: Text(
                          widget.restaurant.priceAverage.toString(),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontFamily: 'Quicksand Regular',
                              color: Color.fromRGBO(63, 63, 63, 1),
                              fontSize: 10
                          ),
                          overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
                margin: EdgeInsets.only(left: 20, right: 20, top: 15)
              ),
              Container(
                child: Text(
                  "Galeria",
                  textAlign: TextAlign.start,
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
              images.length>0 ? Container(
                child: CachedNetworkImage(
                  imageUrl: baseImgUrl + "img/" + images[0],
                  //imageUrl: "https://media-cdn.tripadvisor.com/media/photo-f/0e/cc/0e/db/terras-restaurant-chocolat.jpg",
                  fit: BoxFit.cover,
                ),
                height: 200.0,
                margin: EdgeInsets.only(left: 20, right: 20, top: 15)
              ): Container(),
              images.length>1 ?  Container(
                child: Row(
                  children: <Widget>[
                    images.length> 0 ? Container (
                      child: Container(
                        child: CachedNetworkImage(
                          imageUrl: baseImgUrl + "img/" + images[1],
                          //imageUrl: "https://media-cdn.tripadvisor.com/media/photo-f/0e/cc/0e/db/terras-restaurant-chocolat.jpg",
                          fit: BoxFit.cover,
                        ),
                        margin: EdgeInsets.only(right: 5, top: 5)
                      ),
                    ): Container(),
                    sizeImages>1 ? Container(
                      child: Container(
                        child: CachedNetworkImage(
                          imageUrl: baseImgUrl + "img/" + images[2],
                          //imageUrl: "https://media-cdn.tripadvisor.com/media/photo-f/0e/cc/0e/db/terras-restaurant-chocolat.jpg",
                          fit: BoxFit.cover,
                        ),
                        margin: EdgeInsets.only(right: 5, top: 5)
                      ),
                    ) : Container(),
                    sizeImages>2 ? Container(
                      child: Container(
                        child: CachedNetworkImage(
                          imageUrl: baseImgUrl + "img/" + images[3],
                          //imageUrl: "https://media-cdn.tripadvisor.com/media/photo-f/0e/cc/0e/db/terras-restaurant-chocolat.jpg",
                          fit: BoxFit.cover,
                        ),
                        margin: EdgeInsets.only(right: 5, top: 5)
                      ),
                    ): Container(),
                   sizeImages>3 ? Expanded(
                      child: Container(
                        child: CachedNetworkImage(
                          imageUrl: baseImgUrl + "img/" + images[4],
                          //imageUrl: "https://media-cdn.tripadvisor.com/media/photo-f/0e/cc/0e/db/terras-restaurant-chocolat.jpg",
                          fit: BoxFit.cover,
                        ),
                        margin: EdgeInsets.only(right: 5, top: 5)
                      ),
                    ): Container(),
                  ],
                ),
                height: 50.0,
                margin: EdgeInsets.only(left: 20, right: 20, top: 5)
              ): Container(),
              Container(
                child: Text(
                  "Descripción",
                  textAlign: TextAlign.start,
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
              Container(
                child: Text(
                    widget.restaurant.description,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontFamily: 'Quicksand Regular',
                        color: Color.fromRGBO(63, 63, 63, 1),
                        fontSize: 10
                    ),
                ),
                margin: EdgeInsets.only(left: 20, right: 20, top: 15)
              ),
              Container(
                child: Text(
                  "Ubicación en el mapa",
                  textAlign: TextAlign.start,
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
              Container(
                child: GoogleMap(
                  markers: markers,
                  mapType: MapType.normal,
                  initialCameraPosition: _kGooglePlex,
                  onMapCreated: (GoogleMapController controller) {
                    try {
                      _controller.complete(controller);
                    } catch (e) {}
                  },
                  zoomGesturesEnabled: true
                ),
                height: 200.0,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 15)
              ),
              Container(
                child: Text(
                  "Platos recomendados",
                  textAlign: TextAlign.start,
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
              Container(
                color: Color.fromRGBO(248, 249, 249, 1),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Image.asset("images/elipse127.png", height: 20),
                          flex: 1,
                        ),
                        Expanded(
                          child: Text(
                            "Thick bacon strip",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontFamily: 'Quicksand Bold',
                                color: Color.fromRGBO(63, 63, 63, 1),
                                fontSize: 12
                            ),
                            maxLines: 1,
                            //overflow: TextOverflow.ellipsis,
                          ),
                          flex: 4,
                        ),
                        Expanded(
                          child: Text(
                            "Entrada",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontFamily: 'Quicksand Regular',
                                color: Color.fromRGBO(63, 63, 63, 1),
                                fontSize: 12
                            ),
                            maxLines: 1,
                            //overflow: TextOverflow.ellipsis,
                          ),
                          flex: 3,
                        ),
                        Expanded(
                          child: Text(
                            '\$17000 COP',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontFamily: 'Quicksand Bold',
                                color: Color.fromRGBO(63, 63, 63, 1),
                                fontSize: 12
                            ),
                            maxLines: 1,
                            //overflow: TextOverflow.ellipsis,
                          ),
                          flex: 3,
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(""),
                          flex: 1,
                        ),
                        Expanded(
                          child: Text(
                            "Tocineta ahumada y caramelizada",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontFamily: 'Quicksand Regular',
                                color: Color.fromRGBO(63, 63, 63, 1),
                                fontSize: 12
                            ),
                            maxLines: 1,
                            //overflow: TextOverflow.ellipsis,
                          ),
                          flex: 7,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Image.asset("images/hat.png", height: 15,),
                              Container(
                                child: Text(
                                    widget.restaurant.scoreFoodie,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'Quicksand Regular',
                                        color: Color.fromRGBO(63, 63, 63, 1),
                                        fontSize: 12
                                    )
                                ),
                                margin: EdgeInsets.only(right: 5),
                              ),
                              Image.asset("images/cup.png", height: 15,),
                              Container(
                                child: Text(
                                    widget.restaurant.scoreUser,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'Quicksand Regular',
                                        color: Color.fromRGBO(63, 63, 63, 1),
                                        fontSize: 12
                                    )
                                ),
                                margin: EdgeInsets.only(left: 5),
                              )
                            ]
                          ),
                          flex: 3,
                        )
                      ],
                    )
                  ],
                ),
                margin: EdgeInsets.only(left: 20, right: 20, top: 15)
              ),
              Container(
                color: Color.fromRGBO(248, 249, 249, 1),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Image.asset("images/elipse127.png", height: 20),
                          flex: 1,
                        ),
                        Expanded(
                          child: Text(
                            "Thick bacon strip",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontFamily: 'Quicksand Bold',
                                color: Color.fromRGBO(63, 63, 63, 1),
                                fontSize: 12
                            ),
                            maxLines: 1,
                            //overflow: TextOverflow.ellipsis,
                          ),
                          flex: 4,
                        ),
                        Expanded(
                          child: Text(
                            "Entrada",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontFamily: 'Quicksand Regular',
                                color: Color.fromRGBO(63, 63, 63, 1),
                                fontSize: 12
                            ),
                            maxLines: 1,
                            //overflow: TextOverflow.ellipsis,
                          ),
                          flex: 3,
                        ),
                        Expanded(
                          child: Text(
                            '\$17000 COP',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontFamily: 'Quicksand Bold',
                                color: Color.fromRGBO(63, 63, 63, 1),
                                fontSize: 12
                            ),
                            maxLines: 1,
                            //overflow: TextOverflow.ellipsis,
                          ),
                          flex: 3,
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(""),
                          flex: 1,
                        ),
                        Expanded(
                          child: Text(
                            "Tocineta ahumada y caramelizada",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontFamily: 'Quicksand Regular',
                                color: Color.fromRGBO(63, 63, 63, 1),
                                fontSize: 12
                            ),
                            maxLines: 1,
                            //overflow: TextOverflow.ellipsis,
                          ),
                          flex: 7,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Image.asset("images/hat.png", height: 15,),
                              Container(
                                child: Text(
                                    widget.restaurant.scoreFoodie,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'Quicksand Regular',
                                        color: Color.fromRGBO(63, 63, 63, 1),
                                        fontSize: 12
                                    )
                                ),
                                margin: EdgeInsets.only(right: 5),
                              ),
                              Image.asset("images/cup.png", height: 15,),
                              Container(
                                child: Text(
                                    widget.restaurant.scoreUser,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'Quicksand Regular',
                                        color: Color.fromRGBO(63, 63, 63, 1),
                                        fontSize: 12
                                    )
                                ),
                                margin: EdgeInsets.only(left: 5),
                              )
                            ]
                          ),
                          flex: 3,
                        )
                      ],
                    )
                  ],
                ),
                margin: EdgeInsets.only(left: 20, right: 20, top: 15)
              ),
              Container(
                color: Color.fromRGBO(248, 249, 249, 1),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Image.asset("images/elipse127.png", height: 20),
                          flex: 1,
                        ),
                        Expanded(
                          child: Text(
                            "Thick bacon strip",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontFamily: 'Quicksand Bold',
                                color: Color.fromRGBO(63, 63, 63, 1),
                                fontSize: 12
                            ),
                            maxLines: 1,
                            //overflow: TextOverflow.ellipsis,
                          ),
                          flex: 4,
                        ),
                        Expanded(
                          child: Text(
                            "Entrada",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontFamily: 'Quicksand Regular',
                                color: Color.fromRGBO(63, 63, 63, 1),
                                fontSize: 12
                            ),
                            maxLines: 1,
                            //overflow: TextOverflow.ellipsis,
                          ),
                          flex: 3,
                        ),
                        Expanded(
                          child: Text(
                            '\$17000 COP',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontFamily: 'Quicksand Bold',
                                color: Color.fromRGBO(63, 63, 63, 1),
                                fontSize: 12
                            ),
                            maxLines: 1,
                            //overflow: TextOverflow.ellipsis,
                          ),
                          flex: 3,
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(""),
                          flex: 1,
                        ),
                        Expanded(
                          child: Text(
                            "Tocineta ahumada y caramelizada",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontFamily: 'Quicksand Regular',
                                color: Color.fromRGBO(63, 63, 63, 1),
                                fontSize: 12
                            ),
                            maxLines: 1,
                            //overflow: TextOverflow.ellipsis,
                          ),
                          flex: 7,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Image.asset("images/hat.png", height: 15,),
                              Container(
                                child: Text(
                                    widget.restaurant.scoreFoodie,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'Quicksand Regular',
                                        color: Color.fromRGBO(63, 63, 63, 1),
                                        fontSize: 12
                                    )
                                ),
                                margin: EdgeInsets.only(right: 5),
                              ),
                              Image.asset("images/cup.png", height: 15,),
                              Container(
                                child: Text(
                                    widget.restaurant.scoreUser,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'Quicksand Regular',
                                        color: Color.fromRGBO(63, 63, 63, 1),
                                        fontSize: 12
                                    )
                                ),
                                margin: EdgeInsets.only(left: 5),
                              )
                            ]
                          ),
                          flex: 3,
                        )
                      ],
                    )
                  ],
                ),
                margin: EdgeInsets.only(left: 20, right: 20, top: 15)
              ),
              SizedBox(height: 20.0,),
              Container(
                margin: EdgeInsets.only(right: 20.0, left: 20.0),
                child: Image.asset("images/options.png")
              ),
              Container(
                margin: EdgeInsets.only(right: 20.0, left: 20.0),
                child: Image.asset("images/rate1.png")
              ),
              Container(
                margin: EdgeInsets.only(right: 20.0, left: 20.0),
                child: Image.asset("images/rate.png")
              ),
              SizedBox(height: 20.0,),
              Container(
                margin: EdgeInsets.only(right: 20.0, left: 20.0),
                child: Image.asset("images/comment.png")
              ),
              SizedBox(height: 20.0,),
            ],
          ),
          endDrawer: DrawerState(),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.only(right: 20.0, left: 20.0, top: 8.0, bottom: 8.0),
            child: Container(
              child: RaisedButton(
                color: Color.fromRGBO(250, 0, 60, 1),
                textColor: Colors.white,
                child: Text(
                  "Reservar",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14
                  ),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)
                ),
                onPressed: showMenu,
              ),
              height: 50.0,
            ),
          )
        ),
        onWillPop: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => HomeScreen()
            ),
          );
          return;
        },
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    // TODO: implement afterFirstLayout
setState(() {
          getRestaurant();

});

  }
}