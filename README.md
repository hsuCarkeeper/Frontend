# Check&Go 🌍✈️

여행 준비를 더 쉽고 체계적으로 관리할 수 있는 Flutter 앱입니다.

## 📱 주요 기능

### 🔐 인증 시스템

- **Welcome Screen**: 첫 실행 시 나타나는 환영 화면
- **로그인/회원가입**: 사용자 계정 관리
- **비밀번호 찾기**: 비밀번호 재설정 기능

### 🏠 홈 화면

- 다가오는 여행 목록 확인
- 여행별 준비 완료율 표시
- D-day 카운터
- 빠른 액션 메뉴 (템플릿, 알림 설정)

### 📅 캘린더

- 여행 일정 관리
- 새 여행 추가/수정

### ✅ 체크리스트

- 여행별 준비물 체크리스트
- 항목 추가/삭제/체크 기능
- 카테고리별 분류

### 📋 템플릿

- 미리 만들어진 체크리스트 템플릿
- 여행 타입별 추천 준비물

### 🔔 알림

- 출발 전 리마인더 설정
- 준비물 알림

### ⚙️ 설정

- 앱 환경 설정
- 계정 관리

## 🏗️ 프로젝트 구조

```
lib/
├── main.dart                 # 앱 진입점
├── models/                   # 데이터 모델
│   └── trip.dart
├── routes/                   # 라우팅 설정
│   └── app_router.dart
├── screens/                  # 화면 UI
│   ├── auth/                # 인증 관련 화면
│   │   ├── welcome_screen.dart
│   │   ├── login_screen.dart
│   │   ├── signup_screen.dart
│   │   └── forgot_password_screen.dart
│   ├── home/
│   │   └── home_screen.dart
│   ├── calendar/
│   │   ├── calendar_screen.dart
│   │   └── widgets/
│   ├── checklist/
│   │   ├── checklist_screen.dart
│   │   └── widgets/
│   ├── notifications/
│   │   └── notifications_screen.dart
│   ├── settings/
│   │   └── settings_screen.dart
│   ├── templates/
│   │   └── templates_screen.dart
│   └── not_found_screen.dart
├── services/                 # 비즈니스 로직
└── widgets/                  # 재사용 가능한 위젯
    ├── base/                # 기본 UI 컴포넌트
    │   ├── custom_button.dart
    │   ├── custom_card.dart
    │   └── custom_fab.dart
    └── feature/             # 기능별 위젯
        ├── top_nav_bar.dart
        └── bottom_nav_bar.dart
```

## 🚀 시작하기

### 필수 조건

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.0 이상)
- Dart SDK (Flutter에 포함)
- Android Studio / Xcode (모바일 개발용)
- VS Code 또는 Android Studio (권장 IDE)

### 설치 및 실행

1. **저장소 클론**

```bash
git clone https://github.com/hsuCarkeeper/Frontend.git
cd checkandgo_app
```

2. **의존성 설치**

```bash
flutter pub get
```

3. **앱 실행**

```bash
# 연결된 디바이스/에뮬레이터에서 실행
flutter run

# Chrome 웹에서 실행
flutter run -d chrome

# 특정 디바이스 선택
flutter devices  # 사용 가능한 디바이스 확인
flutter run -d [device-id]
```

## 📦 주요 패키지

- **go_router**: ^14.6.2 - 선언적 라우팅
- **flutter_localizations**: 다국어 지원
- **Material 3**: 최신 Material Design 구현

## 🎨 디자인 시스템

### 색상 테마

- Primary: `#2E6BFF` (파란색)
- Background: `#F7F8FA` (밝은 회색)
- Text Primary: `#111111`
- Text Secondary: `#555555`

### 커스텀 위젯

- `CustomButton`: 다양한 스타일의 버튼 (primary, outline, ghost)
- `CustomCard`: 그림자와 둥근 모서리가 있는 카드
- `CustomFab`: 플로팅 액션 버튼

## 🗺️ 화면 플로우

```
Welcome Screen
    ├─ 시작하기 → Login Screen
    │              ├─ 로그인 성공 → Home Screen
    │              ├─ 회원가입 → Signup Screen
    │              └─ 비밀번호 찾기 → Forgot Password Screen
    │
    └─ 둘러보기 → Home Screen (로그인 없이)

Home Screen
    ├─ Bottom Navigation
    │   ├─ 캘린더
    │   ├─ 체크리스트
    │   ├─ 알림
    │   └─ 설정
    └─ 빠른 액션
        └─ 템플릿
```

## 🔧 개발 가이드

### 새 화면 추가하기

1. `lib/screens/` 폴더에 새 화면 파일 생성
2. `lib/routes/app_router.dart`에 라우트 추가
3. 필요시 Bottom Navigation에 추가

### 커스텀 위젯 만들기

재사용 가능한 위젯은 `lib/widgets/base/`에 추가하고,
특정 기능에 종속적인 위젯은 각 화면의 `widgets/` 폴더에 추가합니다.

## 📝 개발 현황

- ✅ 인증 시스템 UI 구현
- ✅ 홈 화면 구현
- ✅ 캘린더 화면 구현
- ✅ 체크리스트 화면 구현
- ✅ 템플릿 화면 구현
- ✅ 알림 설정 화면 구현
- ✅ 설정 화면 구현
- ⏳ 백엔드 API 연동 (예정)
- ⏳ 데이터 영속성 구현 (예정)
- ⏳ 푸시 알림 기능 (예정)

## 🤝 기여하기

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 라이선스

이 프로젝트는 MIT 라이선스를 따릅니다.

## 👥 팀

CheckAndGo Development Team

## 📞 문의

프로젝트 관련 문의: [GitHub Issues](https://github.com/hsuCarkeeper/Frontend/issues)
