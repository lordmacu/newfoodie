
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class User {

  final int idUser;
  final int facebookId;
  final String facebookToken;
  final int googleId;
  final String googleToken;
  final String profilePicture;
  final String profilePictureBase64;
  final String nickName;
  final String email;
  final String documentType;
  final String phone;
  final String cellPhone;
  final String password;

  User({
    this.idUser,
    this.facebookId,
    this.facebookToken,
    this.googleId,
    this.googleToken,
    this.profilePicture,
    this.profilePictureBase64,
    this.nickName,
    this.email,
    this.documentType,
    this.phone,
    this.cellPhone,
    this.password
  });

  Map<String, dynamic> toMap() {
    return {
      "id_user": this.idUser,
      "facebook_id": this.facebookId,
      "facebook_token": this.facebookToken,
      "google_id": this.googleId,
      "google_token": this.googleToken,
      "profile_picture": this.profilePicture,
      "profile_base64": this.profilePictureBase64,
      "nickname": this.nickName,
      "email": this.email,
      "document_type": this.documentType,
      "phone": this.phone,
      "cell_phone": this.cellPhone,
      "password": this.password
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
      'user',
      this.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<User>> getAll() async {
    final Database db = await this.getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('favorite');

    return List.generate(maps.length, (i) {
      return encapsulate(maps[i]);
    });
  }

  Future<User> getById(int idUser) async {
    final Database db = await this.getDatabase();
    var queryResult = await db.query(
      'user',
      where: "id_user = ?",
      whereArgs: [idUser]
    );

    Map map = queryResult.first;
    if (!queryResult.isNotEmpty) {
      return null;
    }

    return encapsulate(map);
  }

  User encapsulate(Map data) {
    return User(
      idUser: data['id_user'],
      facebookId: data['facebook_id'],
      facebookToken: data['facebook_token'],
      googleId: data['google_id'],
      googleToken: data['google_token'],
      profilePicture: data['profile_picture'],
      profilePictureBase64: data['profile_base64'],
      nickName: data['nick_name'],
      email: data['email'],
      documentType: data['document_type'],
      phone: data['phone'],
      cellPhone: data['cell_phone'],
      password: data['password'],
    );
  }
}