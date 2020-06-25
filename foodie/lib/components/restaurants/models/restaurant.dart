
import 'dart:convert';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:foodie/components/restaurants/models/restaurant_menu.dart';

class Restaurant
{
  final int idRestaurant;
  final String nameRestaurant;
  final String scoreFoodie;
  final String scoreUser;
  final String address;
  final String schedule;
  final int idCity;
  final String typeFood;
  final String imageOne;
  final String imageTwo;
  final int priceAverage;
  final String description;
  final String latitude;
  final String longitude;
  final int capacity;
  final String atmosphere;
  final int reservation;
  final String videos;
  final String imageMenu;
  final String imagesPlace;
  final String mondayStart;
  final String mondayEnd;
  final String mondaytwoStart;
  final String mondaytwoEnd;
  final String tuesdayStart;
  final String tuesdayEnd;
  final String tuesdaytwoStart;
  final String tuesdaytwoEnd;
  final String wednesdayStart;
  final String wednesdayEnd;
  final String wednesdaytwoStart;
  final String wednesdaytwoEnd;
  final String thursdayStart;
  final String thursdayEnd;
  final String thursdaytwoStart;
  final String thursdaytwoEnd;
  final String fridayStart;
  final String fridayEnd;
  final String fridaytwoStart;
  final String fridaytwoEnd;
  final String saturdayStart;
  final String saturdayEnd;
  final String saturdaytwoStart;
  final String saturdaytwoEnd;
  final String sundayStart;
  final String sundayEnd;
  final String sundaytwoStart;
  final String sundaytwoEnd;
  final String holidayStart;
  final String holidayEnd;
  final String holidaytwoStart;
  final String holidaytwoEnd;
  final String state;
  final String images;

  List<String> imagesList;
  List<String> placeImagesList;

  List<RestaurantMenu> menus;

  Restaurant({
    this.idRestaurant,
    this.nameRestaurant,
    this.scoreFoodie,
    this.scoreUser,
    this.address,
    this.schedule,
    this.idCity,
    this.typeFood,
    this.imageOne,
    this.imageTwo,
    this.priceAverage,
    this.description,
    this.latitude,
    this.longitude,
    this.capacity,
    this.atmosphere,
    this.reservation,
    this.videos,
    this.images,
    this.imageMenu,
    this.imagesPlace,
    this.mondayStart,
    this.mondayEnd,
    this.mondaytwoStart,
    this.mondaytwoEnd,
    this.tuesdayStart,
    this.tuesdayEnd,
    this.tuesdaytwoStart,
    this.tuesdaytwoEnd,
    this.wednesdayStart,
    this.wednesdayEnd,
    this.wednesdaytwoStart,
    this.wednesdaytwoEnd,
    this.thursdayStart,
    this.thursdayEnd,
    this.thursdaytwoStart,
    this.thursdaytwoEnd,
    this.fridayStart,
    this.fridayEnd,
    this.fridaytwoStart,
    this.fridaytwoEnd,
    this.saturdayStart,
    this.saturdayEnd,
    this.saturdaytwoStart,
    this.saturdaytwoEnd,
    this.sundayStart,
    this.sundayEnd,
    this.sundaytwoStart,
    this.sundaytwoEnd,
    this.holidayStart,
    this.holidayEnd,
    this.holidaytwoStart,
    this.holidaytwoEnd,
    this.state,
    this.imagesList,
    this.placeImagesList
  });

  getDatabase() async {
    final Future<Database> database = openDatabase(
      join(await getDatabasesPath(), 'foodie_database.db'),
    );
    return await database;
  }

  Map<String, dynamic> toMap() {
    return {
      "id_restaurant": this.idRestaurant,
      "id_city": this.idCity,
      "name_restaurant": this.nameRestaurant,
      "score_foodie": this.scoreFoodie,
      "score_user": this.scoreUser,
      "address": this.address,
      "schedule": this.schedule,
      "type_food": this.typeFood,
      "image_one": this.imageOne,
      "image_two": this.imageTwo,
      "price_average": this.priceAverage,
      "description": this.description,
      "latitude": this.latitude,
      "longitude": this.longitude,
      "capacity": this.capacity,
      "atmosphere": this.atmosphere,
      "reservation": this.reservation,
      "videos": this.videos,
      "image_menu": this.imageMenu,
      "images": this.images,
      "image_place": this.imagesPlace,
      "monday_start": this.mondayStart,
      "monday_end": this.mondayEnd,
      "monday_two_start": this.mondaytwoStart,
      "monday_two_end": this.mondaytwoEnd,
      "tuesday_start": this.tuesdayStart,
      "tuesday_end": this.tuesdayEnd,
      "tuesday_two_start": this.tuesdaytwoStart,
      "tuesday_two_end": this.tuesdaytwoEnd,
      "wednesday_start": this.wednesdayStart,
      "wednesday_end": this.wednesdayEnd,
      "wednesday_two_start": this.wednesdaytwoStart,
      "wednesday_two_end": this.wednesdaytwoEnd,
      "thursday_start": this.thursdayStart,
      "thursday_end": this.thursdayEnd,
      "thursday_two_start": this.thursdaytwoStart,
      "thursday_two_end": this.thursdaytwoEnd,
      "friday_start": this.fridayStart,
      "friday_end": this.fridayEnd,
      "friday_two_start": this.fridaytwoStart,
      "friday_two_end": this.fridaytwoEnd,
      "saturday_start": this.saturdayStart,
      "saturday_end": this.saturdayEnd,
      "saturday_two_start": this.saturdaytwoStart,
      "saturday_two_end": this.saturdaytwoEnd,
      "sunday_start": this.sundayStart,
      "sunday_end": this.sundayEnd,
      "sunday_two_start": this.sundaytwoStart,
      "sunday_two_end": this.sundaytwoEnd,
      "holiday_start": this.holidayStart,
      "holiday_end": this.holidayEnd,
      "holiday_two_start": this.holidaytwoStart,
      "holiday_two_end": this.holidaytwoEnd,
      "state": this.state
    };
  }

