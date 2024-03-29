//
//  Rates.swift
//  ExchangeRates
//
//  Created by Сергей Иотченко on 20.02.21.
//

import UIKit

class NBRBRates {
    // MARK: - Variables
    var abbreviation: String
    var id: String
    var date: String
    var name: String
    var scale: Int
    var rate: Double
    var quote: String
    var color: UIColor
    
    // MARK: - Initializators
    init(abbreviation: String, id: String, date: String, name: String, scale: Int, rate: Double, quote: String, color: UIColor) {
        self.abbreviation = abbreviation
        self.id = id
        self.date = date
        self.name = name
        self.scale = scale
        self.rate = rate
        self.quote = quote
        self.color = color
    }
}
