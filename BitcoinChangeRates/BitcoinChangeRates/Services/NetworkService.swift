//
//  NetworkService.swift
//  BitcoinChangeRates
//
//  Created by Berserk on 10/01/2024.
//

import Foundation

final class NetworkService {
    
    let userDefaults = UserDefaults.standard
    
    func fetchChangeRates(for currencies: [CurrencyModel], completionHandler: @escaping (Result<[ChangeRatesModel], Error>) -> ()) {
        
        guard let url = getUrl(for: currencies) else { return }
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15
        
        #if DEBUG
        configuration.timeoutIntervalForRequest = 5
        #endif
        
        let session = URLSession(configuration: configuration)
        let urlRequest = URLRequest(url: url)
        
        DebugLogService.log("send request for url: \(url.absoluteString)")
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            
            if let err = error {
                DebugLogService.log("There was an error with the dataTask: \(err)")
                completionHandler(.failure(err))
            }
            
            guard let unwrappedData = data else { return }
            
            DebugLogService.log(unwrappedData)
            
            do {
                let bitcoinPrices = try JSONDecoder().decode(BitcoinPricesModel.self, from: unwrappedData)
                self.save(changeRates: bitcoinPrices.changeRates)
                
                let changeRatesModel = self.prepareChangeRates(for: bitcoinPrices, with: currencies)
                completionHandler(.success(changeRatesModel))
            } catch {
                completionHandler(.failure(error))
            }
        }
        
        task.resume()
        
        let timestamp = Date().timeIntervalSince1970
        userDefaults.setValue(timestamp, forKey: Constants.URLRequest.lastRequestTimestamp)
    }
    
    // Store all change rates in UserDefaults
    private func save(changeRates: [String: Double]) {
        
        self.userDefaults.setValue(changeRates, forKey: Constants.UserDefaults.changeRates)
    }
    
    // Uses change rates and local currency data to build a list of ChangeRatesModel.
    private func prepareChangeRates(for bitcoinPrices: BitcoinPricesModel, with currencies: [CurrencyModel]) -> [ChangeRatesModel] {
        
        var changeRates: [ChangeRatesModel] = []
        
        let selectedCurrencies = getSelectedCurrencies()
        
        bitcoinPrices.changeRates.forEach { changeRate in
            
            let isocode = changeRate.key
            let price = changeRate.value
            let isSelected = selectedCurrencies.contains(isocode)
            
            if let currency = currencies.first(where: { $0.isocode == isocode }) {
                
                let changeRate = ChangeRatesModel(name: currency.name, isocode: currency.isocode, localeId: currency.localeId, price: price, isSelected: isSelected)
                changeRates.append(changeRate)
            }
        }
        
        return changeRates.sorted(by: { $0.isocode < $1.isocode })
    }
    
    // Build an url to get all currencies change rates.
    private func getUrl(for currencies: [CurrencyModel]) -> URL? {
        
        var urlString = Constants.URLRequest.defaultUrlEmpty
        
        for i in 0...currencies.count - 1 {
            switch i {
            case currencies.count - 1 :
                urlString.append(currencies[i].isocode.lowercased())
            default:
                urlString.append(currencies[i].isocode.lowercased())
                urlString.append("%2C")
            }
        }
        
        guard let url = URL(string: urlString) else { return nil }
        
        return url
    }
    
    // Get a list of selected currencies isocode from UserDefaults.
    private func getSelectedCurrencies() -> [String] {
        
        let userDefaults = UserDefaults.standard
        
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
        
        return selectedCurrencies
    }
}