  Future<void> save() async {
    var db = await this.getDatabase();
    await db.insert(
      'restaurant',
      this.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Restaurant>> getAll() async {
    final Database db = await this.getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('restaurant');

    return List.generate(maps.length, (i) {
      return encapsulate(maps[i]);
    });
  }

  Future<Restaurant> getById(final int idRestaurant) async {
    final Database db = await this.getDatabase();
    var queryResult = await db.query(
      'restaurant',
      where: "id_restaurant = ?",
      whereArgs: [idRestaurant]
    );

    if (!queryResult.isNotEmpty) {
      return null;
    }

    Map map = queryResult.first;
    return encapsulate(map);
  }

  Future<List<Restaurant>> getByCityId(final int idCity) async {
    final Database db = await this.getDatabase();
    var queryResult = await db.query(
      'restaurant',
      where: "id_city = ?",
      whereArgs: [idCity]
    );

    final List<Map<String, dynamic>> maps = queryResult;

    return List.generate(maps.length, (i) {
      return encapsulate(maps[i]);
    });
  }

  List<String> resolveImagesList(data) {
    List<String> tmpImageList = [];
    data["images"] != "" ? data["images"].split(",").forEach((item) => tmpImageList.add(item)) : "";
    return tmpImageList;
  }

  List<String> resolvePlaceImagesList(data) {
    List<String> tmpPlaceImageList = [];
    data["images"] != "" ? data["images"].split(",").forEach((item) => tmpPlaceImageList.add(item)) : "";
    return tmpPlaceImageList;
  }

  Restaurant encapsulate(Map data) {

    return Restaurant(
      idRestaurant: data["id_restaurant"],
      nameRestaurant: data["name_restaurant"],
      scoreFoodie: data["score_foodie"],
      scoreUser:  data["score_user"],
      address: data["address"],
      schedule: data["schedule"],
      idCity: data["id_city"],
      typeFood: data["type_food"],
      imageOne: data["image_one"],
      imageTwo: data["image_two"],
      priceAverage: data["price_average"],
      description: data["description"],
      latitude: data["latitude"],
      longitude: data["longitude"],
      capacity:  data["capacity"],
      atmosphere: data["atmosphere"],
      reservation: data["reservation"],
      videos: data["videos"],
      imageMenu: data["image_menu"],
      imagesPlace: data["images_place"],
      mondayStart: data["monday_start"],
      images: data["images"],
      mondayEnd: data["monday_end"],
      mondaytwoStart: data["monday_two_start"],
      mondaytwoEnd: data["monday_two_end"],
      tuesdayStart: data["tuesday_start"],
      tuesdayEnd: data["tuesday_end"],
      tuesdaytwoStart: data["tuesday_two_start"],
      tuesdaytwoEnd: data["tuesday_two_end"],
      wednesdayStart: data["wednesday_start"],
      wednesdayEnd: data["wednesday_end"],
      wednesdaytwoStart: data["wednesday_two_start"],
      wednesdaytwoEnd: data["wednesday_two_end"],
      thursdayStart: data["thursday_start"],
      thursdayEnd: data["thursday_end"],
      thursdaytwoStart: data["thursday_two_start"],
      thursdaytwoEnd: data["thursday_two_end"],
      fridayStart: data["friday_start"],
      fridayEnd: data["friday_end"],
      fridaytwoStart: data["friday_two_start"],
      fridaytwoEnd: data["friday_two_end"],
      saturdayStart: data["saturday_start"],
      saturdayEnd: data["saturday_end"],
      saturdaytwoStart: data["saturday_two_start"],
      saturdaytwoEnd: data["saturday_two_end"],
      sundayStart: data["sunday_start"],
      sundayEnd: data["sunday_end"],
      sundaytwoStart: data["sunday_two_start"],
      sundaytwoEnd: data["sunday_two_end"],
      holidayStart: data["holiday_start"],
      holidayEnd:  data["holiday_end"],
      holidaytwoStart: data["holiday_two_start"],
      holidaytwoEnd: data["holiday_two_end"],
      state: data["state"],
      imagesList: resolveImagesList(data),
      placeImagesList: resolvePlaceImagesList(data)
    );
  }
}