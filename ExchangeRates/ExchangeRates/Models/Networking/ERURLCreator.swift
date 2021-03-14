//
//  ERURLCreator.swift
//  ExchangeRates
//
//  Created by Сергей Иотченко on 8.03.21.
//

import Foundation

class ERURLCreator {
    // MARK: - Variables
    static let shared = ERURLCreator()
    
    // MARK: - Initialization
    private init() { }
    
    // MARK: - Functions
    func getUrl(id curId: String,range count: Int) -> String {
        let endDate = Date.getCurrentDate()
        let startDate = Calendar.current.date(byAdding: .day, value: -count, to: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let startDate = startDate {
            let date = dateFormatter.string(from: startDate)
            return "https://www.nbrb.by/API/ExRates/Rates/Dynamics/\(curId)?startDate=\(date)&endDate=\(endDate)"
        }
        
        return ""
    }
}
