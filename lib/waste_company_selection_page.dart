import 'package:flutter/material.dart';
import 'waste_photo_upload_page.dart'; // 다음 단계 페이지 import
import 'waste_info.dart'; // 데이터 클래스를 import

class WasteCompanySelectionPage extends StatelessWidget {
  final WasteInfo wasteInfo;

  WasteCompanySelectionPage({required this.wasteInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('폐기물 배출 업체 선택'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '사용자 위치에 따른\n폐기물 배출 업체를 선택하세요!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                color: Colors.green[100],
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  '현재 위치와 가장 가까운 폐기물 배출 업체',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 10),
              _buildCompanyCard(context, '송파구 폐기물 배출 업체 : [푸른도시]', '(02-449-8814)\n방이2동, 송파1동'),
              _buildCompanyCard(context, '송파구 폐기물 배출 업체 : [세랑환경]', '(02-443-2292)\n잠실6동, 잠실2동, 잠실3동 일부, 종합운동장, 잠실1·2롯데, 가락시장 3구역'),
              _buildCompanyCard(context, '송파구 폐기물 배출 업체 : [본에코]', '(02-414-6221,6222)\n잠실본동, 삼전동, 가락시장1구역, 잠실3동'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyCard(BuildContext context, String title, String description) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              description,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  // 선택한 폐기물 배출 업체 정보를 확인하는 팝업
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('업체 선택 확인'),
                        content: Text('선택하신 업체\n: [$title]\n이(가) 맞습니까?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // 팝업 닫기
                            },
                            child: Text('아니오'),
                          ),
                          TextButton(
                            onPressed: () {
                              // 선택한 폐기물 배출 업체 정보를 wasteInfo에 저장하고 다음 페이지로 이동
                              wasteInfo.selectedCompany = title;
                              Navigator.of(context).pop(); // 팝업 닫기
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WastePhotoUploadPage(wasteInfo: wasteInfo),
                                ),
                              );
                            },
                            child: Text('예'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('배출 업체 선택하기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
