//
//  ChangeRatesViewModel.swift
//  BitcoinChangeRates
//
//  Created by Berserk on 05/01/2024.
//

import Foundation

final class ChangeRatesViewModel {
    
    var changeRates: [ChangeRatesModel] = []
    
    private var bitcoinPrices: BitcoinPricesModel?
    private var currencies: [CurrencyModel]?
    
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
        
        let urlString = "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=eur%2Cjpy%2Cusd%2Caud%2Ccad%2Cchf%2Cgbp%2Cnzd"
        
        guard let url = URL(string: urlString) else { return nil }
        
        return url
    }
    
    private func fetchLocalData() {
        
        guard let url = Bundle.main.url(forResource: Constants.Keys.availableCurrencies, withExtension: "json") else { return }
        
        do {
            let data = try Data(contentsOf: url)
            let currencies = try JSONDecoder().decode([CurrencyModel].self, from: data)
            
            self.currencies = currencies
            
        } catch {
            print(error)
        }
    }
    
}
