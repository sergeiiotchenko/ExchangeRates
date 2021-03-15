//
//  NetworkManager.swift
//  ExchangeRates
//
//  Created by Сергей Иотченко on 20.02.21.
//

import UIKit

class NetworkManager {
    // MARK: - Variables
    static let shared = NetworkManager()
    
    // MARK: - Initialization
    private init() { }
    
    // MARK: - Functions
    func getTodayRates(_ compitionHandler: @escaping ([NBRBRates]) -> Void) {
        var actualyRates: [NBRBRates] = []
        var todayRates: [(abbreviation: String, id: Int, date: String, name: String, scale: Int, rate: Double?)] = []
        var previousDayRates: [(abbreviation: String, rate:Double?)] = []
        var pathForYestardayRates: String = ""
        
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
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
                                actualyRates.append(NBRBRates.init(abbreviation: todayRates[index].abbreviation,
                                                                   id: String(todayRates[index].id),
                                                                   date: todayRates[index].date,
                                                                   name: todayRates[index].name,
                                                                   scale: todayRates[index].scale,
                                                                   rate: todayRate,
                                                                   quote: "+\(String(format: "%.4f", todayRate - previousRate))",
                                                                   color: UIColor.systemRed))
                            case ...0:
                                actualyRates.append(NBRBRates.init(abbreviation: todayRates[index].abbreviation,
                                                                   id: String(todayRates[index].id),
                                                                   date: todayRates[index].date,
                                                                   name: todayRates[index].name,
                                                                   scale: todayRates[index].scale,
                                                                   rate: todayRate,
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
    
    func getRatesForACertainPeriod(id curId: String, range count: Int,_ complitionHandler: @escaping ([ShortRates]) -> Void) {
        var dinamicRatesPerWeek: [ShortRates] = []
        
        let path = ERURLCreator.shared.getUrl(id: curId, range: count)
        
        NetworkService.shared.request(url: path,
                                      successHandler: { (model: [ShortCurrencyModel]) in
                                        model.forEach { rate in
                                            if let officialRates = rate.curOfficialRate {
                                                dinamicRatesPerWeek.append(ShortRates.init(id: String(rate.curID),
                                                                                           date: convertDateFormat(inputDate: rate.date),
                                                                                           rate: officialRates))
                                            } else {
                                                dinamicRatesPerWeek.append(ShortRates.init(id: String(rate.curID),
                                                                                           date: convertDateFormat(inputDate: rate.date),
                                                                                           rate: 0.0000))
                                            }
                                        }
                                        complitionHandler(dinamicRatesPerWeek)
                                      },
                                      errorHandler: { (error: ERNetworkError) in
                                        print(error)
                                      })
    }
}
