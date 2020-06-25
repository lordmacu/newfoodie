import 'package:foodie/views/view_models/restaurantMenu.dart';

class Restaurant
{
  int id;
  String nameRestaurant;
  String scoreFoodie;
  String scoreUser;
  String address;
  String schedule;
  int idCity;
  String typeFood;
  String imageOne;
  String imageTwo;
  int priceAverage;
  String description;
  String latitude;
  String longitude;
  int capacity;
  String atmosphere;


  @override
  String toString() {
    return 'Restaurant{id: $id, nameRestaurant: $nameRestaurant, scoreFoodie: $scoreFoodie, scoreUser: $scoreUser, address: $address, schedule: $schedule, idCity: $idCity, typeFood: $typeFood, imageOne: $imageOne, imageTwo: $imageTwo, priceAverage: $priceAverage, description: $description, latitude: $latitude, longitude: $longitude, capacity: $capacity, atmosphere: $atmosphere, reservation: $reservation, videos: $videos, imageMenu: $imageMenu, imagesPlace: $imagesPlace, mondayStart: $mondayStart, mondayEnd: $mondayEnd, mondaytwoStart: $mondaytwoStart, mondaytwoEnd: $mondaytwoEnd, tuesdayStart: $tuesdayStart, tuesdayEnd: $tuesdayEnd, tuesdaytwoStart: $tuesdaytwoStart, tuesdaytwoEnd: $tuesdaytwoEnd, wednesdayStart: $wednesdayStart, wednesdayEnd: $wednesdayEnd, wednesdaytwoStart: $wednesdaytwoStart, wednesdaytwoEnd: $wednesdaytwoEnd, thursdayStart: $thursdayStart, thursdayEnd: $thursdayEnd, thursdaytwoStart: $thursdaytwoStart, thursdaytwoEnd: $thursdaytwoEnd, fridayStart: $fridayStart, fridayEnd: $fridayEnd, fridaytwoStart: $fridaytwoStart, fridaytwoEnd: $fridaytwoEnd, saturdayStart: $saturdayStart, saturdayEnd: $saturdayEnd, saturdaytwoStart: $saturdaytwoStart, saturdaytwoEnd: $saturdaytwoEnd, sundayStart: $sundayStart, sundayEnd: $sundayEnd, sundaytwoStart: $sundaytwoStart, sundaytwoEnd: $sundaytwoEnd, holidayStart: $holidayStart, holidayEnd: $holidayEnd, holidaytwoStart: $holidaytwoStart, holidaytwoEnd: $holidaytwoEnd, state: $state, images: $images, placeImages: $placeImages, menus: $menus}';
  }
 
  int reservation;
  String videos;
  String imageMenu;
  String imagesPlace;
  String mondayStart;
  String mondayEnd;
  String mondaytwoStart;
  String mondaytwoEnd;
  String tuesdayStart;
  String tuesdayEnd;
  String tuesdaytwoStart;
  String tuesdaytwoEnd;
  String wednesdayStart;
  String wednesdayEnd;
  String wednesdaytwoStart;
  String wednesdaytwoEnd;
  String thursdayStart;
  String thursdayEnd;
  String thursdaytwoStart;
  String thursdaytwoEnd;
  String fridayStart;
  String fridayEnd;
  String fridaytwoStart;
  String fridaytwoEnd;
  String saturdayStart;
  String saturdayEnd;
  String saturdaytwoStart;
  String saturdaytwoEnd;
  String sundayStart;
  String sundayEnd;
  String sundaytwoStart;
  String sundaytwoEnd;
  String holidayStart;
  String holidayEnd;
  String holidaytwoStart;
  String holidaytwoEnd;
  String state;
  List<String> images;
  List<String> placeImages;
  List<RestaurantMenu> menus;
}