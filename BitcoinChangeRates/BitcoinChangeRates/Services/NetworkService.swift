//
//  NetworkService.swift
//  BitcoinChangeRates
//
//  Created by Berserk on 10/01/2024.
//

import Foundation

final class NetworkService {
    
    let userDefaults = UserDefaults.standard
    
    func fetchData(completionHandler: @escaping (Result<BitcoinPricesModel, Error>) -> ()) {
        
        guard let url = getUrl() else { return }
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15
        
        #if DEBUG
        configuration.timeoutIntervalForRequest = 5
        #endif
        
        let session = URLSession(configuration: configuration)
        let urlRequest = URLRequest(url: url)
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            
            if let err = error {
                print("There was an error with the dataTask: \(err)")
                completionHandler(.failure(err))
            }
            
            guard let unwrappedData = data else { return }
            
            do {
                let bitcoinPrices = try JSONDecoder().decode(BitcoinPricesModel.self, from: unwrappedData)
                
                completionHandler(.success(bitcoinPrices))
            } catch {
                completionHandler(.failure(error))
            }
        }
        
        task.resume()
    }
    
    private func getUrl() -> URL? {
        
        let urlString = buildUrlString()
        
        guard let url = URL(string: urlString) else { return nil }
        
        return url
    }
    
    private func buildUrlString() -> String {
        
        let selectedCurrencies = getSelectedCurrencies()
        
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
    
    private func getSelectedCurrencies() -> [String] {
        
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
