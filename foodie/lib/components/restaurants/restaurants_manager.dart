
import 'package:foodie/components/restaurants/actions/save.dart';
import 'package:foodie/components/restaurants/models/restaurant.dart';
import 'package:foodie/components/restaurants/models/restaurant_menu.dart';

class RestaurantsManager {

  Future<Restaurant> getById(int id) async {
    Restaurant restaurant = new Restaurant();
    return await restaurant.getById(id);
  }

  Future<List<Restaurant>> getByCityId(int id) async {
    Restaurant restaurant = new Restaurant();
    return await restaurant.getByCityId(id);
  }

  Future<List<RestaurantMenu>> getMenusByRestaurantId(int id) async {
    RestaurantMenu restaurantMenu = new RestaurantMenu();
    return await restaurantMenu.getByRestaurantId(id);
  }

  Future<List<Restaurant>> getAll() async {
    Restaurant restaurant = new Restaurant();
    return await restaurant.getAll();
  }

  encapsulate(item) {
    Restaurant restaurant = new Restaurant();
    return restaurant.encapsulate(item);
  }

  save(Map restaurant) {
    Save save = new Save();
    save.save(restaurant);
  }

  saveMenuItem(Map menuItem) {
    Save save = new Save();
    save.saveMenu(menuItem);
  }
}