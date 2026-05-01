import 'package:flutter/material.dart';
import 'waste_company_selection_page.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:permission_handler/permission_handler.dart';
import 'waste_info.dart'; // 데이터 클래스를 import

class WasteLocationPage extends StatefulWidget {
  final WasteInfo wasteInfo;

  WasteLocationPage({required this.wasteInfo});

  @override
  _WasteLocationPageState createState() => _WasteLocationPageState();
}

class _WasteLocationPageState extends State<WasteLocationPage> {
  late NaverMapController _mapController;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      print('위치 권한 허용됨');
    } else {
      print('위치 권한 거부됨');
    }
  }

  void _onMapReady(NaverMapController controller) {
    _mapController = controller;
  }

  String _userLocation = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('위치 확인 및 주소 입력'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '사용자의 현재 위치 및 주소가\n맞으신가요?',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 300,
                child: NaverMap(
                  options: NaverMapViewOptions(
                    initialCameraPosition: NCameraPosition(
                      target: NLatLng(37.5146, 127.1059), // 서울시 송파구청 위치
                      zoom: 15,
                    ),
                    locationButtonEnable: true, // 현재 위치 버튼 활성화
                  ),
                  onMapReady: _onMapReady,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: '상세 주소 입력',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _userLocation = value; // 사용자가 입력한 주소 저장
                  });
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_userLocation.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('주소를 입력해주세요.')),
                        );
                      } else {
                        // 주소 확인 팝업
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('주소 확인'),
                              content: Text('입력하신 상세 주소\n: [$_userLocation]\n이(가) 맞습니까?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // 팝업 닫기
                                  },
                                  child: Text('아니오'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // 입력된 위치 정보를 wasteInfo에 저장하고 다음 페이지로 이동
                                    widget.wasteInfo.userLocation = _userLocation;
                                    Navigator.of(context).pop(); // 팝업 닫기
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => WasteCompanySelectionPage(wasteInfo: widget.wasteInfo),
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
                    child: Text('다음 단계로 넘어가기'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
