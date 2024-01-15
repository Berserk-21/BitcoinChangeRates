//
//  DebugLogService.swift
//  BitcoinChangeRates
//
//  Created by Berserk on 15/01/2024.
//

import Foundation

class DebugLogService {
    
    static func log<T>(_ object: T) {
        
        #if DEBUG
        if let string = object as? String {
            print(string)
        } else if let data = object as? Data, let string = String(data: data, encoding: .utf8) {
            print(string)
        } else if let error = object as? Error {
            print(error)
        } else {
            print("DebugLog object unrecognized")
        }
        #endif
    }
    
}
