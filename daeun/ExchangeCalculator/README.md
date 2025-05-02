# 💱 ExchangeCalculator

실시간 환율 정보를 기반으로 통화 간 변환이 가능한 iOS 앱입니다.  

<br>

https://github.com/user-attachments/assets/765ca70f-9fe3-4207-8f0a-066ebc448ae6



## 📲 주요 기능

- 최신 환율 정보 조회
- 통화 간 환율 변환
- 즐겨찾기 추가/삭제
- 마지막으로 조회한 통화 정보 복원

<br>

## 🧭 아키텍처

ExchangeCalculator는 아래와 같은 계층 구조로 설계되었습니다:
```
ViewController
↓
ViewModel (ListViewModel / DetailViewModel)
↓
UseCase (ExchangeRatesUseCase / ConvertCurrencyUseCase / FavoriteExchangeUseCase)
↓
Repository
↓
📡 RemoteDataSource (Alamofire)
📦 LocalDataSource (Core Data)
```

<br>

### ✅ 기술 스택
- **Swift 5**
- **UIKit**
- **Core Data**
- **Combine**
- **Alamofire** (환율 API 호출)

<br>

## 📁 프로젝트 구조
```
ExchangeCalculator/
├── App/                          // App 생명주기
├── Data/
│   ├── CoreData/                 // Core Data 구조
│   │   ├── CachedRate/
│   │   ├── FavoriteExchange/
│   │   └── LastViewedExchange/
│   ├── Model/                    // DTO
│   └── Repository/              // Repository 구현
├── Domain/
│   ├── Entity/                  // 도메인 모델 (ExchangeRate, ConversionResult 등)
│   ├── Repository/             // Repository Protocol 정의
│   └── UseCase/                // 비즈니스 로직
├── Presentation/
│   ├── Detail/                 // 상세 환율 화면 (MVVM)
│   └── List/                   // 환율 리스트 화면 (MVVM)
├── Support/
│   ├── Extensions/             // 공통 유틸
│   └── Mapper, Constant 등
└── Resource/                   // Assets, Info.plist
```
<br>

## 💾 Core Data 로컬 저장소

| 목적                    | 설명 |
|-------------------------|------|
| `CachedRate`            | 마지막/현재 환율 값을 저장하여 등락 확인에 사용 |
| `FavoriteExchange`      | 즐겨찾기 통화 리스트 저장 |
| `LastViewedExchange`    | 마지막으로 본 통화 정보 복원에 사용 |

> 각각은 `LocalRateChangeDataSource`, `LocalFavoriteDataSource`, `LocalLastViewedDataSource` 클래스를 통해 관리됩니다.

<br>

## 🧩 주요 유즈케이스

### 🔁 `ExchangeRatesUseCase`
- 환율 목록 불러오기 (`loadList`)
- 마지막 조회 통화 저장/삭제

### ⭐️ `FavoriteExchangeUseCase`
- 즐겨찾기 추가/삭제 (`toggleFavorite`)

### 💱 `ConvertCurrencyUseCase`
- 금액을 환율로 변환 (`execute`)
- 에러처리 (`empty input`, `invalid number` 등)

<br>

## 🧪 상태 관리 (ViewModel)

- `ListViewModel`
  - 환율 목록 로드 및 필터링
  - 셀 선택 시 상세 화면 이동
  - 즐겨찾기 토글
- `DetailViewModel`
  - 통화 변환 실행 및 결과 바인딩
  - Combine을 통한 상태 흐름 처리 (`PassthroughSubject`, `CurrentValueSubject` 활용)

<br>
