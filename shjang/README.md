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
```

This can be converted into

```swift
ExchangeRateDto {
    let base_code: String
    let rates: [String: Double]
}
```

## Key

