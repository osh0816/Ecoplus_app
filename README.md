## [Ecoplus_app]

[환경성적표지 정보의 직관적 이해를 위한 시스템 설계 및 구현 - 'Ecoplus']<br>
[System Design and Implementation for Intuitive Comprehension of EPD - 'Ecoplus']

‘Ecoplus’는 환경성적표지 정보를 소비자가 직관적으로 이해할 수 있도록 만든 모바일 앱으로, OCR 기반 제품 인식과 데이터 매칭을 통해 탄소배출량 비교, 7대 환경영향 시각화(에코 Grade), 분리배출 안내, 폐기물 배출 기능 등을 제공한다.

<br>

## 프로젝트 개요
| 항목 | 내용 |
|:---:|:-----:|
| 프로젝트명 | 환경성적표지 정보의 직관적 이해를 위한 시스템 설계 및 구현 - 'Ecoplus' |
| 과목 | 4-1 [경영공학종합설계] <br> ⇒ (Version 1. 초기 버전) <br> & <br> 교내 경진대회 [4차 산업혁명 다산 LINC+ 사업단 4C 페스타 (2024)] <br> ⇒ (Version 2. OX 환경 퀴즈, 대형 폐기물 간편 배출 등 기능 추가 및 기존 서비스 보완) <br> <br> ※ 본 앱은 최종 완성본인 Version 2를 기준으로 작성됨|
| 기간 | 2024.03 ~ 2024.11 |
| 팀명 | 에코 플러스 |
| 팀원 | 오상헌, 김유진, 모예은, 박지은 |
<br>

## 파일 구성
| 파일/폴더 | 설명 |
|-----------|------|
| `lib/main.dart` | 앱 진입점, Naver Map SDK 초기화 |
| `lib/home_page.dart` | 메인 화면 (5개 메뉴 버튼 분기) |
| `lib/ocr_page.dart` | OCR 제품 인식 및 유사도 매칭 |
| `lib/ocr_service.dart` | Naver Clova OCR API 호출 로직 |
| `lib/carbon_products.dart` | 카테고리별 탄소배출량 비교 및 정렬 |
| `lib/ecograde.dart` | 7대 에코 Grade 스펙트럼 시각화 + 환경마크 팝업 |
| `lib/quiz_page.dart` | OX 환경 퀴즈 (40문항 중 10문제 랜덤) |
| `lib/waste_disposal_page.dart` | [1단계] 대형 폐기물 종류 선택 |
| `lib/waste_location_page.dart` | [2단계] 위치 확인 및 주소 입력 |
| `lib/waste_company_selection_page.dart` | [3단계] 동별 수거업체 자동 매칭 |
| `lib/waste_photo_upload_page.dart` | [4단계] 폐기물 사진 첨부 (최대 6장) |
| `lib/waste_date_time_page.dart` | [5단계] 수거 날짜/시간 예약 |
| `lib/waste_additional_request_page.dart` | [6단계] 추가 요청사항 → 최종 제출 |
| `lib/waste_info.dart` | 폐기물 배출 정보 데이터 클래스 |
| `assets/` | 전처리된 Excel DB + 이미지 에셋 |
| `pubspec.yaml` | 의존성 및 에셋 설정 |
<br>

## API 키 설정
※ API 키는 보안상 레포지토리에 포함되어 있지 않습니다. [Naver Cloud Platform](https://www.ncloud.com/)에서 직접 발급받아 입력해 주세요 ※
1. `lib/ocr_service.dart` — Naver Clova OCR API URL과 Secret Key 입력
2. `lib/main.dart` — Naver Map Client ID 입력
<br>

## 주요 기능
| No. | 기능 | 설명 |
|:---:|---|---|
| 01 | OCR 활용 및 유사도 검출 | 제품 이미지에서 텍스트를 추출하고, DB 내 제품명과 단어 포함 방식으로 유사도를 산출 |
| 02 | 카테고리별 탄소배출량 비교 | 동일 제품군 내 제품들을 탄소배출량 기준으로 오름/내림차순 정렬하여 비교 |
| 03 | 에코 Grade 스펙트럼 | 7대 환경영향 범주별 수치를 MIN/MAX 정규화 후 색상 스펙트럼(파랑→초록→노랑→빨강)으로 시각화 |
| 04 | 7대 환경 영향범주 안내 | 각 영향범주의 공식 마크 이미지와 정의를 팝업으로 제공 |
| 05 | 탄소배출량 인증마크 안내 | 3단계(탄소배출량인증, 저탄소제품인증, 탄소중립제품인증) 설명 |
| 06 | 재활용 방법 안내 | 환경부 기준 6가지 카테고리별 분리배출 요령을 자체 제작 이미지로 안내 |
| 07 | OX 환경 퀴즈 | 자체 제작 40문항 중 10문제를 랜덤 출제, 정답 및 해설 제공 |
| 08 | 대형 폐기물 간편 배출 | Naver Map API 기반 위치 확인 → 동별 수거업체 자동 매칭 → 6단계 배출 예약 |
<br>

## 기술 스택
| 구분 | 기술 |
|:------:|:------:|
| 프레임워크 | Flutter (Dart) |
| 개발 환경 | Visual Studio Code, Android Studio |
| OCR | Naver Clova OCR API |
| 지도 | Naver Map API (flutter_naver_map) |
| 데이터 | 환경성적표지 유효인증 제품목록 (2024.02.28, 한국환경산업기술원) |
<br>

## 데이터 전처리
한국환경산업기술원 공식 제품목록을 앱 목적에 맞게 재가공

| 항목 | 원본 | 전처리 후 |
|:------:|:------:|:----------:|
| 컬럼 수 | 52개 | 15개 |
| 제품 수 | 2,395개 | 2,395개 |
| 7대 영향범주 | 각 6개 컬럼 (총량·단위·제조전·제조·사용·폐기) | 총량만 추출 (7개) |
| 추가 컬럼 | - | 카테고리, 분리수거 재질 (수작업 분류) |
<br>

## 블로그
프로젝트의 기획부터 구현 등의 과정들을 보다 상세하게 블로그에 정리해 두었습니다

| 내용 | 링크 |
|------|---|
| [1장] 프로젝트 개요 및 설계 | [바로가기](https://blog.naver.com/sanctuary_horizon/223735098798) |
| [2장] 구현 과정 및 결과 분석 그리고 회고 | [바로가기](https://blog.naver.com/sanctuary_horizon/223736753278) |
