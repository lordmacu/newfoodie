import 'actions/sqlite_database.dart';

class EntityManager {
  createTables() async {
    var createTables = SqliteDatabase();
    return await createTables.createTables();
  }
}