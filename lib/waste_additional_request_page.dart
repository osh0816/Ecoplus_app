import 'package:flutter/material.dart';
import 'waste_info.dart'; // 데이터 클래스를 import
import 'home_page.dart'; // HomePage로 돌아가기 위한 import

class WasteAdditionalRequestPage extends StatelessWidget {
  final WasteInfo wasteInfo;

  WasteAdditionalRequestPage({required this.wasteInfo});

  final TextEditingController _requestController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('폐기물 관련 최종 정보'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '[입력한 폐기물 관련 정보]',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text('배출 폐기물 종류\n: ${wasteInfo.wasteTypes.join(', ')}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 5),
              Text('사용자 상세 주소\n: ${wasteInfo.userLocation}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 5),
              Text('폐기물 배출 업체\n: ${wasteInfo.selectedCompany}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 5),
              Text('폐기물 수거 날짜\n: ${wasteInfo.selectedDate}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 5),
              Text('폐기물 수거 시간\n: ${wasteInfo.selectedTime}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),
              Center(
                child: Text(
                  '[폐기물 수거 관련 추가 요청 사항]\n아래에 입력해 주세요!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _requestController,
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: '요청 사항을 입력하세요',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // 입력한 정보를 확인하는 팝업창 표시
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('정보 확인'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('배출 폐기물 종류\n: ${wasteInfo.wasteTypes.join(', ')}'),
                              Text('사용자 상세 주소\n: ${wasteInfo.userLocation}'),
                              Text('폐기물 배출 업체\n: ${wasteInfo.selectedCompany}'),
                              Text('폐기물 수거 날짜\n: ${wasteInfo.selectedDate}'),
                              Text('폐기물 수거 시간\n: ${wasteInfo.selectedTime}'),
                              if (_requestController.text.trim().isNotEmpty)
                                Text('추가 요청 사항\n: ${_requestController.text}'),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // 팝업 닫기
                              },
                              child: Text('아니오'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // 팝업 닫기
                                // 최종 제출 후 '제출되었습니다' 팝업 표시
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('최종 제출 되었습니다!'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            // 홈 페이지로 이동
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => HomePage()),
                                                  (Route<dynamic> route) => false,
                                            );
                                          },
                                          child: Text('확인'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Text('예'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text(
                    '제출하기',
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
