import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';
import 'package:flutter/foundation.dart'; // Isolate 사용을 위해 import 필요

class CarbonProductsPage extends StatefulWidget {
  final String recognizedProduct;

  CarbonProductsPage({required this.recognizedProduct});

  @override
  _CarbonProductsPageState createState() => _CarbonProductsPageState();
}

class _CarbonProductsPageState extends State<CarbonProductsPage> {
  List<Map<String, String>> productCategories = [];
  Map<String, List<Map<String, String>>> sameCategoryProductNames = {};
  Map<String, List<Map<String, String>>> originalProductNames = {};
  String? selectedProductName;
  int sortState = 0; // 0: 기본, 1: 양 작은 순, 2: 양 큰 순

  @override
  void initState() {
    super.initState();
    _loadExcelData();
  }

  Future<void> _loadExcelData() async {
    try {
      ByteData data = await rootBundle.load("assets/Environmental_Performance_Mark_Validation_Product_List_final1.xlsx");
      var bytes = data.buffer.asUint8List();

      // recognizedProduct를 추가로 전달
      var productData = await compute(parseExcelData, {'bytes': bytes, 'recognizedProduct': widget.recognizedProduct});

      setState(() {
        productCategories = productData['productCategories'];
        sameCategoryProductNames = productData['sameCategoryProductNames'];
        originalProductNames = productData['originalProductNames'];
      });
    } catch (e) {
      print('Error loading Excel file: $e');
    }
  }

  static Map<String, dynamic> parseExcelData(Map<String, dynamic> input) {
    Uint8List bytes = input['bytes'];
    String recognizedProduct = input['recognizedProduct'];

    var excel = Excel.decodeBytes(bytes);
    List<Map<String, String>> productCategories = [];
    Map<String, List<Map<String, String>>> sameCategoryProductNames = {};
    Map<String, List<Map<String, String>>> originalProductNames = {};

    // 데이터를 중복 추가하지 않도록 초기화
    productCategories.clear();
    sameCategoryProductNames.clear();
    originalProductNames.clear();

    // recognizedProduct에서 넘버링을 제외한 제품명 리스트 추출
    List<String> productNames = recognizedProduct
        .split('\n')
        .where((product) => product.trim().isNotEmpty)
        .map((product) {
      var parts = product.trim().split('. ');
      return parts.length > 1 ? parts[1] : parts[0];
    }).toList();

    for (var table in excel.tables.keys) {
      var sheet = excel.tables[table]!;
      for (int rowIndex = 0; rowIndex < sheet.rows.length; rowIndex++) {
        var row = sheet.rows[rowIndex];
        var productName = row[3]?.value?.toString() ?? '';
        var category = row[11]?.value?.toString() ?? '';
        var carbonFootprintValue = row[5]?.value?.toString() ?? '';
        var carbonFootprint = carbonFootprintValue.isNotEmpty
            ? (double.tryParse(carbonFootprintValue) != null
            ? (double.parse(carbonFootprintValue) * 10000).round() / 10000
            : 0)
            : 0;

        // recognizedProduct에 있는 제품이 있는 행의 카테고리를 찾고, 동일한 카테고리를 가진 모든 제품을 저장
        if (productNames.contains(productName)) {
          productCategories.add({'name': productName, 'category': category});

          // 동일한 카테고리를 가진 모든 제품을 찾아 저장
          for (int i = 0; i < sheet.rows.length; i++) {
            var sameCategoryRow = sheet.rows[i];
            var sameCategory = sameCategoryRow[11]?.value?.toString() ?? '';
            if (sameCategory == category) {
              var sameCategoryProductName = sameCategoryRow[3]?.value?.toString() ?? '';
              var sameCategoryCarbonFootprintValue = sameCategoryRow[5]?.value?.toString() ?? '';
              var sameCategoryCarbonFootprint = sameCategoryCarbonFootprintValue.isNotEmpty
                  ? (double.tryParse(sameCategoryCarbonFootprintValue) != null
                  ? (double.parse(sameCategoryCarbonFootprintValue) * 10000).round() / 10000
                  : 0)
                  : 0;

              if (!sameCategoryProductNames.containsKey(category)) {
                sameCategoryProductNames[category] = [];
                originalProductNames[category] = [];
              }
              if (!sameCategoryProductNames[category]!
                  .any((element) => element['name'] == sameCategoryProductName)) {
                var productData = {
                  'name': sameCategoryProductName,
                  'carbonFootprint': sameCategoryCarbonFootprint.toStringAsFixed(4),
                };
                sameCategoryProductNames[category]!.add(productData);
                originalProductNames[category]!.add(productData);
              }
            }
          }
        }
      }
    }

    return {
      'productCategories': productCategories,
      'sameCategoryProductNames': sameCategoryProductNames,
      'originalProductNames': originalProductNames,
    };
  }

  void _sortProductsByCarbonFootprint(String category) {
    setState(() {
      if (sortState == 0) {
        // 양 작은 순 정렬
        sameCategoryProductNames[category]!.sort((a, b) {
          double carbonA = double.tryParse(a['carbonFootprint'] ?? '0') ?? 0;
          double carbonB = double.tryParse(b['carbonFootprint'] ?? '0') ?? 0;
          return carbonA.compareTo(carbonB);
        });
        sortState = 1;
      } else if (sortState == 1) {
        // 양 큰 순 정렬
        sameCategoryProductNames[category]!.sort((a, b) {
          double carbonA = double.tryParse(a['carbonFootprint'] ?? '0') ?? 0;
          double carbonB = double.tryParse(b['carbonFootprint'] ?? '0') ?? 0;
          return carbonB.compareTo(carbonA);
        });
        sortState = 2;
      } else {
        // 원래 순서로 복원
        sameCategoryProductNames[category] = List.from(originalProductNames[category]!);
        sortState = 0;
      }
    });
  }

  void _onProductTap(String productName) {
    setState(() {
      selectedProductName = productName;
    });
  }

  void _showProductSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('제품 선택'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: productCategories.map((product) {
              return RadioListTile<String>(
                title: Text('${product['name']} [${product['category']}]'),
                value: product['name']!,
                groupValue: selectedProductName,
                onChanged: (value) {
                  _onProductTap(value!);
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('탄소 Grade'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '탄소발자국',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 20.0),
            Text(
              '[확인된 제품명]',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300),
            ),
            ...productCategories.map((pc) {
              int index = productCategories.indexOf(pc) + 1;
              return Container(
                child: ListTile(
                  title: Text('$index. ${pc['name']} \n ⇒ ${pc['category']}'),
                ),
              );
            }).toList(),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _showProductSelectionDialog,
              child: Text('제품 선택'),
            ),
            SizedBox(height: 20.0),
            ...sameCategoryProductNames.keys.map((category) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: '[인식된 카테고리] ⇒ ',
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300, color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text: '$category',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '[동일 카테고리 리스트]',
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.sort),
                        onPressed: () => _sortProductsByCarbonFootprint(category),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 400,
                    child: ListView.builder(
                      itemCount: sameCategoryProductNames[category]!.length,
                      itemBuilder: (context, index) {
                        var product = sameCategoryProductNames[category]![index];
                        return Card(
                          color: selectedProductName == product['name'] ? Colors.green : Colors.white,
                          child: ListTile(
                            title: Text(
                              '${product['name']}',
                              style: TextStyle(
                                color: selectedProductName == product['name'] ? Colors.white : Colors.black,
                              ),
                            ),
                            subtitle: Text('탄소 발자국: ${product['carbonFootprint']} kgCO2e'),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20.0),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
