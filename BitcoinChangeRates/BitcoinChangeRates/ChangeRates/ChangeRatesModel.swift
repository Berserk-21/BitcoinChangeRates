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
    var isSelected: Bool
    
    init(name: String, isocode: String, localeId: String, price: Double, isSelected: Bool) {
        self.name = name
        self.isocode = isocode
        self.localeId = localeId
        self.price = price
        self.isSelected = isSelected
    }
}

struct BitcoinPricesModel: Decodable {
    
    let changeRates: [String: Double]
    
    enum CodingKeys: String, CodingKey {
        case changeRates = "bitcoin"
    }
}

struct CurrencyModel: Decodable, Equatable {
    let name: String
    let isocode: String
    let localeId: String
}
