import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AnotationHelper {
  static final String nameTable = "anotation";

  factory AnotationHelper() {
    return _anotationHelper;
  }

  AnotationHelper._internal();

  static final AnotationHelper _anotationHelper = AnotationHelper._internal();

  Database? _db;

  get db async {
    return (_db != null) ? (_db) : (_db = await initDB());
  }

  initDB() async {
    final pathDataBase = await getDatabasesPath();
    final localDataBase = join(pathDataBase, "db_minhas_anotacoes.db");

    var db = await openDatabase(localDataBase, version: 1, onCreate: _onCreate);

    return db;
  }

  _onCreate(Database db, int version) async {
    String sql = "CREATE TABLE $nameTable ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT, "
        "title VARCHAR, "
        "description TEXT, "
        "date DATETIME)";
    await db.execute(sql);
  }

  Future<int> saveAnotation(Anotation anotation) async {
    var dataBase = await db;

    int result = await dataBase.insert(nameTable, anotation.toMap());

    return result;
  }

  recoveryAnotation() async {
    var dataBase = await db;

    String sql = "SELECT * FROM anotation ORDER BY date DESC ";
    List anotations = await dataBase.rawQuery(sql);

    return anotations;
  }
}

class Anotation {
  int? id;
  String? title, description, date;

  Anotation(this.title, this.description, this.date);

  Map toMap() {
    Map<String, dynamic> map = {
      "title": this.title,
      "description": this.description,
      "date": this.date,
    };

    if (this.id != null) {
      map["id"] = this.id;
    }

    return map;
  }

  Anotation.fromMap(Map map) {
    this.id = map["id"];
    this.title = map["title"];
    this.description = map["description"];
    this.date = map["date"];
  }
}
