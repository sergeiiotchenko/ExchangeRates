//
//  NetworkService.swift
//  ExchangeRates
//
//  Created by Сергей Иотченко on 16.02.21.
//

import Foundation

class NetworkService {
    // MARK: - Variables
    static let shared = NetworkService()
    
    // MARK: - Initialization
    private init() { }
    
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
    
    func request<Generic: Decodable>(url: String,
                                     successHandler: @escaping (Generic) -> Void,
                                     errorHandler: @escaping (ERNetworkError) -> Void) {

        guard let request = URL(string: url) else { return }
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error: Error = error {
                // Network error handling
                DispatchQueue.main.async {
                    errorHandler(.networkError(error: error))
                }
                return
            } else if let data: Data = data,
                      let response: HTTPURLResponse = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200..<300:
                    // Success server response handling
                    do {
                        let model = try JSONDecoder().decode(Generic.self, from: data)
                        DispatchQueue.main.async {
                            successHandler(model)
                        }
                    } catch let error {
                        DispatchQueue.main.async {
                            errorHandler(.parsingError(error: error))
                            print("pizdecnahuibliad")
                        }
                    }
                case 400..<500:
                    // TODO: - response model error handling
                    break
                case 500...:
                    // Handle server errors
                    DispatchQueue.main.async {
                        errorHandler(.serverError(statusCode: response.statusCode))
                    }
                default:
                    // Handle every unknown error
                    DispatchQueue.main.async {
                        errorHandler(.unknown)
                    }
                }
            }
        }
        dataTask.resume()
    }
}
