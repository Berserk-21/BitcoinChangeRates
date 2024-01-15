//
//  BundleService.swift
//  BitcoinChangeRates
//
//  Created by Berserk on 10/01/2024.
//

import Foundation

final class BundleService {
    
    func fetchLocalData(completionHandler: @escaping ([CurrencyModel]) -> ()) {
        
        guard let url = Bundle.main.url(forResource: Constants.Bundle.Resource.availableCurrencies, withExtension: Constants.Bundle.Extension.json) else { return }
        
        do {
            let data = try Data(contentsOf: url)
            let allCurrencies = try JSONDecoder().decode([CurrencyModel].self, from: data)
            let updatedCurrencies = updateIsSelectedState(for: allCurrencies)
            completionHandler(updatedCurrencies)
            
        } catch {
            DebugLogService.log(error)
        }
    }
    
    private func updateIsSelectedState(for currencies: [CurrencyModel]) -> [CurrencyModel] {
        
        let isocodes = UserDefaults.getSelectedCurrencies()

        let updatedCurrencies = currencies.map { currency in
            
            var updatedCurrency = currency
            
            updatedCurrency.isSelected = isocodes.contains(currency.isocode)
            
            return updatedCurrency
        }
        
        return updatedCurrencies.sorted(by: { $0.isocode < $1.isocode })
    }
    
}
