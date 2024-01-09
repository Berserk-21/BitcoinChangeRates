//
//  XCTestCase.swift
//  BitcoinChangeRatesTests
//
//  Created by Berserk on 09/01/2024.
//

import XCTest

extension XCTestCase {
    
    // MARK: - Helper Methods
    
    func loadMock(name: String, extension: String) -> Data {
        
        let bundle = Bundle(for: type(of: self))
        
        let url = bundle.url(forResource: name, withExtension: `extension`)
        
        return try! Data(contentsOf: url!)
    }
    
    
}
