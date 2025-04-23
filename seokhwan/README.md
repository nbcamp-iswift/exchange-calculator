# 📈 ExchangeCalculator

## 👀 Intro

<image src="Resources/intro.png" width="50%"></image>

실시간 환율 정보와 계산 기능을 제공하는 iOS 환율 계산기 앱입니다.

## 🛠️ Stack / Dependencies

Xcode, Swift, iOS / Alamofire, RxSwift, SnapKit, Then 

## 🔦 Usage

```bash
git clone https://github.com/nbcamp-iswift/exchange-calculator.git
cd exchange-calculator/seokhwan/ExchangeCalculator
open ExchangeCalculator.xcodeproj
# 실행: ⌘ + R / 테스트: ⌘ + U
```

## 📂 Directory Structure

```
seokhwan
├── README.md
└── ExchangeCalculator
    ├── ExchangeCalculator.xcodeproj
    └── ExchangeCalculator
        ├── Application
        ├── Data
        │   ├── Network
        │   ├── Repository
        │   └── Storage
        ├── Domain
        │   ├── Entity
        │   └── UseCase
        ├── Presentation
        │   ├── ExchangeRate
        │   └── Calculator
        ├── Resource
        └── Utility
```

## 🏗️ Architecture

MVVM-C 기반 Clean Architecture 적용

<image src="Resources/architecture.png" width="75%"></image>

## 🚀 Features

- [x] 통화 코드별 환율 정보 확인
- [x] 통화 코드 or 국가명 검색 필터링 
- [x] 전날과 비교하여 등락 여부 표시
- [x] 즐겨찾기 추가/해제 기능
- [x] 선택한 통화 코드에 대한 환율 계산 기능
- [x] 다크 모드 대응
- [x] 마지막으로 본 화면 저장 기능

## 🎯 Result

<image src="Resources/result.gif" width="250px"></image>

## 🔍 Memory Leak Check

### Debug Memory Graph 사용

<image src="Resources/leakcheck1.png" width="500px"></image>

특이사항 없음(warning 6개는 TODO 주석에 따른 lint warning)

### Leaks Instrument 사용

<image src="Resources/leakcheck2.png" width="500px"></image>

특이사항 없음

## 🔥 Trouble Shooting

- [UISearchBar 경계선 제거](https://velog.io/@youseokhwan/UISearchBar-%EA%B2%BD%EA%B3%84%EC%84%A0-%EC%A0%9C%EA%B1%B0)
- [UITableView Constraints 충돌 해결](https://velog.io/@youseokhwan/UITableView-Constraints-%EC%B6%A9%EB%8F%8C-%ED%95%B4%EA%B2%B0)
