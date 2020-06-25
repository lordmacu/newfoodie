import 'package:foodie/components/favorites/actions/save.dart';
import 'package:foodie/components/favorites/models/favorite.dart';

class FavoritesManager {
  Future<Favorite> getByRestaurantId(int id) async {
    Favorite favorite = new Favorite();
    return await favorite.getByRestaurantId(id);
  }

  Future<Favorite> getByUserIdAndRestaurantId(int idUser, int idRestaurant) async {
    Favorite favorite = new Favorite();
    return await favorite.getByUserIdAndRestaurantId(idUser, idRestaurant);
  }

  Future<List<Favorite>> getAll() async {
    Favorite restaurant = new Favorite();
    return await restaurant.getAll();
  }

  save(Map favorite) {
    Save save = new Save();
    save.save(favorite);
  }
  
}