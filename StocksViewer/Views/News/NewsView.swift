//
//  NewsView.swift
//  Stocks
//
//  Created by Анас Бен Мустафа on 3/16/21.
//

import SwiftUI

/**
 Экран с новостной лентой
 */
struct NewsView: View {
    
    @EnvironmentObject var stocksData: StocksData
    @ObservedObject var webService: WebService
    @State var news: [News] = []
    @State var dataIsReady: Bool = false
    
    init() {
        webService = WebService()
    }
    
    var body: some View {
        
        ZStack {
            
            Color.black
                .ignoresSafeArea()
            
            VStack {
                //
                // Верхняя часть, титулы
                //
                VStack {
                    viewHeader(text: "Новости")
                        .padding(.top)
                    
                    HStack {
                        viewDateTitle()
                        Spacer()
                        
                        if (stocksData.isInternetAvailible) {
                            Image(systemName: "arrow.clockwise")
                                .foregroundColor(.blue)
                                .onTapGesture {
                                    self.dataIsReady = false
                                    webService.getNewsArray { response in
                                        self.news = response
                                        self.dataIsReady.toggle()
                                    }
                                }
                        }
                    }
                }
                .padding([.leading, .trailing])
                
                //
                // При доступе к сети, новости с сервера, иначе отображаем кэшированные новости
                //
                if (stocksData.isInternetAvailible) {
                    if (dataIsReady) {
                        NewsListView(news: news)
                    } else {
                        VStack {
                            Spacer()
                            ProgressView()
                                .progressViewStyle(DefaultProgressViewStyle())
                            Text("Загружаем последние новости...")
                                .foregroundColor(Color.white.opacity(0.1))
                                .padding(.top, 16)
                            Spacer()
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
                    
                    let newsCache = try? stocksData.newsCacheStorage?.object(forKey: "newsCache")
                    NewsListView(news: newsCache ?? [])
                }
                Spacer()
            }
            .onAppear() {
                if (stocksData.isInternetAvailible) {
                    webService.getNewsArray { response in
                        self.news = response
                        dataIsReady.toggle()
                        try? stocksData.newsCacheStorage?.setObject(response, forKey: "newsCache")
                    }
                }
            }
        }
    }
}
