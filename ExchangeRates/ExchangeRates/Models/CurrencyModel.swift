//
//  CurrencyModel.swift
//  ExchangeRates
//
//  Created by Сергей Иотченко on 14.02.21.
//

import UIKit

class CurrencyModel: Decodable {
    // MARK: - Enums
    enum CodingKeys: String, CodingKey {
        case curID = "Cur_ID"
        case date = "Date"
        case curAbbreviation = "Cur_Abbreviation"
        case curScale = "Cur_Scale"
        case curName = "Cur_Name"
        case curOfficialRate = "Cur_OfficialRate"
    }
    
    // MARK: - Variables
    var curID: Int
    var date: String
    var curAbbreviation: String
    var curScale: Int
    var curName: String
    var curOfficialRate: Double
    
    // MARK: - Initialization
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.curID = try! container.decode(Int.self, forKey: .curID)
        self.date = try! container.decode(String.self, forKey: .date)
        self.curAbbreviation = try! container.decode(String.self, forKey: .curAbbreviation)
        self.curScale = try! container.decode(Int.self, forKey: .curScale)
        self.curName = try! container.decode(String.self, forKey: .curName)
        self.curOfficialRate = try! container.decode(Double.self, forKey: .curOfficialRate)
    }
}
