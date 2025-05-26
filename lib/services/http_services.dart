import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class HttpService {
  static Future<Map<String, dynamic>?> gonderData(File imageFile) async {
    final uri = Uri.parse("http://172.20.10.6:8000/predict");

    final request = http.MultipartRequest('POST', uri);

    final mimeType = lookupMimeType(imageFile.path)?.split('/');
    if (mimeType == null || mimeType.length != 2) {
      print("Dosya türü tanınamadı.");
      return null;
    }

    request.files.add(await http.MultipartFile.fromPath(
      'file',
      imageFile.path,
      contentType: MediaType(mimeType[0], mimeType[1]),
    ));

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final decoded = jsonDecode(responseBody);
        final prediction = decoded['prediction'];

        if (prediction == null) {
          print("Prediction verisi yok.");
          return null;
        }

        // predict sonucuyla ilaç verisi al
        final ilacUri = Uri.parse("http://172.20.10.6:8000/ilac/$prediction");
        final ilacResponse = await http.get(ilacUri);

        if (ilacResponse.statusCode == 200) {
          final ilacData = jsonDecode(ilacResponse.body);

          final uyumsuzList = ilacData['uyumsuz_ilaclar'] as List<dynamic>;
          final uyumsuzIsimler = uyumsuzList
              .map((item) => item['uyumsuz_ilac_ismi'].toString())
              .toList();

          return {
            "prediction": prediction,
            "confidence": decoded['confidence'],
            "ilac": ilacData['ilac'],
            "uyumsuz_ilaclar": uyumsuzIsimler,
          };
        } else {
          print("İlaç verisi alınamadı: ${ilacResponse.statusCode}");
          return null;
        }
      } else {
        print("Predict isteği başarısız: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("İstek gönderilirken hata oluştu: $e");
      return null;
    }
  }

}

