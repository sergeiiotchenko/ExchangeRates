//
//  ERErrors.swift
//  ExchangeRates
//
//  Created by Сергей Иотченко on 10.03.21.
//

import Foundation

enum ERNetworkError {
    case incorrectUrl
    case networkError(error: Error)
    case serverError(statusCode: Int)
    case parsingError(error: Error)
    case unknown
}
