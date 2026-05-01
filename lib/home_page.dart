import 'package:flutter/material.dart';
import 'ocr_page.dart';
import 'quiz_page.dart';
import 'waste_disposal_page.dart';
import 'waste_info.dart'; // wasteInfo 데이터 클래스 import

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ECO+',
          style: TextStyle(fontSize: 30), // 글자 크기 조정
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4.0), // 선의 두께
          child: Container(
            color: Colors.green, // 선의 색상
            height: 4.0, // 선의 두께
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView( // 스크롤 가능하게 변경
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 이미지 추가
              Image.asset(
                'assets/images/icon.jpg',
                width: 300,  // 원하는 크기로 조정
                height: 300, // 원하는 크기로 조정
                fit: BoxFit.cover,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OcrPage()),
                  );
                },
                child: Text(
                  'OCR 페이지로 이동',
                  style: TextStyle(fontSize: 20), // 버튼 텍스트 크기 조정
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20), // 버튼 크기 조정
                  textStyle: TextStyle(fontSize: 18), // 버튼 텍스트 스타일 조정
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AaPage()),
                  );
                },
                child: Text(
                  '탄소배출량 인증마크',
                  style: TextStyle(fontSize: 20), // 버튼 텍스트 크기 조정
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20), // 버튼 크기 조정
                  textStyle: TextStyle(fontSize: 18), // 버튼 텍스트 스타일 조정
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BbPage()),
                  );
                },
                child: Text(
                  '분리배출 방법',
                  style: TextStyle(fontSize: 20), // 버튼 텍스트 크기 조정
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20), // 버튼 크기 조정
                  textStyle: TextStyle(fontSize: 18), // 버튼 텍스트 스타일 조정
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QuizPage()), // 퀴즈 페이지로 이동
                  );
                },
                child: Text(
                  'OX 환경 퀴즈',
                  style: TextStyle(fontSize: 20), // 버튼 텍스트 크기 조정
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20), // 버튼 크기 조정
                  textStyle: TextStyle(fontSize: 18), // 버튼 텍스트 스타일 조정
                ),
              ),
              SizedBox(height: 20),
              // 새로운 기능 버튼 추가
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WasteDisposalPage(wasteInfo: WasteInfo())), // 새로운 페이지로 이동
                  );
                },
                child: Text(
                  '대형 폐기물 배출 신청',
                  style: TextStyle(fontSize: 20), // 버튼 텍스트 크기 조정
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20), // 버튼 크기 조정
                  textStyle: TextStyle(fontSize: 18), // 버튼 텍스트 스타일 조정
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('탄소배출량 인증마크'),
      ),
      body: Center(
        child: Image.asset(
          'assets/images/certificationmark.jpg', // 이미지 경로
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class BbPage extends StatefulWidget {
  @override
  _BbPageState createState() => _BbPageState();
}

class _BbPageState extends State<BbPage> {
  int _currentIndex = 0;
  final List<String> _images = [
    'assets/images/recyclingmain.jpg',
    'assets/images/recyclingpage1.jpg',
    'assets/images/recyclingpage2.jpg',
    'assets/images/recyclingpage3.jpg',
    'assets/images/recyclingpage4.jpg',
    'assets/images/recyclingpage5.jpg',
  ];

  void _nextImage() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _images.length;
    });
  }

  void _prevImage() {
    setState(() {
      _currentIndex = (_currentIndex - 1 + _images.length) % _images.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('분리배출 방법'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              _images[_currentIndex],
              fit: BoxFit.contain, // 이미지를 화면에 맞게 조정
              width: 600, // 원하는 크기로 조정
              height: 600, // 원하는 크기로 조정
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: _prevImage,
                  iconSize: 50,
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: _nextImage,
                  iconSize: 50,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
