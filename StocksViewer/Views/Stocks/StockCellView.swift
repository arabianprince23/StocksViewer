//
//  StockCellView.swift
//  Stocks
//
//  Created by Анас Бен Мустафа on 3/18/21.
//

import SwiftUI

/**
 Ячейка избранной акции с главного экрана
 */
struct StockCellView: View {
    
    @EnvironmentObject var stocksData: StockData
    @ObservedObject var webService: WebService = WebService()
    @State var stock: Stock = Stock(symbol: "-", description: "-", price: nil, change: nil)
    @State var showDeleteAlert: Bool = false
    @State var showDetailsView: Bool = false
    var stockSymbol: String
    var cachedStock: Stock
    
    init(stockSymbol: String) {
        self.stockSymbol = stockSymbol
        self.cachedStock = Stock(symbol: "-", description: "-", price: nil, change: nil)
    }
    
    init(stock: Stock) {
        self.stockSymbol = stock.symbol ?? "-"
        self.cachedStock = Stock(symbol: stock.symbol, description: stock.description, price: stock.price, change: stock.change)
    }
    
    var body: some View {
        HStack {
            HStack {
                VStack (alignment: .leading) {
                    HStack {
                        Text(stock.symbol ?? "-")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                        
                        Image(systemName: "info.circle")
                            .foregroundColor(.blue)
                            .onTapGesture {
                                self.showDetailsView.toggle()
                            }
                            .sheet(isPresented: $showDetailsView, content: {
                                StockDetailsView(stock: self.stock)
                            })
                    }
                    
                    Text(stock.description ?? "-")
                        .font(.title3)
                        .foregroundColor(Color.gray)
                }
            }
            Spacer()
            
            VStack (alignment: .trailing,spacing: 4) {
                Text("\(NSString(format: "%.2f", stock.price ?? ""))")
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                
                if ((stock.change ?? 0.0) >= 0) {
                    Text("     +\(NSString(format: "%.2f", stock.change ?? ""))")
                        .foregroundColor(Color.white)
                        .font(.subheadline)
                        .bold()
                        .padding(2)
                        .padding(.trailing, 4)
                        .background(Color.green)
                        .cornerRadius(4)
                } else {
                    Text("     \(NSString(format: "%.2f", stock.change ?? ""))")
                        .foregroundColor(Color.white)
                        .font(.subheadline)
                        .bold()
                        .padding(2)
                        .padding(.trailing, 4)
                        .background(Color.red)
                        .cornerRadius(4)
                }
            }
        }
        .frame(height: 70)
        .background(Color.black)
        .onAppear() {
            //
            // Если есть доступ к сети, делаем запрос на сервер и получаем информацию по акции
            //
            if (stocksData.isInternetAvailible) {
                webService.getStockBySymbol(symbol: stockSymbol) { res in
                    self.stock = res
                    try? stocksData.stocksCacheStorage?.setObject(Stock(symbol: self.stock.symbol, description: self.stock.description, price: self.stock.price, change: self.stock.change), forKey: "\(self.stock.symbol ?? "-")")
                }
            } else {
                //
                // Иначе, отображаем кэшированные данные
                //
                self.stock = cachedStock
            }
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        
        //
        // При долгом удержании пальца на ячейке, выскакивает алёрт с предложением удалить выбранную избранную акцию, сопровождается приятной вибрацией
        //
        .onLongPressGesture {
            self.showDeleteAlert = true
            UIImpactFeedbackGenerator(style: .soft).impactOccurred(intensity: 1)
        }
        .alert(isPresented: $showDeleteAlert, content: {
            Alert(title: Text("Удаление из избранного"),
                  message: Text("Вы уверены, что хотите удалить \(stock.symbol ?? "") из избранного?"),
                  primaryButton: .destructive(Text("Удалить")) {
                    stocksData.deleteTask(with: self.stock.symbol ?? "")
                  },
                  secondaryButton: .cancel(Text("Отменить")))
        })
    }
}
