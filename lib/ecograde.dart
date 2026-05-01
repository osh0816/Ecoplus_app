import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';
import 'package:flutter/foundation.dart'; // 추가: compute 사용을 위해 import

class ProductDetailPage extends StatefulWidget {
  final String recognizedProduct;

  ProductDetailPage({required this.recognizedProduct});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  List<Map<String, String>> productCategories = [];
  Map<String, double> productValues = {};
  Map<String, double> maxValues = {};
  Map<String, double> minValues = {};
  String? _selectedProduct;
  String? _selectedProductCategory;
  final double spectrumHeight = 30; // 기본 스펙트럼 높이 설정
  final double spectrumPadding = 16.0; // 스펙트럼 양옆 여백 조정 가능
  final double iconSize = 30.0; // 화살표 아이콘 크기 조정 가능
  final IconData arrowIcon = Icons.arrow_drop_down; // 아이콘 변경 가능

  double xOffset = 0.0; // 스펙트럼의 x축 오프셋 (오른쪽으로 10 이동)
  double spectrumWidthFactor = 0.8; // 스펙트럼 너비 비율 조정 가능 (화면 너비의 비율)

  int _currentIndex = 0;
  final List<String> _images = [
    'assets/images/Environmentalmark1.jpg',
    'assets/images/Environmentalmark2.jpg',
    'assets/images/7thcategories.jpg',
  ];

  final Map<String, String> spectrumImages = {
    '자원발자국': 'assets/images/ResourceFootprint.jpg',
    '탄소발자국': 'assets/images/CarbonFootprint.jpg',
    '물발자국': 'assets/images/WaterFootprint.jpg',
    '산성비': 'assets/images/AcidRain.jpg',
    '광화학스모그': 'assets/images/PhotochemicalSmog.jpg',
    '오존층영향': 'assets/images/OzoneLayerImpact.jpg',
    '부영양화': 'assets/images/Eutrophication.jpg',
  };

  @override
  void initState() {
    super.initState();
    _loadExcelData();
  }

  Future<void> _loadExcelData() async {
    try {
      ByteData data = await rootBundle.load("assets/Environmental_Performance_Mark_Validation_Product_List_final1.xlsx");
      var bytes = data.buffer.asUint8List();
      var excel = Excel.decodeBytes(bytes);

      List<String> productNames = widget.recognizedProduct
          .split('\n')
          .where((product) => product.trim().isNotEmpty)
          .map((product) {
        var parts = product.trim().split('. ');
        return parts.length > 1 ? parts[1] : parts[0];
      }).toList();

      // 별도의 isolate에서 Excel 데이터 처리
      final result = await compute(_processExcelData, {'excel': excel, 'productNames': productNames});

      setState(() {
        productCategories = result['productCategories'];
        maxValues = result['maxValues'];
        minValues = result['minValues'];
      });

      print('Product categories loaded: $productCategories');
    } catch (e) {
      print('Error loading Excel file: $e');
    }
  }

  static Map<String, dynamic> _processExcelData(Map<String, dynamic> data) {
    var excel = data['excel'] as Excel;
    var productNames = data['productNames'] as List<String>;

    List<Map<String, String>> productCategories = [];
    Map<String, double> maxValues = {};
    Map<String, double> minValues = {};

    for (var table in excel.tables.keys) {
      var sheet = excel.tables[table]!;
      for (int rowIndex = 0; rowIndex < sheet.rows.length; rowIndex++) {
        var row = sheet.rows[rowIndex];
        var productName = row[3]?.value?.toString() ?? '';
        var category = row[11]?.value?.toString() ?? '';

        if (productNames.contains(productName)) {
          productCategories.add({'name': productName, 'category': category});
        }

        _updateMinMaxValues('자원발자국', _parseDouble(row[4]?.value), maxValues, minValues);
        _updateMinMaxValues('탄소발자국', _parseDouble(row[5]?.value), maxValues, minValues);
        _updateMinMaxValues('오존층영향', _parseDouble(row[6]?.value), maxValues, minValues);
        _updateMinMaxValues('산성비', _parseDouble(row[7]?.value), maxValues, minValues);
        _updateMinMaxValues('부영양화', _parseDouble(row[8]?.value), maxValues, minValues);
        _updateMinMaxValues('광화학스모그', _parseDouble(row[9]?.value), maxValues, minValues);
        _updateMinMaxValues('물발자국', _parseDouble(row[10]?.value), maxValues, minValues);
      }
    }

    return {
      'productCategories': productCategories,
      'maxValues': maxValues,
      'minValues': minValues,
    };
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    try {
      return double.parse(double.parse(value.toString()).toStringAsFixed(6));
    } catch (e) {
      return 0.0;
    }
  }

