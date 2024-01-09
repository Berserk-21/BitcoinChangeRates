//
//  BitcoinPricesModelTests.swift
//  BitcoinChangeRatesTests
//
//  Created by Berserk on 09/01/2024.
//

import XCTest
@testable import BitcoinChangeRates

final class BitcoinPricesModelTests: XCTestCase {
    
    var bitcoinPrices: BitcoinPricesModel!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let data = loadMock(name: "bitcoinPrices", extension: "json")
        
        do {
            self.bitcoinPrices = try JSONDecoder().decode(BitcoinPricesModel.self, from: data)
        } catch {
            print(error)
        }
    }
    
    func test_EurPrice() {
        
        let eurPrice = bitcoinPrices.bitcoin["eur"]
        
        XCTAssertEqual(eurPrice, 42485)
    }
    
    func test_AllPropertyNotEmpty() {
        
        bitcoinPrices.bitcoin.forEach { (key, value) in
            XCTAssertGreaterThan(key.count, 0)
        }
    }
    
    func test_PropertiesType() {
        
        bitcoinPrices.bitcoin.forEach { (key, value) in
            XCTAssert(type(of: key) == String.self)
            XCTAssert(type(of: value) == Double.self)
        }
    }

}