
import 'package:flutter/material.dart';
import 'package:sqflite_kullanimi/MODEL/ogrenciler.dart';
import 'package:sqflite_kullanimi/UTILS/database_helper.dart';

class SqfliteKullanimi extends StatefulWidget {
  SqfliteKullanimi({Key key}) : super(key: key);

  @override
  _SqfliteKullanimiState createState() => _SqfliteKullanimiState();
}

class _SqfliteKullanimiState extends State<SqfliteKullanimi> {

  DatabaseHelper databaseHelper;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    databaseHelper=DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    _ekle();

    return Scaffold(
      appBar: AppBar(
        title: Text("Sqflite"),
      ),
      body: Center(child: Text("BOŞ")),
    );
  }
  _ekle() async{
    await databaseHelper.ogrenciEkle(Ogrenci("hasan 1",true));
    await databaseHelper.ogrenciEkle(Ogrenci("hasan 2",true));
    await databaseHelper.ogrenciEkle(Ogrenci("hasan 3",true));
    await databaseHelper.ogrenciEkle(Ogrenci("hasan 4",true));

  }
}
