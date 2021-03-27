//
//  Stock.swift
//  Stocks
//
//  Created by Анас Бен Мустафа on 3/18/21.
//

import Foundation

/**
 Модель акции
 */
struct Stock: Codable {
    
    init (symbol: String?, description: String?, price: Float?, change: Float?) {
        self.symbol = symbol
        self.description = description
        self.price = price
        self.change = change
    }
    
    init (symbol: String?, description: String?, price: Float?, change: Float?, week52Low: Float?, week52High: Float?, peRatio: Float?, marketCap: Int?) {
        self.symbol = symbol
        self.description = description
        self.price = price
        self.change = change
        self.week52Low = week52Low
        self.week52High = week52High
        self.peRatio = peRatio
        self.marketCap = marketCap
    }
    
    var symbol: String?
    var description: String?
    var price: Float?
    var change: Float?
    var week52Low: Float?
    var week52High: Float?
    var peRatio: Float?
    var marketCap: Int?
}
