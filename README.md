# Flutter Todo List

Flutter를 활용하여 구현한 간단한 Todo List 애플리케이션입니다.  
할 일에 날짜와 시간을 지정하고, 일정 기준에 따라 할 일을 분류하여 확인할 수 있도록 구현했습니다.

## 주요 기능

- 할 일 및 메모 작성
- 날짜 선택
- 시작 시간 및 종료 시간 설정
- 완료 여부 체크 및 취소선 표시
- 날짜와 시간에 따른 할 일 분류
  - 오늘 할 일
  - 일주일 내 할 일
  - 이번 달 할 일
  - 지금 할 일

## Tech Stack

- Flutter
- Dart

## Project Structure

주요 애플리케이션 로직은 `lib/main.dart`에 구현되어 있습니다.

- `HomeScreen`: 할 일 목록 및 카테고리별 표시
- `MemoRecordScreen`: 할 일, 날짜, 시간, 메모 입력
- `Todo`: 할 일 데이터 모델
- `groupTodosByCategory()`: 날짜 및 시간을 기준으로 할 일 분류

## Development Period

2025.06
