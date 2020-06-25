
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AccountHolder {

  final int idAccountHolder;
  final int idBooking;
  final String name;
  final int date;
  final String documentId;

  AccountHolder({
    this.idAccountHolder,
    this.idBooking,
    this.name,
    this.date,
    this.documentId
  });

  Map<String, dynamic> toMap() {
    return {
      "id_account_holder": this.idAccountHolder,
      "id_booking": this.idBooking,
      "name": this.name,
      "date": this.date,
      "documentId": this.date
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
      'account_holder',
      this.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<AccountHolder> getByIdBooking(int idBooking) async {
    final Database db = await this.getDatabase();
    var queryResult = await db.query(
      'account_holder',
      where: "id_booking = ?",
      whereArgs: [idBooking]
    );

    Map map = queryResult.first;
    if (!queryResult.isNotEmpty) {
      return null;
    }

    return AccountHolder(
      idAccountHolder: map['id_account_holder'],
      idBooking: map['id_booking'],
      name: map['name'],
      date: map['date'],
      documentId: map['document_id']
    );
  }
}