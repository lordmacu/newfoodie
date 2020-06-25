
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Favorite {

  final int idFavorite;
  final int idUser;
  final int idRestaurant;

  Favorite({
    this.idFavorite,
    this.idUser,
    this.idRestaurant
  });

  Map<String, dynamic> toMap() {
    return {
      "id_favorite": this.idFavorite,
      "id_user": this.idUser,
      "id_restaurant": this.idRestaurant
    };
  }

  getDatabase() async {
    final Future<Database> database = openDatabase(
      join(await getDatabasesPath(), 'foodie_database.db'),
    );
    return await database;
  }

  Future<void> save() async {
    var db = await this.getDatabase();
    await db.insert(
      'favorite',
      this.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Favorite> getByUserId(int idUser) async {
    final Database db = await this.getDatabase();
    var queryResult = await db.query(
      'favorite',
      where: "id_user = ?",
      whereArgs: [idUser]
    );

    if (!queryResult.isNotEmpty) {
      return null;
    }
    Map map = queryResult.first;
    
    return Favorite(
      idFavorite: map['id_favorite'],
      idUser: map["id_user"],
      idRestaurant: map['id_restaurant'],
    );
  }

  Future<Favorite> getByUserIdAndRestaurantId(int idUser, int idRestaurant) async {
    final Database db = await this.getDatabase();
    var queryResult = await db.query(
      'favorite',
      where: "id_user=? and id_restaurant=?",
      whereArgs: [
        idUser,
        idRestaurant
      ]
    );

    if (!queryResult.isNotEmpty) {
      return null;
    }
    Map map = queryResult.first;
    
    return Favorite(
      idFavorite: map['id_favorite'],
      idUser: map["id_user"],
      idRestaurant: map['id_restaurant'],
    );
  }

  Future<Favorite> getByRestaurantId(int idRestaurant) async {
    final Database db = await this.getDatabase();
    var queryResult = await db.query(
      'favorite',
      where: "id_restaurant = ?",
      whereArgs: [idRestaurant]
    );

    if (!queryResult.isNotEmpty) {
      return null;
    }
    Map map = queryResult.first;
    
    return Favorite(
      idFavorite: map['id_favorite'],
      idUser: map["id_user"],
      idRestaurant: map['id_restaurant'],
    );
  }

  Future<List<Favorite>> getAll() async {
    final Database db = await this.getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('favorite');

    return List.generate(maps.length, (i) {
      return Favorite(
        idFavorite: maps[i]['id_favorite'],
        idUser: maps[i]['id_user'],
        idRestaurant: maps[i]['id_restaurant'],
      );
    });
  }
}