//
//  StockData.swift
//  StocksViewer
//
//  Created by Анас Бен Мустафа on 3/18/21.
//

import Foundation
import SwiftUI
import CoreData
import Cache

/**
 Класс, хранящий в себе все основные данные пользователя, и отвечающий за работу с хранилищем
 */
public class StocksData: ObservableObject {
    
    // Избранные акции
    @Published var isInternetAvailible: Bool
    @Published var favoriteStocksCData: [StockSymbolEntitie] = []
    @Published var favoriteStocks: [String] = []
    @Published var stocksCacheStorage: Storage<String, Stock>?
    @Published var newsCacheStorage: Storage<String, [News]>?
    private let stocksDiskConfig: DiskConfig
    private let stocksMemoryConfig: MemoryConfig
    private let newsDiskConfig: DiskConfig
    private let newsMemoryConfig: MemoryConfig
    
    init() {
        
        self.isInternetAvailible = Reachability.isConnectedToNetwork()
        
        //
        // Кэшированные данные
        //
        self.stocksDiskConfig = DiskConfig(name: "stocksCache")
        self.stocksMemoryConfig = MemoryConfig(expiry: .never)
        self.newsDiskConfig = DiskConfig(name: "newsCache")
        self.newsMemoryConfig = MemoryConfig(expiry: .never)
        
        do {
            self.stocksCacheStorage = try Storage(diskConfig: stocksDiskConfig, memoryConfig: stocksMemoryConfig, transformer: TransformerFactory.forCodable(ofType: Stock.self))
            self.newsCacheStorage = try Storage(diskConfig: newsDiskConfig, memoryConfig: newsMemoryConfig, transformer: TransformerFactory.forCodable(ofType: [News].self))
        } catch {
          print("Cache storage error")
        }
        
        //
        //  Список избранных акций
        //
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext // Получение контекста
        
        let fetchRequest: NSFetchRequest<StockSymbolEntitie> = StockSymbolEntitie.fetchRequest()
        
        do {
            favoriteStocksCData = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        for symbol in favoriteStocksCData {
            favoriteStocks.append(symbol.symbol ?? "")
        }
    }
    
}
