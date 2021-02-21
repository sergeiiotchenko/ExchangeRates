//
//  NetworkService.swift
//  ExchangeRates
//
//  Created by Сергей Иотченко on 16.02.21.
//

import Foundation

class NetworkService {
    // MARK: - Methods
    func loadAndParseJSON(urlPath: String, completionHandler: @escaping (Result<[CurrencyModel], Error>) -> Void) {
        guard let url = URL(string: urlPath) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completionHandler(.failure(error))
                    
                    return
                }
                guard let data = data else { return }
                do {
                    let rates: [CurrencyModel] = try JSONDecoder().decode([CurrencyModel].self, from: data)
                    completionHandler(.success(rates))
                } catch let jsonError {
                    completionHandler(.failure(jsonError))
                }
            }
        }.resume()
    }
}
