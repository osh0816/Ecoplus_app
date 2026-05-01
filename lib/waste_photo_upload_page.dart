import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'waste_date_time_page.dart'; // 다음 단계 페이지로 변경
import 'waste_info.dart'; // 데이터 클래스를 import

class WastePhotoUploadPage extends StatefulWidget {
  final WasteInfo wasteInfo;

  WastePhotoUploadPage({required this.wasteInfo});

  @override
  _WastePhotoUploadPageState createState() => _WastePhotoUploadPageState();
}

class _WastePhotoUploadPageState extends State<WastePhotoUploadPage> {
  final ImagePicker _picker = ImagePicker();
  List<File?> _selectedImages = List.filled(6, null); // 최대 6장의 이미지

  Future<void> _pickImage(int index) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImages[index] = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('배출 폐기물 사진 첨부'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '배출할 폐기물의 사진을 첨부하세요!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: 6,
              shrinkWrap: true,
              padding: EdgeInsets.all(10),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _pickImage(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _selectedImages[index] != null
                        ? Image.file(_selectedImages[index]!, fit: BoxFit.cover)
                        : Center(
                      child: Icon(Icons.add_a_photo, size: 50, color: Colors.grey[700]),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_selectedImages.any((element) => element != null)) {
                  // 다음 단계로 이동 (수거 날짜 및 시간 선택 페이지)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WasteDateTimePage(wasteInfo: widget.wasteInfo),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('적어도 한 장의 사진을 첨부해주세요.')),
                  );
                }
              },
              child: Text(
                '다음 단계로 넘어가기',
                style: TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
