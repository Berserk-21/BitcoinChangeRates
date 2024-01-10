//
//  BundleService.swift
//  BitcoinChangeRates
//
//  Created by Berserk on 10/01/2024.
//

import Foundation

class BundleService {
    
    func fetchLocalData(completionHandler: @escaping ([CurrencyModel]) -> ()) {
        
        guard let url = Bundle.main.url(forResource: Constants.Bundle.Resource.availableCurrencies, withExtension: Constants.Bundle.Extension.json) else { return }
        
        do {
            let data = try Data(contentsOf: url)
            let allCurrencies = try JSONDecoder().decode([CurrencyModel].self, from: data)
            
            completionHandler(allCurrencies)
            
        } catch {
            print(error)
        }
    }
}
