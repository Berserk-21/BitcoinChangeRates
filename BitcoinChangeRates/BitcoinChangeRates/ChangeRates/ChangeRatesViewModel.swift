//
//  ChangeRatesViewModel.swift
//  BitcoinChangeRates
//
//  Created by Berserk on 05/01/2024.
//

import Foundation

final class ChangeRatesViewModel {
    
    var changeRates: [ChangeRatesModel] = []
    var currencies: [CurrencyModel]?

    private var bitcoinPrices: BitcoinPricesModel?
    private let userDefaults = UserDefaults.standard
    
    func fetchData(completionHandler: @escaping (Bool) -> ()) {
        
        fetchLocalData()
        
        guard let url = getUrl() else { return }
        
        let session = URLSession(configuration: .default)
        let urlRequest = URLRequest(url: url)
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            
            if let err = error {
                print("There was an error with the dataTask: \(err)")
                completionHandler(false)
            }
            
            guard let unwrappedData = data else { return }
            
            do {
                self.bitcoinPrices = try JSONDecoder().decode(BitcoinPricesModel.self, from: unwrappedData)
                self.prepareChangeRates()
                completionHandler(true)
            } catch {
                print(error)
                completionHandler(false)
            }
        }
        
        task.resume()
    }
    
    private func prepareChangeRates() {
        
        guard let unwrappedCurrencies = currencies else { return }
        guard let unwrappedBitcoinPrices = bitcoinPrices else { return }
        
        var changeRates: [ChangeRatesModel] = []
        
        unwrappedBitcoinPrices.bitcoin.forEach { element in
            
            let isocode = element.key
            let price = element.value
            
            if let currency = unwrappedCurrencies.first(where: { $0.isocode == isocode }) {
                
                let changeRate = ChangeRatesModel(name: currency.name, isocode: currency.isocode, localeId: currency.localeId, price: price)
                changeRates.append(changeRate)
            }
        }
        
        self.changeRates = changeRates
    }
    
    private func getUrl() -> URL? {
        
        let urlString = buildUrlString()
        
        guard let url = URL(string: urlString) else { return nil }
        
        return url
    }
    
    private func buildUrlString() -> String {
        
        let selectedCurrencies: [String]
        
        if let userCurrencies = userDefaults.object(forKey: Constants.UserDefaults.selectedCurrencies) as? [String] {
            // Use user selected currencies
            selectedCurrencies = userCurrencies
        } else {
            // Use default state
            selectedCurrencies = Constants.URLRequest.defaultSelectedCurrency
            
            // set default state in UserDefaults
            userDefaults.set(selectedCurrencies, forKey: Constants.UserDefaults.selectedCurrencies)
        }
        
        let cleanedSelectedCurrencies = selectedCurrencies.filter({ !$0.isEmpty })
        
        var urlString = Constants.URLRequest.defaultUrlEmpty
        
        for i in 0...cleanedSelectedCurrencies.count - 1 {
            switch i {
            case selectedCurrencies.count - 1 :
                urlString.append(selectedCurrencies[i])
            default:
                urlString.append(selectedCurrencies[i])
                urlString.append("%2C")
            }
        }
        
        return urlString
    }
    
    private func fetchLocalData() {
        
        guard let url = Bundle.main.url(forResource: Constants.Bundle.Resource.availableCurrencies, withExtension: Constants.Bundle.Extension.json) else { return }
        
        do {
            let data = try Data(contentsOf: url)
            let currencies = try JSONDecoder().decode([CurrencyModel].self, from: data)
            
            self.currencies = currencies
            
        } catch {
            print(error)
        }
    }
    
}
