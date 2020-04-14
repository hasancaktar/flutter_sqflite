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
  var formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  String isim = "";
  bool aktiflik = false;
  List<Ogrenci> tumOgrenciListesi;
  var _controller = TextEditingController();
  int id=0;
  int tiklanilanID=0;

  @override
  void initState() {


    super.initState();

    tumOgrenciListesi = List<Ogrenci>();
    databaseHelper = DatabaseHelper();
    databaseHelper.tumOgrenciler().then((mapListesi) {
      for (Map okunanMap in mapListesi) {
        tumOgrenciListesi.add((Ogrenci.fromMap(okunanMap)));
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    //_ekle();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Hızlı Görev Defteri"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      //initialValue: ,
                      controller: _controller,
                      decoration: InputDecoration(
                        labelText: "Görevini yaz",
                        border: OutlineInputBorder(),
                      ),
                      validator: (girilenDeger) {
                        if (girilenDeger.length < 3) {
                          return "En az 3 karakter gir";
                        }
                      },
                      onSaved: (girilenIsim) {
                        setState(() {
                          isim = girilenIsim;
                        });
                      },
                    ),
                  ),
                  SwitchListTile(
                      title: Text("Tamamlandı mı"),
                      value: aktiflik,
                      onChanged: (aktifMi) {
                        setState(() {
                          aktiflik = aktifMi;
                        });
                      })
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    if (formKey.currentState.validate()) {
                      formKey.currentState.save();
                      _ogrenciEkle(Ogrenci(isim, aktiflik));
                    }
                  },
                  child: Text("Kaydet"),
                  color: Colors.orange,
                ),
                RaisedButton(
                  onPressed: () {
                    if (formKey.currentState.validate()) {
                      formKey.currentState.save();
                      _ogrenciGuncelle(Ogrenci.withID(id,isim, aktiflik), tiklanilanID);
                    }
                  },
                  child: Text("Güncelle"),
                  color: Colors.yellow,
                ),

                RaisedButton(
                  onPressed: () {
                    _tumOgrenciKayitlariniSil();
                  },
                  color: Colors.red,
                  child: Text("Tüm Tabloyu Sil"),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                    color: tumOgrenciListesi[index].aktif == true
                        ? Colors.green.shade200
                        : Colors.red.shade200,
                    child: ListTile(
                      onTap: () {
                        setState(() {
                          isim=tumOgrenciListesi[index].isim;
                          aktiflik=tumOgrenciListesi[index].aktif;
                          _controller.text=isim;
                          id=tumOgrenciListesi[index].id;
                          tiklanilanID=index;
                        });
                      },
                      title: Text(tumOgrenciListesi[index].isim),
                      subtitle: Text(tumOgrenciListesi[index].id.toString()),
                      trailing: GestureDetector(
                        onTap: () {
                          databaseHelper
                              .ogrenciSil(tumOgrenciListesi[index].id)
                              .then((silinenId) {
                            setState(() {
                              tumOgrenciListesi.removeAt(index);
                            });
                          });
                        },
                        child: Icon(Icons.delete),
                      ),
                    ),
                  );
                },
                itemCount: tumOgrenciListesi.length,
              ),
            )
          ],
        ),
      ),
    );
  }

  _ogrenciEkle(Ogrenci ogrenci) async {
    await databaseHelper.ogrenciEkle(ogrenci).then((eklenenInt) => setState(() {
          ogrenci.id = eklenenInt;
          tumOgrenciListesi.insert(0, ogrenci);
        }));
  }

  void _tumOgrenciKayitlariniSil() async {
    await databaseHelper.tumOgrenciTablosunuSil().then(
        (silinenElemanSayisi) => scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text(silinenElemanSayisi.toString() + " kayıt silindi"),
              duration: Duration(seconds: 2),
            )));
    setState(() {
      tumOgrenciListesi.clear();
    });
  }

  _ogrenciGuncelle(Ogrenci ogrenci, int tiklanilanID) async{
    await databaseHelper.ogrenciGuncelle(ogrenci).then((guncellenenInt) {
      setState(() {
        tumOgrenciListesi[tiklanilanID]=ogrenci;

      });
    });
  }

//_ekle() async {
//await databaseHelper.ogrenciEkle(Ogrenci("mehmet", true));
//await databaseHelper.ogrenciEkle(Ogrenci("aslan", true));
//await databaseHelper.ogrenciEkle(Ogrenci("reis", true));
//await databaseHelper.ogrenciEkle(Ogrenci("kaan", true));
//var sonuc = await databaseHelper.tumOgrenciler();
//debugPrint("SONNUC : $sonuc");
//debugPrint("SONNUC :"+ sonuc[1]["ad_soyad"].toString());

//databaseHelper.ogrenciSil(1);
//var sonuc2= await databaseHelper.tumOgrenciler();
//debugPrint("SONUC :::: "+sonuc2[0]["ad_soyad"].toString());
//}
}
