//
//  ChangeRatesViewModel.swift
//  BitcoinChangeRates
//
//  Created by Berserk on 05/01/2024.
//

import Foundation

final class ChangeRatesViewModel {
    
    // MARK: - Properties
    
    let bundleService: BundleService
    let networkService: NetworkService
    
    var changeRates: [ChangeRatesModel] = []
    var allCurrencies: [CurrencyModel]?

    private var bitcoinPrices: BitcoinPricesModel?
    private let userDefaults = UserDefaults.standard
    
    init(bundleService: BundleService, networkService: NetworkService) {
        self.bundleService = bundleService
        self.networkService = networkService
    }
    
    func fetchData(completionHandler: @escaping (Result<Bool, Error>) -> ()) {
        
        bundleService.fetchLocalData { [weak self] currencies in
            self?.allCurrencies = currencies
            
            self?.networkService.fetchData { result in
                
                switch result {
                case .success(let bitcoinPrices):
                    self?.bitcoinPrices = bitcoinPrices
                    self?.prepareChangeRates()
                    self?.updateIsSelectedState()
                    completionHandler(.success(true))
                case .failure(let err):
                    completionHandler(.failure(err))
                }
            }
        }
    }
    
    private func prepareChangeRates() {
        
        guard let unwrappedCurrencies = allCurrencies else { return }
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
    
    private func updateIsSelectedState() {
        
        let isocodes = bitcoinPrices?.bitcoin.keys
        
        isocodes?.forEach { isocode in
            if let index = allCurrencies?.firstIndex(where: { $0.isocode == isocode }) {
                allCurrencies?[index].isSelected = true
            }
        }
    }
    
}
