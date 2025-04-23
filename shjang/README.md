# Objective: 

* Create the Currency Converter or Exchange Rate Calculator

## Jargons
* DTO: Data Transfer Object, to communicate the data from server & client. Transfer the data such that it only transfer into business logic. Often it's good to transfer data as a chunk
    - getter / setter method & corresponding fields.
    - serialization / deserialization (**This is what I need**)

* DAO: Data Access Object, to interact with Databasse with CRUD (Create, Read, Update, Delete) task.

* VO: Value Object, as an imutable object to define the data. The state of this object never changed by anything.

### Define 
The one of the data response that I will get from server would be following:

```json
{
  "result": "success",
  "provider": "https://www.exchangerate-api.com",
  "documentation": "https://www.exchangerate-api.com/docs/free",
  "terms_of_use": "https://www.exchangerate-api.com/terms",
  "time_last_update_unix": 1744588952,
  "time_last_update_utc": "Mon, 14 Apr 2025 00:02:32 +0000",
  "time_next_update_unix": 1744676542,
  "time_next_update_utc": "Tue, 15 Apr 2025 00:22:22 +0000",
  "time_eol_unix": 0,
  "base_code": "USD",
  "rates": {
    "USD": 1,
    "AED": 3.6725,
    "AFN": 72.59835,
    "ALL": 87.804251,
    "AMD": 390.997056,
    "ANG": 1.79,
    "AOA": 921.254005,
    "ARS": 1078.38,
    "AUD": 1.590742,
    "AWG": 1.79,
    "AZN": 1.700146,
    "BAM": 1.725975,
    "BBD": 2,
    "BDT": 121.534152,
    "BGN": 1.725946,
    "BHD": 0.376,
    "BIF": 2979.209199,
    "BMD": 1,
    "BND": 1.31928,
    "BOB": 6.941317,
    "BRL": 5.869227,
    "BSD": 1,
    ....
  }
}
```

This can be converted into

```swift
ExchangeRateDto {
    let baseCode: String
    let rates: [String: Double]
    
    enum CodingKeys: String, CodingKey {
        case baseCode = "base_code"
        case rates
    }
}
```

but since, `base_code` key should be matched with `json`. You create enum `CodingKey` type for conversion.

### Repostiory(DataService) -> ViewModel -> ViewController
This can be done normally on DIContainers, but for the simplicity, I used this in `SceneDelegate`.

### Core Data
* Create CoreData Entity
  * Make exchangeRateWithFav CoreData (xcdatamodel)
  ```swift
  countryCode: String // (not optional)
  currency: String    // (not optional)
  isFavorite: Bool    // (not optional)
  rate: Double        // (not optional)
  ```
  * Settings
    * created the model ExchangeRate+CoreDataClass.swift [o] with Codegen to be "Manual/None"
    * delete the +Properties.swift [o]

* Create AppState Entity
  * Make Appstate CoreData (xcdatamodel above)
  ```swift
  ```
## Log
### Lvl 1. Complete

### Lvl 2. Complete
* AutoLayout
![alt text](<Resource/Screen Recording 2025-04-17 at 1.16.52 AM.gif>)

### Lvl 3. Complete

### Lvl 4. Complete

### Lvl 5. Complete

### Lvl 6. Optional - But Complete
* I don't know if this is the convention or not, but I focused on MVVM model rather how to implement. The reason behind is it's not necessary to group and actions / states for this project (if action and state are small)

### Lvl 7 & 8: Complete
* I don't think the initial data must be loaded and push them to cach right away. But I have tested if the arrow icons are displayed if there are data(field changes). It's in `exchangeCalculatorTests/ExchangeRateViewmodelTests`. That's how I ensure that the lvl 7 and 8 are completed.

But test cases are shown below
* If the data(current rate) from API is larger than the cache data's (currency) rate

![alt text](<Resource/Screenshot 2025-04-23 at 4.14.25 PM.png>)

* If the data(current rate) from API is smaller than the cache data's (currency) rate 
![alt text](<Resource/Screenshot 2025-04-23 at 4.14.34 PM.png>)

By using this, we can conclude that the state for direction from ViewModel updates viewcontroller to display direction. 

Below is just whether the cache works or not for favorites

![alt text](<Resource/Screen Recording 2025-04-23 at 4.11.33 PM.gif>)

### Lvl 9 & 10: Complete
![alt text](<Resource/Screen Recording 2025-04-23 at 3.39.21 PM.gif>)

![alt text](<Resource/Screen Recording 2025-04-23 at 3.54.47 PM.gif>)

### Comments: 
* I should've made architecutre clear(usecase, data, presentation, entity), but I didn't because I wanted to focus on implementing the features without considering architecture due to my life's priority.

## Resource
* [Closure, Observable, Combine](https://ios-daniel-yang.tistory.com/entry/iOSSwift-Data-Binding%EC%97%90-%EB%8C%80%ED%95%98%EC%97%AC-%EC%95%8C%EC%95%84%EB%B3%B4%EC%9E%90-Closure-Observable-Combine-MVVM)
* [CustomTableViewCell](https://ios-development.tistory.com/1753)
* [SearchBar](https://zeddios.tistory.com/1196)
* [Case Sensitivity String](https://zeddios.tistory.com/463)
* [Core Data](https://ios-development.tistory.com/236)
* [Dark Mode](https://medium.com/@marwan8/beginner-guide-supporting-dark-mode-in-swift-ios-112aab6d14a6)