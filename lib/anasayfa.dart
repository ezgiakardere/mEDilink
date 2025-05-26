import 'package:flutter/material.dart';
import 'package:tasarim/renkler.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:tasarim/services/http_services.dart';

import 'ResultPage.dart';


class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> resmiGonder() async {
    if (_image != null) {
      await HttpService.gonderData(_image!);
    } else {
      print('Önce bir resim seçin!');
    }
  }

  Future<void> galeridenResimYukle() async {
    final XFile? selected = await _picker.pickImage(source: ImageSource.gallery);
    if (selected != null) {
      setState(() {
        _image = File(selected.path);
      });
    }
  }

  Future<void> kameradanResimCek() async {
    final XFile? captured = await _picker.pickImage(source: ImageSource.camera);
    if (captured != null) {
      setState(() {
        _image = File(captured.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "mEDilink",
          style: TextStyle(
            color: yaziRenk1,
            fontFamily: "Notoserif",
            fontSize: 26,
            fontWeight: FontWeight.w900,
            letterSpacing: 3,
          ),
        ),
        backgroundColor: anaRenk,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/ekran.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView( // 👈 Taşmaları önlemek için eklendi
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Image.asset("images/logo2.png"),
              ),
              const SizedBox(height: 20),

              // Fotoğraf seçildiyse göster
              if (_image != null)
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(
                        _image!,
                        width: 250,
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),

              // Butonlar
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 30),
                child: Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: galeridenResimYukle,
                      icon: Icon(Icons.photo_library, color: yaziRenk1),
                      label: Text(
                        "Galeriden Seç",
                        style: TextStyle(color: yaziRenk1),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: yaziRenk2,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: kameradanResimCek,
                      icon: Icon(Icons.camera_alt, color: yaziRenk1),
                      label: Text(
                        "Fotoğraf Çek",
                        style: TextStyle(color: yaziRenk1),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: yaziRenk2,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Fotoğraf seçildiyse "Gönder" butonu göster
                    if (_image != null)
                      ElevatedButton.icon(
                        onPressed:  () async {
                          final result = await HttpService.gonderData(_image!);

                          if (result != null) {
                            final ilac = result['ilac'];
                            final uyumsuzIlaclar = List<String>.from(result['uyumsuz_ilaclar'] ?? []);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ResultPage(
                                  isim: ilac['isim'],
                                  prospektus: ilac['prospektus'],
                                  etkenMadde: ilac['etken_madde'],
                                  uyumsuzIlaclar: uyumsuzIlaclar,
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Veri gönderilemedi.")),
                            );
                          }
                        },
                        icon: Icon(Icons.send, color: yaziRenk1),
                        label: Text(
                          "Resmi Gönder",
                          style: TextStyle(color: yaziRenk1),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: yaziRenk2,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
