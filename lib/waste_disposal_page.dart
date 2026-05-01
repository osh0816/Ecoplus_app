import 'package:flutter/material.dart';
import 'waste_location_page.dart';
import 'waste_info.dart'; // 데이터 클래스를 import

class WasteDisposalPage extends StatefulWidget {
  final WasteInfo wasteInfo; // 데이터를 유지하기 위한 클래스 인스턴스

  WasteDisposalPage({required this.wasteInfo});

  @override
  _WasteDisposalPageState createState() => _WasteDisposalPageState();
}

class _WasteDisposalPageState extends State<WasteDisposalPage> {
  List<bool> _isSelected = List.generate(9, (index) => false);
  final List<String> labels = ['쇼파', '의자', '침대', '테이블', '냉장고', '세탁기', 'TV', '기타 가구', '기타 가전'];

  final double blockSize = 90.0;
  final double topPadding = 30.0;
  final double buttonSpacing = 40.0;
  final double buttonFontSize = 18.0;
  final EdgeInsets buttonPadding = EdgeInsets.symmetric(horizontal: 40, vertical: 15);

  String? otherFurnitureDetail;
  String? otherApplianceDetail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('배출하는 폐기물 종류 선택'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(top: topPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  '배출하려는 폐기물의 종류를\n선택해주세요!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: 9,
                shrinkWrap: true,
                padding: EdgeInsets.all(10),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      setState(() {
                        _isSelected[index] = !_isSelected[index];
                      });

                      if (_isSelected[index]) {
                        if (labels[index] == '기타 가구') {
                          otherFurnitureDetail = await _showInputDialog('[기타 가구] 세부 사항 입력');
                          if (otherFurnitureDetail == null || otherFurnitureDetail!.trim().isEmpty) {
                            setState(() {
                              _isSelected[index] = false;
                            });
                          }
                        } else if (labels[index] == '기타 가전') {
                          otherApplianceDetail = await _showInputDialog('[기타 가전] 세부 사항 입력');
                          if (otherApplianceDetail == null || otherApplianceDetail!.trim().isEmpty) {
                            setState(() {
                              _isSelected[index] = false;
                            });
                          }
                        }
                      }
                    },
                    child: Container(
                      width: blockSize,
                      height: blockSize,
                      decoration: BoxDecoration(
                        color: _isSelected[index] ? Colors.green : Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(20),
                      child: Text(
                        labels[index],
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: buttonSpacing),
              ElevatedButton(
                onPressed: () {
                  if (_isSelected.every((element) => !element)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('하나 이상의 폐기물 종류를 선택해주세요.')),
                    );
                  } else {
                    List<String> selectedWasteTypes = [];
                    for (int i = 0; i < _isSelected.length; i++) {
                      if (_isSelected[i]) {
                        if (labels[i] == '기타 가구' && otherFurnitureDetail != null) {
                          selectedWasteTypes.add('기타 가구($otherFurnitureDetail)');
                        } else if (labels[i] == '기타 가전' && otherApplianceDetail != null) {
                          selectedWasteTypes.add('기타 가전($otherApplianceDetail)');
                        } else {
                          selectedWasteTypes.add(labels[i]);
                        }
                      }
                    }

                    // 선택한 항목을 확인하는 팝업
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('선택 확인'),
                          content: Text('선택하신 항목\n: [${selectedWasteTypes.join('], [')}]\n이(가) 맞습니까?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // 팝업 닫기
                              },
                              child: Text('아니오'),
                            ),
                            TextButton(
                              onPressed: () {
                                // 입력된 항목들을 wasteInfo에 저장하고 다음 페이지로 이동
                                widget.wasteInfo.wasteTypes = selectedWasteTypes;
                                Navigator.of(context).pop(); // 팝업 닫기
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WasteLocationPage(wasteInfo: widget.wasteInfo),
                                  ),
                                );
                              },
                              child: Text('예'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Text(
                  '배출 시작하기',
                  style: TextStyle(fontSize: buttonFontSize),
                ),
                style: ElevatedButton.styleFrom(
                  padding: buttonPadding,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> _showInputDialog(String title) async {
    String? input;
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            onChanged: (value) {
              input = value;
            },
            decoration: InputDecoration(hintText: "세부 사항을 입력해주세요"),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(input);
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
    return input;
  }
}
