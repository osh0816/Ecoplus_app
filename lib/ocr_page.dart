import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:excel/excel.dart';
import 'ocr_service.dart';
import 'carbon_products.dart';
import 'ecograde.dart';

class OcrPage extends StatefulWidget {
  @override
  _OcrPageState createState() => _OcrPageState();
}

class _OcrPageState extends State<OcrPage> {
  final ImagePicker _picker = ImagePicker();
  String _recognizedText = '';
  List<String> _productInfo = [];
  File? _pickedImageFile; // 선택된 이미지 파일을 저장할 변수
  OCRService _ocrService = OCRService(
    apiUrl: 'https://9afsf4zmco.apigw.ntruss.com/custom/v1/35919/40cdfd691a779744708be0365b98ceee72bbdcba33b799f5734f2200b4b40776/general',
    secretKey: 'dnR5aGF2YnBXakRXSnJ4dkRUVk5BTHdLeU9ZUGhsZmc=',
  );

  Future<void> _performOCR() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      try {
        var ocrResult = await _ocrService.extractTextFromImage(image.path);
        var recognizedText = '';
        for (var img in ocrResult['images']) {
          for (var field in img['fields']) {
            recognizedText += field['inferText'] + ' ';
          }
        }

        // 인식된 텍스트를 상태에 저장
        setState(() {
          _recognizedText = recognizedText.trim();
          _pickedImageFile = File(image.path); // 선택된 이미지 업데이트
        });

        // 디버깅을 위해 OCR 결과를 출력
        print("OCR 결과: $_recognizedText");

        // 엑셀 파일을 읽고 OCR 텍스트와 비교하는 부분
        var productNames = await _loadProductNamesFromExcel();
        var bestMatches = _calculateSimilarity(_recognizedText, productNames);

        // 매칭 결과를 상태에 저장
        setState(() {
          _productInfo = bestMatches;
        });
      } catch (e) {
        setState(() {
          _productInfo = ['오류가 발생했습니다: $e'];
        });
      }
    }
  }

  Future<List<String>> _loadProductNamesFromExcel() async {
    ByteData data = await rootBundle.load('assets/Environmental_Performance_Mark_Validation_Product_List_final1.xlsx');
    var bytes = data.buffer.asUint8List();
    var excel = Excel.decodeBytes(bytes);

    List<String> productNames = [];
    for (var table in excel.tables.keys) {
      var sheet = excel.tables[table]!;
      for (var row in sheet.rows.skip(5)) {
        var productName = row[3]?.value.toString() ?? '';
        if (productName.isNotEmpty) {
          productNames.add(productName);
        }
      }
    }
    return productNames;
  }

  Set<String> _getProductWordSet(String text) {
    Set<String> wordSet = {};
    String cleanedText = text.replaceAll(RegExp(r'\[.*?\]'), '');
    final matches = RegExp(r'([^\[\],\s]+)').allMatches(cleanedText);
    for (var match in matches) {
      wordSet.add(match.group(0)!);
    }
    return wordSet;
  }

  double _calculateContainmentSimilarity(Set<String> ocrWords, Set<String> productWords) {
    int matchCount = 0;
    for (var word in productWords) {
      if (ocrWords.contains(word)) {
        matchCount++;
      }
    }
    return matchCount / productWords.length;
  }

  List<String> _calculateSimilarity(String ocrText, List<String> productNames) {
    var ocrWords = _getProductWordSet(ocrText);
    List<String> bestMatches = [];
    double bestSimilarity = 0.0;

    for (var productName in productNames) {
      var productWords = _getProductWordSet(productName);
      var similarity = _calculateContainmentSimilarity(ocrWords, productWords);

      if (similarity > bestSimilarity) {
        bestSimilarity = similarity;
        bestMatches = [productName];
      } else if (similarity == bestSimilarity) {
        bestMatches.add(productName);
      }
    }

    return bestMatches.map((match) => '$match \n (유사도: ${(bestSimilarity * 100).toStringAsFixed(2)}%)').toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OCR API Page'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (_pickedImageFile != null) ...[
                Image.file(
                  _pickedImageFile!,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 20), // 이미지와 버튼 사이 공간 추가
              ],
              ElevatedButton(
                onPressed: _performOCR,
                child: Text(
                  'Select Image from Gallery',
                  style: TextStyle(fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                ),
              ),
              SizedBox(height: 20),
              if (_recognizedText.isEmpty)
                Text(
                  '사진을 선택하세요',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                )
              else ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0), // 양쪽 공백 추가
                  child: Text(
                    '[인식된 텍스트]\n: $_recognizedText',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 20),
                if (_productInfo.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0), // 양쪽 공백 추가
                    child: Text(
                      '[인식된 제품명]',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                Column(
                  children: _productInfo.asMap().entries.map((entry) {
                    final index = entry.key + 1;
                    final product = entry.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0), // 양쪽 공백 추가
                      child: Text(
                        '$index. $product',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }).toList(),
                ),
              ],
              SizedBox(height: 20),
              if (_recognizedText.isNotEmpty) ...[
                ElevatedButton(
                  onPressed: () {
                    if (_productInfo.isNotEmpty) {
                      List<String> numberedProductNames = _productInfo
                          .asMap()
                          .entries
                          .map((entry) => '${entry.key + 1}. ${entry.value.split(' (유사도')[0]}')
                          .toList();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CarbonProductsPage(
                            recognizedProduct: numberedProductNames.join('\n'),
                          ),
                        ),
                      );
                    }
                  },
                  child: Text(
                    '탄소발자국 비교',
                    style: TextStyle(fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  ),
                ),
                SizedBox(height: 20), // 버튼과 버튼 사이 공간 추가
                ElevatedButton(
                  onPressed: () {
                    if (_productInfo.isNotEmpty) {
                      List<String> numberedProductNames = _productInfo
                          .asMap()
                          .entries
                          .map((entry) => '${entry.key + 1}. ${entry.value.split(' (유사도')[0]}')
                          .toList();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailPage(
                            recognizedProduct: numberedProductNames.join('\n'),
                          ),
                        ),
                      );
                    }
                  },
                  child: Text(
                    '7대 에코 GRADE',
                    style: TextStyle(fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  ),
                ),
                SizedBox(height: 20), // 버튼 아래 공간 추가
              ],
            ],
          ),
        ),
      ),
    );
  }
}
