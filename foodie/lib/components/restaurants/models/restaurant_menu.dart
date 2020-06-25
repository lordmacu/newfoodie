
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class RestaurantMenu {

   int idRestaurantMenu;
   int idRestaurant;
   int typeMenu;
   String scoreFoodie;
   String scoreUser;
   String nameMenu;
   String priceMenu;
   String description;
   String recommended;

  RestaurantMenu({
    this.idRestaurantMenu,
    this.idRestaurant,
    this.typeMenu,
    this.scoreFoodie,
    this.scoreUser,
    this.nameMenu,
    this.priceMenu,
    this.description,
    this.recommended
  });

  Map<String, dynamic> toMap() {
    return {
      "id_restaurant_menu": this.idRestaurantMenu,
      "id_restaurant": this.idRestaurant,
      "type_menu": this.typeMenu,
      "score_foodie": this.scoreFoodie,
      "score_user": this.scoreUser,
      "name_menu": this.nameMenu,
      "price_menu": this.priceMenu,
      "description": this.description,
      "recommended": this.recommended
    };
  }

  getDatabase() async {
     Future<Database> database = openDatabase(
      join(await getDatabasesPath(), 'foodie_database.db'),
    );
    return await database;
  }

  Future<void> save() async {
    var db = await this.getDatabase();
    await db.insert(
      'restaurant_menu',
      this.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<RestaurantMenu>> getAll() async {
    final Database db = await this.getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('favorite');

    return List.generate(maps.length, (i) {
      return RestaurantMenu(
        idRestaurantMenu: maps[i]['id_restaurant_menu'],
        idRestaurant: maps[i]['id_restaurant'],
        typeMenu: maps[i]['type_menu'],
        scoreFoodie: maps[i]['score_foodie'],
        scoreUser: maps[i]['score_user'],
        nameMenu: maps[i]['name_menu'],
        priceMenu: maps[i]['price_menu'],
        description: maps[i]['description'],
        recommended: maps[i]['recommended'],
      );
    });
  }

  Future<List<RestaurantMenu>> getByRestaurantId(int idRestaurant) async {
    final Database db = await this.getDatabase();
    var queryResult = await db.query(
      'restaurant_menu',
      where: "id_restaurant = ?",
      whereArgs: [idRestaurant]
    );

    if (!queryResult.isNotEmpty) {
      return null;
    }
    final List<Map<String, dynamic>> maps = queryResult;

    return List.generate(maps.length, (i) {
      return RestaurantMenu(
        idRestaurantMenu: maps[i]['id_restaurant_menu'],
        idRestaurant: maps[i]['id_restaurant'],
        typeMenu: maps[i]['type_menu'],
        scoreFoodie: maps[i]['score_foodie'],
        scoreUser: maps[i]['score_user'],
        nameMenu: maps[i]['name_menu'],
        priceMenu: maps[i]['price_menu'],
        description: maps[i]['description'],
        recommended: maps[i]['recommended'],
      );
    });
  }
}