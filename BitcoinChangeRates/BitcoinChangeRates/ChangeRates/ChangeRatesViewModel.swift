//
//  ChangeRatesViewModel.swift
//  BitcoinChangeRates
//
//  Created by Berserk on 05/01/2024.
//

import Foundation

class ChangeRatesViewModel {
    
    var finalRates: [ChangeRatesSubModel] = []
    
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
                let changeRatesModel = try JSONDecoder().decode(ChangeRatesModel.self, from: unwrappedData)
                
                self.updateLocalData(with: changeRatesModel)
                
                completionHandler(true)
            } catch {
                completionHandler(false)
                print(error)
            }
        }
        
        task.resume()
    }
    
    private func updateLocalData(with model: ChangeRatesModel) {
        
        model.changeRates.forEach { cloudElement in
            
            if let index = self.finalRates.firstIndex(where: { $0.isocode == cloudElement.isocode }) {
                
                self.finalRates[index].changeRate = cloudElement.changeRate
            }
        }
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
            let changeRates = try JSONDecoder().decode([ChangeRatesSubModel].self, from: data)
            
            self.finalRates = changeRates
            
        } catch {
            print(error)
        }
    }
    
}
