//
//  StorageManager.swift
//  StocksViewer
//
//  Created by Анас Бен Мустафа on 3/20/21.
//

import Foundation
import SwiftUI
import CoreData

extension StocksData {
    
    // MARK: Work with CoreData
    
    /**
     Сохранение акции по тикеру в CoreData
     */
    func saveStockSymbol(with symbol: String) {
        
        //
        // Добавление в массив с избранными акциями
        //
        self.favoriteStocks.append(symbol)
        
        //
        // Сохранение изменений в контексте
        //
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "StockSymbolEntitie", in: context) else { return }
        
        let stockObject = StockSymbolEntitie(entity: entity, insertInto: context)
        stockObject.symbol = symbol
        
        do {
            try context.save()
            favoriteStocksCData.append(stockObject)
        } catch let error as NSError {
            context.rollback()
            print(error.localizedDescription)
        }
    }
    
    /**
     Удаление акции из списка избранного в CoreData
     */
    func deleteTask(with symbol: String)
    {
        //
        // Удаление из массива с избранными акциями
        //
        self.favoriteStocks.removeAll(where: { $0 == symbol })
        
        //
        // Сохранение изменений в контексте
        //
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let s = favoriteStocksCData.filter { $0.symbol == symbol }[0]
        
        context.delete(s)
        
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
