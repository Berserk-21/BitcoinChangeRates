//
//  ChangeRatesModel.swift
//  BitcoinChangeRates
//
//  Created by Berserk on 05/01/2024.
//

import Foundation

struct ChangeRatesModel: Decodable {
    
    let bitcoin: [String: Double]
    
    var changeRates: [ChangeRatesSubModel] {
        
        var rates: [ChangeRatesSubModel] = []

        for element in bitcoin {
            let rate = ChangeRatesSubModel(name: "", isocode: element.key, localeId: "", changeRate: element.value)
            rates.append(rate)
        }            
        
        return rates
    }
}

struct ChangeRatesSubModel: Decodable {
    let name: String
    let isocode: String
    let localeId: String
    let changeRate: Double
}
