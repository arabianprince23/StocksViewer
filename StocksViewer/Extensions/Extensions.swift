//
//  UIApplicationExtension.swift
//  StocksViewer
//
//  Created by Анас Бен Мустафа on 3/19/21.
//

import Foundation
import UIKit
import SwiftUI

// MARK: UIApplication

extension UIApplication {
    
    /**
     По окончании набора текста можно тапнуть в любую часть экрана, чтобы убрать клавиатуру
     */
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


// MARK: Date

extension Date {
    
    func dateComponents(_ components: Set<Calendar.Component>, using calendar: Calendar = .current) -> DateComponents {
        calendar.dateComponents(components, from: self)
    }
    
    func startOfWeek(using calendar: Calendar = .current) -> Date {
        calendar.date(from: dateComponents([.yearForWeekOfYear, .weekOfYear], using: calendar))!
    }
    
    var startOfMonth: Date {
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents([.year, .month], from: self)
            return  calendar.date(from: components)!
    }
    
    var endOfMonth: Date {
            var components = DateComponents()
            components.month = 1
            components.second = -1
            return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!
    }
    
    func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
