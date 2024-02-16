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
    
    var allChangeRates: [ChangeRatesModel] = []
    var selectedChangeRates: [ChangeRatesModel] = []
    var filteredChangeRates: [ChangeRatesModel] = []
    
    private var allCurrencies: [CurrencyModel] = []
    private var searchText: String = ""

    var shouldFetchData: Bool = false
    
    private let userDefaults = UserDefaults.standard
    
    init(bundleService: BundleService, networkService: NetworkService) {
        self.bundleService = bundleService
        self.networkService = networkService
    }
    
    func fetchData(completionHandler: @escaping (Result<Bool, Error>) -> ()) {
        
        // Initialize currencies data from Bundle.
        if allCurrencies.isEmpty {
            bundleService.fetchLocalData { allCurrencies in
                self.allCurrencies = allCurrencies
            }
        }
        
        // Prevent multiple requests <60sec.
        guard shouldSendRequest() else {
            completionHandler(.success(false))
            return
        }
        
        // Fetch change rates.
        networkService.fetchChangeRates(for: allCurrencies) { [weak self] result in
            switch result {
            case .success(let changeRates):
                self?.allChangeRates = changeRates
                self?.updateSelectedChangeRates()
                completionHandler(.success(true))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    private func shouldSendRequest() -> Bool {
        
        guard let lastRequestTimestamp = userDefaults.object(forKey: Constants.URLRequest.lastRequestTimestamp) as? TimeInterval else {
            return true
        }
        
        let now = Date().timeIntervalSince1970
        
        if now > lastRequestTimestamp + 60 {
            return true
        }
        
        return false
    }
    
    func searchTextDidChange(with searchText: String) {
        
        filter(with: searchText)
    }
    
    private func filter(with searchText: String) {
        
        self.searchText = searchText
        
        guard searchText.count > 0 else {
            filteredChangeRates = []
            return
        }
        
        filteredChangeRates = allChangeRates.filter( {$0.isocode.lowercased().contains(searchText.lowercased()) || $0.name.lowercased().contains(searchText.lowercased())} ).sorted(by: { $0.isocode < $1.isocode })
    }
    
    private func updateFilteredChangeRates() {
        
        filter(with: searchText)
    }
    
    func getChangeRates() -> [ChangeRatesModel] {
        
        if searchText.isEmpty {
            return allChangeRates
        } else {
            return filteredChangeRates
        }
    }
    
    func didSelectRowAt(indexPath: IndexPath) {
        
        didSelect(item: allChangeRates[indexPath.row])
    }
    
    func didSelect(item: ChangeRatesModel) {
        
        guard isSelectable(item: item) else { return }
        
        if let index = allChangeRates.firstIndex(where: { $0.isocode == item.isocode }) {
            allChangeRates[index].isSelected.toggle()
            
            updateSelectedChangeRates()
            updateFilteredChangeRates()
            
            shouldFetchData = true
        }
        
        updateUserDefaults(for: item)
    }
    
    private func isSelectable(item: ChangeRatesModel) -> Bool {
        
        // An unselected item can always be selected
        if !item.isSelected {
            return true
        }
        
        // A selected item can only be unselected if there are 2 selected items.
        if selectedChangeRates.count > 1 {
            return true
        }
        
        // This item cannot be selected.
        return false
    }
    
    private func updateSelectedChangeRates() {
        
        selectedChangeRates = allChangeRates.filter({ $0.isSelected })
    }
    
    private func updateUserDefaults(for item: ChangeRatesModel) {
        
        if var userCurrencies = userDefaults.object(forKey: Constants.UserDefaults.selectedCurrencies) as? [String] {
            
            let isocode = item.isocode
            
            if item.isSelected {
                userCurrencies.removeAll(where: { $0 == isocode })
            } else {
                userCurrencies.append(isocode)
            }
            
            userDefaults.setValue(userCurrencies, forKey: Constants.UserDefaults.selectedCurrencies)
        }
    }
    
}
