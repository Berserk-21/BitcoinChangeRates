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
    var allCurrencies: [CurrencyModel] = []
    var filteredCurrencies: [CurrencyModel] = []
    private var searchText: String = ""

    private var bitcoinPrices: BitcoinPricesModel?
    private let userDefaults = UserDefaults.standard
    var shouldFetchData: Bool = false
    
    init(bundleService: BundleService, networkService: NetworkService) {
        self.bundleService = bundleService
        self.networkService = networkService
    }
    
    func fetchData(completionHandler: @escaping (Result<Bool, Error>) -> ()) {
        
        bundleService.fetchLocalData { [weak self] currencies in
            self?.allCurrencies = currencies.sorted(by: { $0.isocode < $1.isocode })
            
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
        
        guard let unwrappedBitcoinPrices = bitcoinPrices else { return }
        
        var changeRates: [ChangeRatesModel] = []
        
        unwrappedBitcoinPrices.bitcoin.forEach { element in
            
            let isocode = element.key
            let price = element.value
            
            if let currency = allCurrencies.first(where: { $0.isocode == isocode }) {
                
                let changeRate = ChangeRatesModel(name: currency.name, isocode: currency.isocode, localeId: currency.localeId, price: price)
                changeRates.append(changeRate)
            }
        }
        
        self.changeRates = changeRates.sorted(by: { $0.isocode < $1.isocode })
    }
    
    private func updateIsSelectedState() {
        
        let isocodes = bitcoinPrices?.bitcoin.keys
        
        isocodes?.forEach { isocode in
            if let index = allCurrencies.firstIndex(where: { $0.isocode == isocode }) {
                allCurrencies[index].isSelected = true
            }
        }
    }
    
    func filter(with searchText: String) {
        
        self.searchText = searchText
        
        guard searchText.count > 0 else {
            filteredCurrencies = []
            return
        }
        
        filteredCurrencies = allCurrencies.filter( {$0.isocode.lowercased().contains(searchText.lowercased()) || $0.name.lowercased().contains(searchText.lowercased())} ).sorted(by: { $0.isocode < $1.isocode })
    }
    
    func getCurrencies() -> [CurrencyModel] {
        
        if searchText.isEmpty {
            return allCurrencies
        } else {
            return filteredCurrencies
        }
    }
    
    func didSelect(item: CurrencyModel) {
        
        if let index = allCurrencies.firstIndex(where: { $0.isocode == item.isocode }) {
            allCurrencies[index].isSelected.toggle()
        }
        
        if let filteredIndex = filteredCurrencies.firstIndex(where: { $0.isocode == item.isocode }) {
            filteredCurrencies[filteredIndex].isSelected.toggle()
        }
        
        shouldFetchData = true
    }
    
}
