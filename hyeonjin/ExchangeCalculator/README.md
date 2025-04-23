# Objective 환율 계산기(Lv 1 ~ Lv 12) 
- 통화 별 환율을 조회하고 달러 기준으로 환율을 계산할 수 있는 앱입니다.

## 스택
- CoreData
- RxSwift
- Snapkit
- MVVM
- Clean Architecture
- Coordinator

# KeyResult

## 1. API 요청으로 실시간 환율 데이터 불러오기
- 소수점 4자리 표시
- 네트워크 오류 시 Alert 표시
<image src="https://github.com/user-attachments/assets/c11c23b0-167c-492a-9c46-c604451e553a" width= "250" />


## 2. 통화 코드와 국가명 매핑하기
- `CurrencyCodeMap`을 사용하여 매핑 후 Entity 생성
```
enum CurrencyCodeMap {
    static let map = [
        "USD": "미국",
        "AED": "아랍에미리트",
        "ZWL": "짐바브웨"
    ]
}

func toEntity() -> [ExchangeRate] {
    rates.map {
        ExchangeRate(
            currencyCode: $0.key,
            value: String(format: "%.4f", $0.value),
            country: CurrencyCodeMap.map[$0.key] ?? "알 수 없음",
            isBookmark: false,
            arrowState: .none
        )
    }
    .sorted { $0.currencyCode < $1.currencyCode }
```

## 3. 검색 필터링 구현
- ViewModel에서 원본 데이터와 필터링 데이터 모두 소유
- 검색 문자열 기준으로 UITableView에 표시(문자열 없을 경우 모두 표시, 문자열 있을 경우 필터링 데이터 표시)

```
Observable.combineLatest(
    state.map(\.searchBarText).distinctUntilChanged(), // 검색 문자열
    state.map(\.originalExchangeRates).distinctUntilChanged() // 원본 데이터
)
.
.
.
필터링 데이터 방출
```
<image src="https://github.com/user-attachments/assets/c91527bc-d203-4854-b857-41f20c1dcb2d" width= "250" />


## 4. 환율 계산기 페이지 이동
- Coordinator 사용
- 환율 계산기 페이지에 필요한 entity를 파라미터로 하여 이동
- 환율 UITextField 문자열 입력 또는 입력 값 없음 시 Alert 표시
```
extension Coordinator {
    func showDetailView(exchangeRate: ExchangeRate) {
        let detailVC = DetailViewController(
            viewModel: DetailViewModel(exchangeRate: exchangeRate),
            coordinator: self
        )
        navigationController.pushViewController(detailVC, animated: true)

        try? sceneUseCase.saveScene(exchangeRate: exchangeRate, isEmptyScene: false)
    }
}
```
<image src="https://github.com/user-attachments/assets/15457255-b056-46ba-9837-86b5772b7f47" width= "250" />
<image src="https://github.com/user-attachments/assets/988bd269-7b24-4220-8456-2d7abe83c106" width= "250" />


## 5. ViewModel 추상화
- Reactor 구조 사용
- Action - 이벤트 정의
- Mutation - 이벤트에 대해 상태를 변화 시키기 위한 행위
- State - 상태
 
```
protocol ViewModelProtocol {
    associatedtype Action
    associatedtype Mutation
    associatedtype State

    var state: BehaviorRelay<State> { get }
    var action: PublishRelay<Action> { get }

    func mutate(action: Action) -> Observable<Mutation>
    func reduce(state: State, mutation: Mutation) -> State
}
```

## 6. 즐겨찾기 기능
- CoreData 영속성 유지
- 즐겨찾기한 환율 UITableView 상단 정렬
- 즐겨찾기 여부와 상관 없이 통화 코드는 문자열 오름차순으로 정렬 유지
- UseCase로 정렬 로직 분리 

<image src="https://github.com/user-attachments/assets/e04b71d7-7bd0-4f71-beeb-db8f51213aa0" width= "250" />

## 7. 상승/하락 여부 표현
- 하루에 한 번 업데이트 되는 환율 정보를 CoreData에 캐싱
- 실시간 환율 정보와 CoreData에 캐싱한 환율 정보를 비교하여 상승/하락 여부 결정
- ArrowState로 상승/하락 여부를 Entity에 구분하여 저장
```
enum ArrowState: String {
    case increase
    case decrease
    case none
}

struct ExchangeRate: Hashable {
    let currencyCode: String
    let value: String
    let country: String
    var isBookmark: Bool
    var arrowState: ArrowState
}

```

## 8. 다크모드 구현
<image src="https://github.com/user-attachments/assets/47d43f21-72a5-4ea2-83e2-88b8a23e1495" width= "250" />
<image src="https://github.com/user-attachments/assets/ef675183-5eb1-4adb-8f43-697cde660b4a" width= "250" />

## 9. 앱 종료 시 마지막 화면 저장 후 재실행 시 페이지 분기
- 환율 계산기 페이지 Appear/Disappear 시 CoreData에 상태 저장
- 재실행 시 CoreData 상태 불러온 후 Coordinator에서 분기
```
extension Coordinator {
    func start() {
        showMainView() 

        // CoreData에서 마지막 페이지 불러오기
        guard let (exchangeRate, isEmptyScene) = try? sceneUseCase.loadScene() else {
            return
        }
        
        // CoreData에서 마지막 페이지가 존재한다면 환율 계산기 페이지로 분기 
        if !isEmptyScene {
            DispatchQueue.main.async { [weak self] in
                self?.showDetailView(exchangeRate: exchangeRate)
            }
        }
    }

    func showDetailView(exchangeRate: ExchangeRate) {
        let detailVC = DetailViewController(
            viewModel: DetailViewModel(exchangeRate: exchangeRate),
            coordinator: self
        )
        navigationController.pushViewController(detailVC, animated: true)

        try? sceneUseCase.saveScene(exchangeRate: exchangeRate, isEmptyScene: false)
    }
    
    func popDetailView() {
        // CoreData에 더미 값 및 마지막 페이지 empty(isEmpty == true) 저장
        try? sceneUseCase.saveScene(exchangeRate: ExchangeRate.dummyEntity, isEmptyScene: true)
    }
}

// DetailView viewDidDisappear에서 coordinator.popDetailView() 호출
final class DetailViewController: UIViewController {
        override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        coordinator.popDetailView()
    }
}

```


## 10. 메모리 이슈 디버깅
<image src="https://github.com/user-attachments/assets/48a63a44-0005-4d62-af4a-750a398ba30f" width= "500" />
<image src="https://github.com/user-attachments/assets/73a62421-0397-437d-b3ae-203cf5ce5d4c" width= "500" />

## 11. Clean Architecture

```
|ㅡ App # AppDelegate & SceneDelegate & DIContainer
|ㅡ Data # DTO, Repository, Service
|ㅡ Domain # Entity, UseCase, UseCase Interface, Repository Interface
|ㅡ Presentation # UI 관련 코드(UIViewController, UI 컴포넌트, ViewModel), Coordinator
|ㅡ Resources # json 파일 및 Image

```
