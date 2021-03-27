//
//  News.swift
//  Stocks
//
//  Created by Анас Бен Мустафа on 3/18/21.
//

import Foundation
import SwiftUI

/**
 Модель новости
 */
struct News: Codable {
    let category: String? // Категория новости
    let headline: String? // Заголовок новости
    let url: String? // Ссылка на новость
    let source: String? // Источник новости
}