  static void _updateMinMaxValues(String key, double value, Map<String, double> maxValues, Map<String, double> minValues) {
    if (value == 0) return;

    if (!maxValues.containsKey(key) || value > maxValues[key]!) {
      maxValues[key] = value;
    }

    if (!minValues.containsKey(key) || value < minValues[key]!) {
      minValues[key] = value;
    }
  }

  void _showProductSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('제품 선택'),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.8, // 너비 설정
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: productCategories.map((pc) {
                  return RadioListTile<String>(
                    title: Text(pc['name']!),
                    value: pc['name']!,
                    groupValue: _selectedProduct,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedProduct = value;
                        _selectedProductCategory = pc['category'];
                        productValues.clear();
                      });
                      Navigator.pop(context);
                      _loadSelectedProductData();
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _loadSelectedProductData() async {
    if (_selectedProduct == null) return;

    try {
      ByteData data = await rootBundle.load("assets/Environmental_Performance_Mark_Validation_Product_List_final1.xlsx");
      var bytes = data.buffer.asUint8List();
      var excel = Excel.decodeBytes(bytes);

      for (var table in excel.tables.keys) {
        var sheet = excel.tables[table]!;
        for (int rowIndex = 0; rowIndex < sheet.rows.length; rowIndex++) {
          var row = sheet.rows[rowIndex];
          var productName = row[3]?.value?.toString() ?? '';

          if (productName == _selectedProduct) {
            setState(() {
              productValues['자원발자국'] = _parseDouble(row[4]?.value);
              productValues['탄소발자국'] = _parseDouble(row[5]?.value);
              productValues['오존층영향'] = _parseDouble(row[6]?.value);
              productValues['산성비'] = _parseDouble(row[7]?.value);
              productValues['부영양화'] = _parseDouble(row[8]?.value);
              productValues['광화학스모그'] = _parseDouble(row[9]?.value);
              productValues['물발자국'] = _parseDouble(row[10]?.value);
            });
            break;
          }
        }
      }

      print('Product values loaded: $productValues');
    } catch (e) {
      print('Error loading selected product data: $e');
    }
  }

  Widget _buildSpectrum(String label, double value, String description) {
    double minValue = minValues[label] ?? 0;
    double maxValue = maxValues[label] ?? 1;

    double normalizedValue = (value - minValue) / (maxValue - minValue);
    double screenWidth = MediaQuery.of(context).size.width;
    double spectrumWidth = screenWidth * spectrumWidthFactor;
    double arrowPosition = spectrumPadding + normalizedValue * (spectrumWidth - iconSize); // 아이콘 중앙 기준으로 위치 조정

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.info_outline, size: 18.0),
                onPressed: () {
                  _showInfoDialog(label, description, spectrumImages[label]!); // 각 스펙트럼에 대한 설명과 이미지를 여기에 기입
                },
              ),
              Text(
                '[$label]   ➞   ${value.toStringAsFixed(6)}',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Center(
          child: Stack(
            children: [
              Transform.translate(
                offset: Offset(xOffset, 0), // xOffset 값을 사용하여 스펙트럼의 x축 위치를 조정
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: spectrumPadding),
                  width: spectrumWidth,
                  height: spectrumHeight,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.green, Colors.yellow, Colors.red],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: arrowPosition,
                child: Icon(arrowIcon, size: iconSize, color: Colors.black),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'MIN: ${minValue.toStringAsFixed(6)}',
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w300),
            ),
            Text(
              'MAX: ${maxValue.toStringAsFixed(6)}',
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w300),
            ),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }

  void _showInfoDialog(String title, String content, String imagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(imagePath, fit: BoxFit.contain),
              SizedBox(height: 10),
              Text(content, textAlign: TextAlign.center),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('닫기'),
            ),
          ],
        );
      },
    );
  }

  void _showEnvironmentalMarkDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('환경성적표지'),
          content: Container(
            width: MediaQuery.of(context).size.width * 1.0, // 너비 설정
            height: MediaQuery.of(context).size.height * 0.3, // 높이 설정
            child: PageView.builder(
              itemCount: _images.length,
              controller: PageController(viewportFraction: 1),
              onPageChanged: (int index) => setState(() => _currentIndex = index),
              itemBuilder: (_, i) {
                return Transform.scale(
                  scale: 1.0, // 이미지 크기를 고정
                  child: Image.asset(
                    _images[i],
                    fit: BoxFit.contain,
                    width: MediaQuery.of(context).size.width * 0.7, // 이미지 너비 설정
                    height: MediaQuery.of(context).size.height * 0.5, // 이미지 높이 설정
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('닫기'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('에코 Grade'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row( // Row 위젯 추가
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // spaceBetween으로 설정하여 양쪽 끝으로 정렬
              children: [
                Text(
                  '7대 환경성적표지',
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                Transform.translate(
                  offset: Offset(0, 0), // 위치 조정
                  child: ElevatedButton(
                    onPressed: _showEnvironmentalMarkDialog,
                    child: Text('[환경성적표지] 란?'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Text(
              '[확인된 제품명]',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300),
            ),
            SizedBox(height: 10.0),
            ...productCategories.map((pc) {
              int index = productCategories.indexOf(pc) + 1;
              return Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Text(
                  '$index. ${pc['name']}',
                  style: TextStyle(fontSize: 17.5, fontWeight: FontWeight.w300),
                ),
              );
            }).toList(),
            SizedBox(height: 20.0),
            Transform.translate(
              offset: Offset(0, -5), // 여기서 위치를 조정합니다.
              child: ElevatedButton(
                onPressed: _showProductSelectionDialog,
                child: Text('제품 선택'),
              ),
            ),
            if (_selectedProduct != null)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '[선택된 제품 & 카테고리]\n$_selectedProduct & $_selectedProductCategory\n',
                      style: TextStyle(fontSize: 17.5, fontWeight: FontWeight.bold),
                    ),
                    _buildSpectrum(
                      '자원발자국',
                      productValues['자원발자국'] ?? 0,
                      '광물, 화석 연료 등의 개발 및 소비로 인한\n전 지구적 영향',
                    ),
                    _buildSpectrum(
                      '탄소발자국',
                      productValues['탄소발자국'] ?? 0,
                      '대기로 방출된 온실가스 물질이\n지구의 기후 변화에 미치는 영향',
                    ),
                    _buildSpectrum(
                      '오존층영향',
                      productValues['오존층영향'] ?? 0,
                      '대기 중으로 방출된 오존층 파괴 물질이\n성층권의 오존층에 미치는 영향',
                    ),
                    _buildSpectrum(
                      '산성비',
                      productValues['산성비'] ?? 0,
                      '대기 중 산성화 물질이 빗물에 녹아떨어져\n인간 활동 및 생태계에 미치는 영향',
                    ),
                    _buildSpectrum(
                      '부영양화',
                      productValues['부영양화'] ?? 0,
                      '대기, 수계, 토양에 유지물질, 농도가\n과다해 짐에 따른 생태계 영향',
                    ),
                    _buildSpectrum(
                      '광화학스모그',
                      productValues['광화학스모그'] ?? 0,
                      '인간 활동으로 인한 활성물질이\n빛과 반응하여 생성된 지표면의 오염물질이\n생태계 및 인체에 미치는 영향',
                    ),
                    _buildSpectrum(
                      '물발자국',
                      productValues['물발자국'] ?? 0,
                      '농업, 공업 등 인간 활동이 수질, 수량 등\n수자원에 미치는 영향',
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
