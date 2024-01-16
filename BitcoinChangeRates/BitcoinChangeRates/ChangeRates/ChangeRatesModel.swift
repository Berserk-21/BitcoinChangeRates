//
//  ChangeRatesModel.swift
//  BitcoinChangeRates
//
//  Created by Berserk on 05/01/2024.
//

import Foundation

struct ChangeRatesModel {
    
    let name: String
    let isocode: String
    let localeId: String
    let price: Double
    
    init(name: String, isocode: String, localeId: String, price: Double) {
        self.name = name
        self.isocode = isocode
        self.localeId = localeId
        self.price = price
    }
}

struct BitcoinPricesModel: Decodable {
    
    let bitcoin: [String: Double]
}

struct CurrencyModel: Decodable, Equatable {
    let name: String
    let isocode: String
    let localeId: String
    var isSelected: Bool
}
