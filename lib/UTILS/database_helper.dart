import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_kullanimi/MODEL/ogrenciler.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

//sütun adları string olarak tnımlanır.
  String _ogrenciTablo = "ogrenci";
  String _columnId = "id";
  String _columnIsim = "ad_soyad";
  String _columnAktif = "aktif";

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      print("database helper BOOŞ");
      _databaseHelper = DatabaseHelper._internal();
      return _databaseHelper;
    }
    else{
      print("database helper boş değil");
      return _databaseHelper;
    }

  }

  Future<Database>  _getDatabase() async {
    if (_database == null) {
      print("data nesnesi booş. oluşturluyor");
      _database = await _initializeDatabase();
      return _database;
    }else{

      print("data nesnesi booş DEĞİL");
      return _database;

    }
  }

  _initializeDatabase() async {
    Directory klasor = await getApplicationDocumentsDirectory();
    String path = join(klasor.path, "ogrenci.db");
    //String path = klasor.path+"ogrenci.db";
    print("olusan veritabanının tam yolu: $path");
    var ogrenciDB = await openDatabase(path, version: 1, onCreate: _createDB);
    return ogrenciDB;
  }

  Future _createDB(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $_ogrenciTablo ($_columnId INTEGER PRIMARY KEY AUTOINCREMENT, $_columnIsim TEXT, $_columnAktif TEXT)");
  }

  Future<int> ogrenciEkle(Ogrenci ogrenci) async {
    var db = await _getDatabase();
   var sonuc = await db.insert(_ogrenciTablo, ogrenci.toMap());
    return sonuc;
  }

  Future<List<Map<String, dynamic>>> tumOgrenciler() async{
    var db = await _getDatabase();
    var sonuc =await db.query(_ogrenciTablo, orderBy: "$_columnId DESC");
    return sonuc;
  }
}
