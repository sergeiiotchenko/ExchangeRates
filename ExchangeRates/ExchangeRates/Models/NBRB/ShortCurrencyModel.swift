//
//  ShortCurrencyModel.swift
//  ExchangeRates
//
//  Created by Сергей Иотченко on 27.02.21.
//

import UIKit

class ShortCurrencyModel: Decodable {
    // MARK: - Enums
    enum CodingKeys: String, CodingKey {
        case curID = "Cur_ID"
        case date = "Date"
        case curOfficialRate = "Cur_OfficialRate"
    }
    
    // MARK: - Variables
    var curID: Int
    var date: String
    var curOfficialRate: Double?
    
    // MARK: - Initialization
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.curID = try container.decode(Int.self, forKey: .curID)
        self.date = try container.decode(String.self, forKey: .date)
        self.curOfficialRate = try container.decodeIfPresent(Double.self, forKey: .curOfficialRate)
    }
}
