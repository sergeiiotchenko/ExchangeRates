//
//  ShortRates.swift
//  ExchangeRates
//
//  Created by Сергей Иотченко on 27.02.21.
//

import UIKit

class ShortRates {
    // MARK: - Variables
    var id: String
    var date: String
    var rate: Double
    
    // MARK: - Initializators
    init(id: String, date: String, rate: Double) {
        self.id = id
        self.date = date
        self.rate = rate
    }
}
