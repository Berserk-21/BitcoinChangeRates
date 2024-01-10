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
}
