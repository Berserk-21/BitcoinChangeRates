//
//  CustomNumberFormatter.swift
//  BitcoinChangeRates
//
//  Created by Berserk on 09/01/2024.
//

import Foundation

final class CustomNumberFormatter: NSObject {
    
    static let shared = CustomNumberFormatter()
    
    let priceFormatter: NumberFormatter
    
    override init() {
        let priceFormatter = NumberFormatter()
        priceFormatter.numberStyle = .currency
        priceFormatter.decimalSeparator = ","
        priceFormatter.maximumFractionDigits = 8
        priceFormatter.allowsFloats = true
        
        self.priceFormatter = priceFormatter
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getStringFor(model: ChangeRatesSubModel) -> String? {
        
        guard let double = model.changeRate else { return "unknown" }
        
        let localeIdentifier = model.localeId
        
        priceFormatter.locale = Locale(identifier: localeIdentifier)
        
        let string = priceFormatter.string(from: NSNumber(floatLiteral: double))
        
        return string
    }
}
