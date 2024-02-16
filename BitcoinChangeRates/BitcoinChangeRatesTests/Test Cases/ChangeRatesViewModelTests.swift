//
//  ChangeRatesViewModelTests.swift
//  BitcoinChangeRatesTests
//
//  Created by Berserk on 16/01/2024.
//

import XCTest
@testable import BitcoinChangeRates

final class ChangeRatesViewModelTests: XCTestCase {
    
    var viewModel: ChangeRatesViewModel!
    
    var mockChangeRates: [ChangeRatesModel] = []

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        viewModel = ChangeRatesViewModel(bundleService: BundleService(), networkService: NetworkService())
        
        let currenciesData = loadMock(name: "currencies", extension: "json")
        let bitcoinPricesData = loadMock(name: "bitcoinPrices", extension: "json")
        
        do {
            let mockCurrencies = try JSONDecoder().decode([CurrencyModel].self, from: currenciesData)
            let mockBitcoinPrices = try JSONDecoder().decode(BitcoinPricesModel.self, from: bitcoinPricesData)
            let selectedCurrencies = Constants.URLRequest.defaultSelectedCurrency
            
            mockBitcoinPrices.changeRates.forEach { changeRate in
                
                let isocode = changeRate.key
                let price = changeRate.value
                let isSelected = selectedCurrencies.contains(isocode)
                
                if let currency = mockCurrencies.first(where: { $0.isocode == isocode }) {
                    
                    let changeRate = ChangeRatesModel(name: currency.name, isocode: currency.isocode, localeId: currency.localeId, price: price, isSelected: isSelected)
                    mockChangeRates.append(changeRate)
                }
            }
            
        } catch {
            DebugLogService.log(error)
        }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFetchData_success() {
        
        UserDefaults.standard.removeObject(forKey: Constants.URLRequest.lastRequestTimestamp)
        
        let expectation = self.expectation(description: "FetchData_success")
        
        viewModel.fetchData { result in
            switch result {
            case .success(let success):
                XCTAssertTrue(success)
            case .failure:
                XCTFail("fetchData must not fail in this case")
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5)
    }
    
    func testFilter_emptySearchText() {
        
        viewModel.allChangeRates = mockChangeRates
        viewModel.searchTextDidChange(with: "")
        
        XCTAssertEqual(viewModel.filteredChangeRates.count, 0)
        XCTAssertEqual(viewModel.allChangeRates.count, mockChangeRates.count)
    }
    
    func testFilter_nameSearchText() {
        
        let searchText = "dollar"
        
        viewModel.allChangeRates = mockChangeRates
        
        viewModel.searchTextDidChange(with: searchText)
        let filteredChangeRates = viewModel.allChangeRates.filter({$0.name.contains(searchText)})
        
        XCTAssertEqual(viewModel.filteredChangeRates.count, filteredChangeRates.count)
    }
    
    func testFilter_isocodeSearchText() {
        
        let searchText = "usd"
        
        viewModel.allChangeRates = mockChangeRates
        
        viewModel.searchTextDidChange(with: searchText)
        
        let filteredChangeRates = viewModel.allChangeRates.filter({$0.isocode.contains(searchText)})
        
        XCTAssertEqual(viewModel.filteredChangeRates.count, filteredChangeRates.count)
    }
    
    func testFilterChangeRates_name() {
        
        let searchText = "dollar"
        
        viewModel.allChangeRates = mockChangeRates
        
        viewModel.searchTextDidChange(with: searchText)
                
        let filteredChangeRates = mockChangeRates.filter( {$0.isocode.lowercased().contains(searchText.lowercased()) || $0.name.lowercased().contains(searchText.lowercased())} )
        
        XCTAssertTrue(viewModel.filteredChangeRates.count == filteredChangeRates.count)
        
        viewModel.filteredChangeRates.forEach { changeRate in
            XCTAssertTrue(filteredChangeRates.contains(where: { $0.isocode == changeRate.isocode } ))
        }
    }
    
    func testDidSelect_toggleIsSelected() {
        
        viewModel.allChangeRates = mockChangeRates
        
        let randomElement = viewModel.allChangeRates.randomElement()!
        
        let previousSelectedState = randomElement.isSelected
        
        viewModel.didSelect(item: randomElement)
        
        let selectedElement = viewModel.allChangeRates.first(where: {$0.isocode == randomElement.isocode })!
        
        let newSelectedState = selectedElement.isSelected
        
        XCTAssertEqual(newSelectedState, !previousSelectedState)
    }
    
    func testDidSelect_shouldFetchData() {
        
        viewModel.allChangeRates = mockChangeRates
        
        var randomElement = viewModel.allChangeRates.randomElement()!
        
        randomElement.isSelected = false
        
        viewModel.shouldFetchData = false
        
        viewModel.didSelect(item: randomElement)
        
        XCTAssertTrue(viewModel.shouldFetchData)
    }
    
    func testDidUnSelect_shouldFetchData() {
        
        viewModel.allChangeRates = mockChangeRates
        viewModel.selectedChangeRates = viewModel.allChangeRates.filter({ $0.isSelected })
        
        let randomElement = viewModel.allChangeRates.first(where: { $0.isSelected == true })!
        
        viewModel.shouldFetchData = false
        
        viewModel.didSelect(item: randomElement)
        
        XCTAssertTrue(viewModel.shouldFetchData)
    }
    
    func testDidUnselect_ShouldNotFetchData() {
        
        var shouldSelect = true
        
        viewModel.allChangeRates = mockChangeRates.map({ changeRate in
            var unselectedChangeRate = changeRate
            unselectedChangeRate.isSelected = shouldSelect
            if shouldSelect {
                shouldSelect = false
            }
            return unselectedChangeRate
        })
        
        let selectedItem = viewModel.allChangeRates.first(where: { $0.isSelected })!
        
        viewModel.shouldFetchData = false
        
        viewModel.didSelect(item: selectedItem)
        
        XCTAssertFalse(viewModel.shouldFetchData)
    }
    
    // TODO: - Request conditions
//    func testDidSelect_ShouldNotFetch60sec
}
