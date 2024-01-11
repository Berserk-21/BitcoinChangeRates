//
//  Constants.swift
//  BitcoinChangeRates
//
//  Created by Berserk on 08/01/2024.
//

import Foundation

enum Constants {
    enum Bundle {
        enum Resource {
            static let availableCurrencies = "available_currencies"
        }
        
        enum Extension {
            static let json = "json"
        }
    }
    
    enum SegueIdentifiers {
        static let fromChangeRatesToAddCurrency = "FromChangeRatesToAddCurrency"
    }
    
    enum CellIdentifiers {
        static let addCurrencyTableViewCell = "AddCurrencyTableViewCell"
        static let changeRatesTableViewCell = "ChangeRatesTableViewCell"
    }
    
    enum UserDefaults {
        static let selectedCurrencies = "selectedCurrencies"
    }
    
    enum URLRequest {
        static let defaultUrlEmpty = "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies="
        static let defaultSelectedCurrency = ["eur", "jpy", "usd", "gbp"]
        static let loadingText = "Getting prices from CoinGecko.."
        static let reloadText = "Reload"
        static let requestTimedOut = "Please check your network connection and try again."
    }
    
    enum Notifications {
        static let shouldFetchData = "shouldFetchData"
    }
    
}
