import 'package:flutter/material.dart';
import 'waste_additional_request_page.dart'; // 마지막 단계 페이지 import
import 'waste_info.dart'; // 데이터 클래스를 import

class WasteDateTimePage extends StatefulWidget {
  final WasteInfo wasteInfo;

  WasteDateTimePage({required this.wasteInfo});

  @override
  _WasteDateTimePageState createState() => _WasteDateTimePageState();
}

class _WasteDateTimePageState extends State<WasteDateTimePage> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('폐기물 수거 일시 선택'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '폐기물 수거 날짜와 시간을 선택하세요!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: Text(
                  _selectedDate == null
                      ? '날짜 선택'
                      : '선택된 날짜 : ${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}',
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _selectTime(context),
                child: Text(
                  _selectedTime == null
                      ? '시간 선택'
                      : '선택된 시간 : ${_selectedTime!.format(context)}',
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  if (_selectedDate != null && _selectedTime != null) {
                    WasteInfo updatedWasteInfo = widget.wasteInfo.copyWith(
                      selectedDate:
                      '${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}',
                      selectedTime: _selectedTime!.format(context),
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            WasteAdditionalRequestPage(wasteInfo: updatedWasteInfo),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('날짜와 시간을 모두 선택해주세요.')),
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
      ),
    );
  }
}
