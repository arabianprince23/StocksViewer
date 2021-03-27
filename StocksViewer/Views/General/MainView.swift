//
//  MainView.swift
//  Stocks
//
//  Created by Анас Бен Мустафа on 3/18/21.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var stocksData: StockData
    @ObservedObject var webService: WebService
    @State var searchTerm: String = "" // Запрос в поиске
    @State var searchResponseStocks: [SearchStock] = [] // Массив, обновляющийся в зависимости от запроса
    @State var timer: Timer?
    @State var showCleanCacheAlert: Bool = false
    
    init() {
        webService = WebService()
        UITableViewCell.appearance().backgroundColor = .black
        UITableView.appearance().backgroundColor = .black
        UITextField.appearance().keyboardAppearance = UIKeyboardAppearance.dark
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                Color(.black)
                    .edgesIgnoringSafeArea(.all)
                
                VStack (alignment: .leading) {
                    
                    //
                    // Верхняя часть, титулы
                    //
                    VStack {
                        viewHeader(text: "Акции")
                        HStack {
                            viewDateTitle()
                            Spacer()
                            Text("Clean cache")
                                .foregroundColor(.blue)
                                .font(.system(size: 16))
                                .onTapGesture {
                                    self.showCleanCacheAlert.toggle()
                                }
                                .alert(isPresented: $showCleanCacheAlert, content: {
                                    Alert(title: Text("Очистка кэша"),
                                          message: Text("Вы уверены, что хотите очистить кэш приложения?"),
                                          primaryButton: .destructive(Text("Очистить")) {
                                            try? stocksData.stocksCacheStorage?.removeAll()
                                            try? stocksData.newsCacheStorage?.removeAll()
                                          },
                                          secondaryButton: .cancel(Text("Отменить")))
                                })
                        }
                    }
                    .padding([.leading, .trailing, .top])
                    
                    if (stocksData.isInternetAvailible) {
                        VStack {
                            
                            //
                            // Поисковая панель
                            //
                            SearchView(searchTerm: $searchTerm)
                                .frame(height: 40)
                                .padding(.top, -4)
                                //
                                // При внесении изменений в текстфилд, делаем запрос для поиска по значению в текстфилде
                                //
                                .onChange(of: searchTerm, perform: { value in
                                    
                                    //
                                    // Для того, чтобы не реагировать на абсолютно каждое изменение пользователя и дождаться примерно нужного результата его запроса,
                                    // запросы на сервер будем делать раз в 25мс
                                    //
                                    timer?.invalidate()
                                    timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false, block: { (_) in
                                        webService.getSearchingStocks(searchTerm: value) { searchStocks in
                                            self.searchResponseStocks = searchStocks
                                        }
                                    })
                                })
                            
                            //
                            // Список акций
                            // До тех пор, пока поисковый запрос отстается пустым, отображаем пользователю его избранные ценные бумаги
                            // Как только поисковый запрос появляется, пользователю отображаются данные, пришедшие с сервера по его запросу
                            //
                            if (searchTerm == "") {
                                List {
                                    ForEach(stocksData.favoriteStocks, id: \.self) { symbol in
                                        StockCellView(stockSymbol: symbol)
                                    }
                                    .listRowBackground(Color.black)
                                }
                                .background(Color.black)
                            } else {
                                List {
                                    ForEach(searchResponseStocks, id: \.symbol) { searchStock in
                                        SearchStockCellView(webService: webService, stockData: stocksData, showAddButton: !stocksData.favoriteStocks.contains(searchStock.symbol ?? ""), searchStock: searchStock)
                                    }
                                    .listRowBackground(Color.black)
                                }
                                .background(Color.black)
                            }
                        }
                    } else {
                        HStack {
                            Spacer()
                            Text("Нет подключения к сети. Показаны последние кэшированные данные.")
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.white.opacity(0.5))
                                .font(.system(size: 10))
                            Spacer()
                        }
                        .padding(.top, 8)
                        
                        List {
                            ForEach(stocksData.favoriteStocks, id: \.self) { symbol in
                                let cacheStock = try? stocksData.stocksCacheStorage?.object(forKey: "\(symbol)")
                                if (cacheStock != nil) {
                                    StockCellView(stock: cacheStock!)
                                }
                            }
                            .listRowBackground(Color.black)
                        }
                        .background(Color.black)
                    }
                    
                    Spacer()
                }
                .frame(width: geometry.size.width)
                
            }
            
            //
            // Скрываем клавиатуру при нажатии вне её площади
            //
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
        }
    }
}
