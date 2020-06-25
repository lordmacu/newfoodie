import 'package:foodie/components/restaurants/models/restaurant.dart';
import 'package:foodie/components/restaurants/models/restaurant_menu.dart';

class Save {
  
  save(Map data) {
    Restaurant aux = Restaurant();
    Restaurant restaurant = aux.encapsulate(data);
    restaurant.save();
  }

  saveMenu(data) {
    RestaurantMenu menu = new RestaurantMenu();
    menu.idRestaurantMenu = data["id"];
    menu.idRestaurant = data["id_restaurant"];
    menu.nameMenu     = data["name_menu"].toString();
    menu.priceMenu    = data["price_menu"].toString();
    menu.recommended  = data["recommended"].toString();
    menu.scoreUser    = data["score_user"].toString();
    menu.scoreFoodie  = data["score_foodie"].toString();
    menu.typeMenu     = data["type_menu"];
    menu.save();
  }
}