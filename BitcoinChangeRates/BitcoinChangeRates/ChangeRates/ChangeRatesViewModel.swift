//
//  ChangeRatesViewModel.swift
//  BitcoinChangeRates
//
//  Created by Berserk on 05/01/2024.
//

import Foundation

class ChangeRatesViewModel {
    
    var rates: [ChangeRatesSubModel] = []
    
    func fetchData(completionHandler: @escaping (Bool) -> ()) {
        
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
                let decodedData = try JSONDecoder().decode(ChangeRatesModel.self, from: unwrappedData)
                self.rates = decodedData.changeRates
                completionHandler(true)
            } catch {
                completionHandler(false)
                print(error)
            }
        }
        
        task.resume()
    }
    
    private func getUrl() -> URL? {
        
        let urlString = "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=eur%2Cjpy"
        
        guard let url = URL(string: urlString) else { return nil }
        
        return url
    }
    
}
