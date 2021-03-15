//
//  String+Ex.swift
//  ExchangeRates
//
//  Created by Сергей Иотченко on 4.03.21.
//

import UIKit

func convertDateFormat(inputDate: String) -> String {
    let olDateFormatter = DateFormatter()
    olDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    
    guard let oldDate = olDateFormatter.date(from: inputDate) else { return "00.00" }
    
    let convertDateFormatter = DateFormatter()
    convertDateFormatter.dateFormat = "dd.MM.yyyy"
    return convertDateFormatter.string(from: oldDate)
}

extension String {
    var toDouble: Double {
        return Double(self) ?? 0.0
    }
}
