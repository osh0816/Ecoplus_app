class WasteInfo {
  // 배출하려는 쓰레기 종류 리스트
  List<String> wasteTypes;

  // 사용자의 위치 (주소)
  String userLocation;

  // 선택한 폐기물 배출 회사 이름
  String selectedCompany;

  // 선택한 수거 날짜
  String selectedDate;

  // 선택한 수거 시간
  String selectedTime;

  // 추가 요청 사항
  String additionalRequest;

  // 생성자 초기화
  WasteInfo({
    this.wasteTypes = const [],
    this.userLocation = '',
    this.selectedCompany = '',
    this.selectedDate = '',
    this.selectedTime = '',
    this.additionalRequest = '',
  });

  // copyWith 메서드 추가: 특정 필드만 업데이트하여 WasteInfo 인스턴스를 복사
  WasteInfo copyWith({
    List<String>? wasteTypes,
    String? userLocation,
    String? selectedCompany,
    String? selectedDate,
    String? selectedTime,
    String? additionalRequest,
  }) {
    return WasteInfo(
      wasteTypes: wasteTypes ?? this.wasteTypes,
      userLocation: userLocation ?? this.userLocation,
      selectedCompany: selectedCompany ?? this.selectedCompany,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      additionalRequest: additionalRequest ?? this.additionalRequest,
    );
  }

  // 정보 요약 문자열 반환 (사용자에게 보여주기 위한 용도)
  String getSummary() {
    return '''
    배출하려는 쓰레기 종류: ${wasteTypes.isEmpty ? '선택 안 함' : wasteTypes.join(', ')}
    사용자 위치: ${userLocation.isEmpty ? '위치 정보 없음' : userLocation}
    선택한 폐기물 배출 회사: ${selectedCompany.isEmpty ? '회사 선택 안 함' : selectedCompany}
    수거 날짜: ${selectedDate.isEmpty ? '날짜 선택 안 함' : selectedDate}
    수거 시간: ${selectedTime.isEmpty ? '시간 선택 안 함' : selectedTime}
    추가 요청 사항: ${additionalRequest.isEmpty ? '요청 사항 없음' : additionalRequest}
    ''';
  }
}
