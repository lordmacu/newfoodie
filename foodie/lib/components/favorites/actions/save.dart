import 'package:foodie/components/favorites/models/favorite.dart';

class Save {
  
  save(Map data) {
    Favorite aux = Favorite(
      idFavorite: 837,
      idUser: data['id_user'],
      idRestaurant: data['id_restaurant'],
    );
    aux.save();
  }
}