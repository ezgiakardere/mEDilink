import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final String isim;
  final String prospektus;
  final String etkenMadde;
  final List<String> uyumsuzIlaclar;

  const ResultPage({
    Key? key,
    required this.isim,
    required this.prospektus,
    required this.etkenMadde,
    required this.uyumsuzIlaclar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("İlaç Bilgisi"),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isim,
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.teal[800]),
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Etken Maddeler:",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 6),
                    Text(
                      etkenMadde,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Prospektüs:",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 6),
                    Text(
                      prospektus,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Uyumsuz İlaçlar",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    uyumsuzIlaclar.isEmpty
                        ? Text(
                      "Uyumsuz ilaç bulunmamaktadır.",
                      style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                    )
                        : Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: uyumsuzIlaclar
                          .map(
                            (ilac) => Chip(
                          label: Text(ilac),
                          backgroundColor: Colors.red[100],
                          labelStyle: TextStyle(color: Colors.red[900]),
                        ),
                      )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
