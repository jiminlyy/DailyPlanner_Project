# PlannerApp

SwiftUI 기반 iOS 다이어리 / 데일리 플래너 앱.
하루를 **To Do 리스트 + 10분 단위 시간표 + 일기**로 한 화면에 기록합니다.

## 주요 기능

### Daily 화면
- 좌측 **SCHEDULE & TO DO** — 24개 항목, 항목당 색상 원 + 체크박스 + 텍스트 입력
- 우측 **TIME TABLE** — 00시 ~ 23시 × 10분 6칸 = 144칸
  - 상단 가로 픽커에서 To Do 선택 후 시간표 셀을 탭/드래그하면 한 번에 여러 칸 칠하기
  - "지우개" 선택 후 드래그하면 칠한 칸 비우기
- 하단 **SUMMARY** — 그날의 일기 자유 입력 (TextEditor)
- 좌우 스와이프로 전날/다음날 이동
- 상단 화살표 버튼으로도 날짜 이동

### Monthly 화면
- 7열 × N행 캘린더 (일~토)
- 오늘 날짜는 파란색 배경으로 강조
- 날짜 탭 → 해당 날짜의 Daily 화면으로 이동

### 색상 팔레트
- `#A8D8EA`를 베이스로 lightness 95% → 25% 그라데이션 **24색** 자동 생성 (HSL 196°, S 61%)
- 새 날짜의 To Do 24개에 각각 다른 색이 자동 배정
- 색깔 원을 탭하면 24색을 순환

## 기술 스택

| 항목 | 사용 기술 |
|------|----------|
| 언어 | Swift |
| UI | SwiftUI |
| 최소 iOS | 17.0 (`@Observable` 매크로 사용) |
| 상태 관리 | `@Observable` + `@Environment` |
| 데이터 영속화 | UserDefaults + JSON 직렬화 (1차) |

## 프로젝트 구조

```
PlannerApp/
├── PlannerApp.swift              # 앱 진입점
├── Models/
│   ├── TodoItem.swift            # 할 일 한 줄 모델
│   └── DailyPlan.swift           # 하루치 데이터 (todos, timetable, summary)
├── Store/
│   └── PlannerStore.swift        # 날짜별 plan 보관 + UserDefaults 영속화
├── Views/
│   ├── RootTabView.swift         # Daily / Monthly 탭 컨테이너
│   ├── Daily/
│   │   ├── DailyPlannerView.swift
│   │   ├── DateHeader.swift
│   │   ├── TodoListColumn.swift
│   │   ├── TodoRow.swift
│   │   ├── TimeTableColumn.swift # 드래그로 한 번에 여러 칸 칠하기
│   │   ├── TodoPicker.swift
│   │   └── SummaryBox.swift
│   └── Monthly/
│       └── MonthlyView.swift
└── Utils/
    ├── Color+Hex.swift           # Color(hex:) 초기자
    └── ColorPalette.swift        # 24색 그라데이션 생성 (HSL→Hex)
```

원칙: **1 파일 = 1 struct** (파일명 = struct 이름).

## 빌드 / 실행

1. Xcode 15+ 에서 `PlannerApp.xcodeproj` 열기
2. iOS 17.0+ 시뮬레이터 또는 실기기 선택
3. `⌘R`로 실행

별도 의존성(SPM/CocoaPods) 없음.

## 데이터 영속화

- 모든 `DailyPlan`을 JSON으로 인코딩 후 UserDefaults `PlannerStore.plans.v1` 키에 저장
- 앱 실행 시 `PlannerStore.init()`에서 로드
- 색상 마이그레이션: 기본색(`#A8D8EA`)으로 남아있는 항목은 로드 시 새 24색 팔레트로 자동 교체 (사용자가 직접 바꾼 색은 보존)

## 시간표 사용법

1. 왼쪽 **TO DO** 칸에 할 일 텍스트 입력 (예: "공부")
2. 시간표 위 픽커에서 그 To Do 칩을 탭 → 칩 전체가 그 색으로 채워짐
3. 시간표 셀을 손가락으로 탭하거나 드래그 → 지나간 셀이 모두 칠해짐
4. 지우려면 픽커에서 "지우개" 선택 후 드래그
5. 시간표 영역에서 드래그 중에는 좌우 스와이프(날짜 이동) / 세로 스크롤이 잠시 비활성화됩니다.

## 추후 확장 아이디어

- SwiftData 마이그레이션
- iCloud 동기화 (CloudKit)
- 위젯 (오늘 To Do 표시)
- 시간표 시작 시 푸시 알림
- Apple Watch 컴패니언

## 라이선스

MIT (또는 원하는 라이선스로 교체)
