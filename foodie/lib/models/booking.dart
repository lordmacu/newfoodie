
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Booking {
  final int idBooking;
  final int idUser;
  final int idRestaurant;
  final int initialDate;
  final int finalDate;
  final String documentId;
  final int numberPersons;
  final String paymentMethod;
  final String bookingValue;
  final String personValue;

  Booking({
    this.idBooking,
    this.idUser,
    this.idRestaurant,
    this.initialDate,
    this.finalDate,
    this.documentId,
    this.numberPersons,
    this.paymentMethod,
    this.bookingValue,
    this.personValue
  });

  Map<String, dynamic> toMap() {
    return {
      "id_booking": this.idBooking,
      "id_user": this.idUser,
      "id_restaurant": this.idRestaurant,
      "initial_date": this.initialDate,
      "final_date": this.finalDate,
      "document_id": this.documentId,
      "number_persons": this.numberPersons,
      "payment_method": this.paymentMethod,
      "booking_value": this.bookingValue,
      "person_value": this.personValue
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
      'booking',
      this.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Booking>> getAll() async {
    final Database db = await this.getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('booking');

    return List.generate(maps.length, (i) {
      return encapsulate(maps[i]);
    });
  }

  Future<Booking> getOneById(int idBooking) async {
    final Database db = await this.getDatabase();
    var queryResult = await db.query(
      'booking',
      where: "id_booking = ?",
      whereArgs: [idBooking]
    );

    Map map = queryResult.first;
    if (!queryResult.isNotEmpty) {
      return null;
    }

    return encapsulate(map);
  }

  Future<List<Booking>> getByRestaurantId(int idRestaurant) async {
    final Database db = await this.getDatabase();
    var queryResult = await db.query(
      'booking',
      where: "id_restaurant = ?",
      whereArgs: [idRestaurant]
    );

    final List<Map<String, dynamic>> maps = queryResult;

    return List.generate(maps.length, (i) {
      return encapsulate(maps[i]);
    });
  }

  Future<List<Booking>> getByUserId(int idUser) async {
    final Database db = await this.getDatabase();
    var queryResult = await db.query(
      'booking',
      where: "id_user = ?",
      whereArgs: [idUser]
    );

    final List<Map<String, dynamic>> maps = queryResult;

    return List.generate(maps.length, (i) {
      return encapsulate(maps[i]);
    });
  }

  Booking encapsulate(Map map) {
    return Booking(
      idBooking: map['id_booking'],
      idUser: map["id_user"],
      idRestaurant: map['id_restaurant'],
      initialDate: map['initial_date'],
      finalDate: map['final_date'],
      documentId: map['document_id'],
      numberPersons: map['number_persons'],
      paymentMethod: map['payment_method'],
      bookingValue: map['booking_value'],
      personValue: map['person_value']
    );
  }
}