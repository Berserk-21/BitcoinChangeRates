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
    
    var mockCurrencies: [CurrencyModel]!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        viewModel = ChangeRatesViewModel(bundleService: BundleService(), networkService: NetworkService())
        
        let currenciesData = loadMock(name: "currencies", extension: "json")
        do {
            mockCurrencies = try JSONDecoder().decode([CurrencyModel].self, from: currenciesData)
        } catch {
            DebugLogService.log(error)
        }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFetchData_success() {
        
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
        
        viewModel.filter(with: "")
        
        XCTAssertEqual(viewModel.filteredCurrencies.count, 0)
    }
    
    func testFilter_nameSearchText() {
        
        let searchText = "dollar"
        
        viewModel.allCurrencies = mockCurrencies
        
        viewModel.filter(with: searchText)
        let filteredCurrencies = viewModel.allCurrencies.filter({$0.name.contains(searchText)})
        
        XCTAssertEqual(viewModel.filteredCurrencies.count, filteredCurrencies.count)
    }
    
    func testFilter_isocodeSearchText() {
        
        let searchText = "usd"
        
        viewModel.allCurrencies = mockCurrencies
        
        viewModel.filter(with: searchText)
        
        let filteredCurrencies = viewModel.allCurrencies.filter({$0.isocode.contains(searchText)})
        
        XCTAssertEqual(viewModel.filteredCurrencies.count, filteredCurrencies.count)
    }
    
    func testGetCurrencies_all() {
        
        let searchText = ""
        
        viewModel.allCurrencies = mockCurrencies
        
        viewModel.filter(with: searchText)
        
        let currencies = viewModel.getCurrencies()
        
        XCTAssertEqual(currencies, viewModel.allCurrencies)
    }
    
    func testGetCurrencies_filtered() {
        
        let searchText = "dollar"
        
        viewModel.allCurrencies = mockCurrencies
        
        viewModel.filter(with: searchText)
        
        let currencies = viewModel.getCurrencies()
        
        XCTAssertEqual(currencies, viewModel.filteredCurrencies)
    }
    
    func testDidSelect_allCurrencies_toggle() {
        
        viewModel.allCurrencies = mockCurrencies
        
        let randomElement = viewModel.allCurrencies.randomElement()!
        
        let previousSelectedState = randomElement.isSelected
        
        viewModel.shouldFetchData = false
        viewModel.didSelect(item: randomElement)
        
        let selectedElement = viewModel.allCurrencies.first(where: {$0.isocode == randomElement.isocode })!
        
        XCTAssertEqual(selectedElement.isSelected, !previousSelectedState)
        XCTAssertTrue(viewModel.shouldFetchData)
    }
    
    func testDidSelect_shouldFetchData() {
        
        viewModel.allCurrencies = mockCurrencies
        
        let randomElement = viewModel.allCurrencies.randomElement()!
        
        viewModel.shouldFetchData = false
        
        viewModel.didSelect(item: randomElement)
        
        XCTAssertTrue(viewModel.shouldFetchData)
    }
    
}
