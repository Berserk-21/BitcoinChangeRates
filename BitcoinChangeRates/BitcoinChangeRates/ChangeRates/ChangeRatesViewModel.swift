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

    var shouldFetchData: Bool = false
    
    init(bundleService: BundleService, networkService: NetworkService) {
        self.bundleService = bundleService
        self.networkService = networkService
    }
    
    func fetchData(completionHandler: @escaping (Result<Bool, Error>) -> ()) {
        
        bundleService.fetchLocalData { [weak self] currencies in
            
            self?.networkService.fetchData(with: currencies) { result in
                
                self?.allCurrencies = currencies
                
                switch result {
                case .success(let changeRates):
                    self?.changeRates = changeRates
                    completionHandler(.success(true))
                case .failure(let err):
                    completionHandler(.failure(err))
                }
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
            
            shouldFetchData = true
        }
        
        if let filteredIndex = filteredCurrencies.firstIndex(where: { $0.isocode == item.isocode }) {
            filteredCurrencies[filteredIndex].isSelected.toggle()
            
            shouldFetchData = true
        }
        
    }
    
}
