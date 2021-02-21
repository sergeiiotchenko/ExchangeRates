//
//  Rates.swift
//  ExchangeRates
//
//  Created by Сергей Иотченко on 20.02.21.
//

import UIKit

class Rates {
    // MARK: - Variables
    var abbreviation: String
    var id: String
    var date: String
    var name: String
    var scale: String
    var rate: String
    var quote: String
    var color: UIColor
    
    // MARK: - Initializators
    init(abbreviation: String, id: String, date: String, name: String, scale: String, rate: String, quote: String, color: UIColor) {
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
