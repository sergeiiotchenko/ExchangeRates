//
//  Date+Ex.swift
//  ExchangeRates
//
//  Created by Сергей Иотченко on 26.02.21.
//

import Foundation

extension Date {
    static func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.string(from: Date())
    }
}
