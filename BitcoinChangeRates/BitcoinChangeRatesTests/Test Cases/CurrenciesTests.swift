//
//  CurrencyTests.swift
//  BitcoinChangeRatesTests
//
//  Created by Berserk on 09/01/2024.
//

import XCTest
@testable import BitcoinChangeRates

final class CurrenciesTests: XCTestCase {
    
    var currenciesModel: [CurrencyModel]!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let data = loadMock(name: "currencies", extension: "json")
        
        do {
            let currencies = try JSONDecoder().decode([CurrencyModel].self, from: data)
            
            self.currenciesModel = currencies
        } catch {
            print(error)
        }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK: - Conformity tests
    
    func test_usd() {
        
        if let usdCurrency = currenciesModel.first(where: { $0.isocode == "usd" }) {
            
            XCTAssertEqual(usdCurrency.name, "American dollar")
            XCTAssertEqual(usdCurrency.localeId, "en_US")
        } else {
            assertionFailure()
        }
    }
    
    func testAllProperties_NotEmpty() {
        
        currenciesModel.forEach { currency in
            XCTAssertGreaterThan(currency.isocode.count, 0)
            XCTAssertGreaterThan(currency.name.count, 0)
            XCTAssertGreaterThan(currency.localeId.count, 0)
        }
    }

}
