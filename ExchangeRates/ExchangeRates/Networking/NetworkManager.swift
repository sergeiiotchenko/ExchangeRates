//
//  NetworkManager.swift
//  ExchangeRates
//
//  Created by Сергей Иотченко on 20.02.21.
//

import UIKit

class NetworkManager {
    // MARK: - Variables
//    private let networkService = NetworkService()
    
    // MARK: - Functions
    func getTodayRates(_ compitionHandler: @escaping ([Rates]) -> Void) {
        
        var actualyRates: [Rates] = []
        var todayRates: [(abbreviation: String, id: Int, date: String, name: String, scale: Int, rate: Double?)] = []
        var previousDayRates: [(abbreviation: String, rate:Double?)] = []
        
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        var pathForYestardayRates: String = ""
        if let yesterday = yesterday {
            pathForYestardayRates = "https://www.nbrb.by/api/exrates/rates?ondate=\(dateFormatter.string(from: yesterday))&periodicity=0"
        }
        
        NetworkService.shared.loadAndParseJSON(urlPath: pathForYestardayRates) { (result) in
            switch result {
            case .success(let rates):
                rates.forEach {
                    previousDayRates.append(($0.curAbbreviation, $0.curOfficialRate))
                }
            case .failure(let error):
                Swift.debugPrint(error)
            }
        }
        
        NetworkService.shared.loadAndParseJSON(urlPath: URLPaths.allRatesURLPath.rawValue) { (result) in
            switch result {
            case .success(let rates):
                rates.forEach {
                    todayRates.append(($0.curAbbreviation, $0.curID, $0.date, $0.curName, $0.curScale, $0.curOfficialRate))
                }
                if todayRates.count == previousDayRates.count {
                    for index in 0..<todayRates.count {
                        if todayRates[index].abbreviation == previousDayRates[index].abbreviation,
                           let todayRate = todayRates[index].rate,
                           let previousRate = previousDayRates[index].rate {
                            switch  todayRate - previousRate {
                            case let value where value > 0:
                                actualyRates.append(Rates.init(abbreviation: todayRates[index].abbreviation,
                                                                    id: String(todayRates[index].id),
                                                                    date: String(todayRates[index].date),
                                                                    name: todayRates[index].name,
                                                                    scale: String(todayRates[index].scale),
                                                                    rate: "\(todayRate) BYN",
                                                                    quote: "+\(String(format: "%.4f", todayRate - previousRate))",
                                                                    color: UIColor.systemRed))
                            case ...0:
                                actualyRates.append(Rates.init(abbreviation: todayRates[index].abbreviation,
                                                                    id: String(todayRates[index].id),
                                                                    date: String(todayRates[index].date),
                                                                    name: todayRates[index].name,
                                                                    scale: String(todayRates[index].scale),
                                                                    rate: "\(todayRate) BYN",
                                                                    quote: "\(String(format: "%.4f", todayRate - previousRate))",
                                                                    color: UIColor.systemGreen))
                            default: break
                            }
                        }
                    }
                }
                compitionHandler(actualyRates)
            case .failure(let error):
                Swift.debugPrint(error)
            }
        }
    }
}
