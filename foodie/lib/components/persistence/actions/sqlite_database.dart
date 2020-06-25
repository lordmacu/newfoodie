import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqliteDatabase {
  
  createTables() async {
    final Future<Database> database = openDatabase(
      // Establece la ruta a la base de datos.
      join(await getDatabasesPath(), 'foodie_database.db'),
      // Cuando la base de datos se crea por primera vez, crea una tabla para almacenar dogs
      onCreate: (db, version) {
        
      },
      onOpen: (db) {
        
        bool delete = true;
        if (delete) {
          print("execute key");
          db.execute("DROP TABLE IF EXISTS user");
          db.execute("DROP TABLE IF EXISTS booking");
          db.execute("DROP TABLE IF EXISTS favorite");
          db.execute("DROP TABLE IF EXISTS restaurant");
          db.execute("DROP TABLE IF EXISTS account_holder");
          db.execute("DROP TABLE IF EXISTS restaurant_menu");
          print("tables deleted");
        }

        db.execute(
          """
          CREATE TABLE IF NOT EXISTS user(
            id_user INTEGER,
            facebook_id INTEGER,
            facebook_token TEXT,
            google_id INTEGER,
            google_token TEXT,
            profile_picture TEXT,
            profile_base64 TEXT,
            nickname TEXT,
            email TEXT,
            document_type TEXT,
            phone TEXT,
            cell_phone TEXT,
            password TEXT
          )
          """,
        );

        db.execute(
          """
          CREATE TABLE IF NOT EXISTS restaurant(
            id_restaurant INTEGER PRIMARY KEY,
            id_city INTEGER,
            name_restaurant TEXT,
            score_foodie TEXT, 
            score_user TEXT,
            address TEXT,
            schedule TEXT,
            type_food TEXT,
            image_one TEXT,
            image_two TEXT,
            price_average INTEGER,
            description TEXT,
            latitude TEXT,
            longitude TEXT,
            capacity INTEGER,
            atmosphere TEXT,
            reservation INTEGER,
            videos TEXT,
            images TEXT,
            image_menu TEXT,
            image_place TEXT,
            monday_start TEXT,
            monday_end TEXT,
            monday_two_start TEXT,
            monday_two_end TEXT,
            tuesday_start TEXT,
            tuesday_end TEXT,
            tuesday_two_start TEXT,
            tuesday_two_end TEXT,
            wednesday_start TEXT,
            wednesday_end TEXT,
            wednesday_two_start TEXT,
            wednesday_two_end TEXT,
            thursday_start TEXT,
            thursday_end TEXT,
            thursday_two_start TEXT,
            thursday_two_end TEXT,
            friday_start TEXT,
            friday_end TEXT,
            friday_two_start TEXT,
            friday_two_end TEXT,
            saturday_start TEXT,
            saturday_end TEXT,
            saturday_two_start TEXT,
            saturday_two_end TEXT,
            sunday_start TEXT,
            sunday_end TEXT,
            sunday_two_start TEXT,
            sunday_two_end TEXT,
            holiday_start TEXT,
            holiday_end TEXT,
            holiday_two_start TEXT,
            holiday_two_end TEXT,
            state INTEGER
          )
          """,
        );
  
        db.execute(
          """
          CREATE TABLE IF NOT EXISTS favorite(
            id_favorite INTEGER PRIMARY KEY AUTOINCREMENT,
            id_user INTEGER,
            id_restaurant INTEGER,
            FOREIGN KEY(id_user) REFERENCES user(id_user),
            FOREIGN KEY(id_restaurant) REFERENCES restaurant(id_restaurant)
          )
          """,
        );

        db.execute(
          """
          CREATE TABLE IF NOT EXISTS restaurant_menu(
            id_restaurant_menu INTEGER PRIMARY KEY,
            id_restaurant INTEGER,
            type_menu INTEGER,
            score_foodie TEXT,
            score_user TEXT,
            name_menu TEXT,
            price_menu TEXT,
            description TEXT,
            recommended TEXT,
            FOREIGN KEY(id_restaurant) REFERENCES restaurant(id_restaurant)
          )
          """,
        );

        db.execute(
          """
          CREATE TABLE IF NOT EXISTS booking(
            id_booking INTEGER PRIMARY KEY,
            id_user INTEGER,
            id_restaurant INTEGER,
            initial_date INTEGER,
            final_date INTEGER,
            document_id TEXT,
            number_persons INTEGER,
            payment_method TEXT,
            booking_value TEXT,
            person_value TEXT,
            FOREIGN KEY(id_user) REFERENCES user(id_user),
            FOREIGN KEY(id_restaurant) REFERENCES restaurant(id_restaurant)
          )
          """,
        );

        db.execute(
          """
          CREATE TABLE IF NOT EXISTS account_holder(
            id_account_holder INTEGER PRIMARY KEY,
            id_booking INTEGER,
            name TEXT, 
            date INTEGER,
            document_id TEXT,
            FOREIGN KEY(id_booking) REFERENCES booking(id_booking)
          )
          """,
        );
        
      },
      // Establece la versión. Esto ejecuta la función onCreate y proporciona una
      // ruta para realizar actualizacones y defradaciones en la base de datos.
      version: 4,
    );
    return await database;
  }
}