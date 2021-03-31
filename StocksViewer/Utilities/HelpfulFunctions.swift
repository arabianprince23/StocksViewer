//
//  HelpfulFunctions.swift
//  Stocks
//
//  Created by Анас Бен Мустафа on 3/18/21.
//

import SwiftUI
import Foundation

/**
 Получение сегодняшней даты в формате EEE MMM d
 */
func getDate() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ru_RU")
    dateFormatter.setLocalizedDateFormatFromTemplate("EEE MMM d")
    return dateFormatter.string(from: Date())
}

/**
 Тайтл для экрана отчётов компаний
 */
func dateForReports() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM"
    let dateAfterWeek = (Calendar.current.date(byAdding: .day, value: +7, to: Date()) ?? Date()) as Date
    return "\(dateFormatter.string(from: Date())) - \(dateFormatter.string(from: dateAfterWeek))"
}

/**
 Тайтл с датой
 */
func viewDateTitle() -> some View {
    return
        HStack {
            Text(getDate())
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.gray)
            Spacer()
        }
}

/**
 Хедер с названием
 */
func viewHeader(text: String) -> some View {
    return
        HStack {
            Text(text)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Spacer()
        }
}

/**
 Для представления стоимости компании на экране
 */
func separatedNumber(marketCap: Int) -> String {
    
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.groupingSeparator = "."
    formatter.decimalSeparator = ","
    
    return formatter.string(from: NSNumber(value: marketCap))!
}
