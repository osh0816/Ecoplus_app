import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class OCRService {
  final String apiUrl;
  final String secretKey;

  OCRService({required this.apiUrl, required this.secretKey});

  Future<Map<String, dynamic>> extractTextFromImage(String imagePath) async {
    var imageBytes = File(imagePath).readAsBytesSync();
    String base64Image = base64Encode(imageBytes);

    var requestJson = {
      'images': [
        {'format': 'jpg', 'name': 'demo', 'data': base64Image}
      ],
      'requestId': DateTime.now().millisecondsSinceEpoch.toString(),
      'version': 'v1',
      'timestamp': DateTime.now().millisecondsSinceEpoch
    };

    String payload = json.encode(requestJson);
    var headers = {
      'X-OCR-SECRET': secretKey,
      'Content-Type': 'application/json'
    };

    var response =
    await http.post(Uri.parse(apiUrl), headers: headers, body: payload);

    if (response.statusCode == 200) {
      print("OCR API 요청 성공: ${response.body}");
      return json.decode(response.body);
    } else {
      print("OCR API 요청 실패: 상태 코드 ${response.statusCode}");
      print("응답 내용: ${response.body}");
      throw Exception('OCR 요청 오류: ${response.body}');
    }
  }
}

// 사용 예시
OCRService _ocrService = OCRService(
  apiUrl: 'YOUR_OCR_API_URL',
  secretKey: 'YOUR_OCR_SECRET_KEY',
);
