//
//  ReportsView.swift
//  StocksViewer
//
//  Created by Анас Бен Мустафа on 3/31/21.
//

import SwiftUI
import EventKit

struct ReportsView: View {
    
    @EnvironmentObject var stocksData: StocksData
    @ObservedObject var webService: WebService
    @State var dataIsReady: Bool = false
    @State var reports: [Report] = []
    
    init() {
        webService = WebService()
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                Color(.black)
                    .edgesIgnoringSafeArea(.all)
                
                VStack (alignment: .leading) {
                    
                    //
                    // Title
                    //
                    VStack {
                        viewHeader(text: "Отчёты недели")
                        HStack {
                            Text(dateForReports())
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                            Spacer()
                            if (stocksData.isInternetAvailible) {
                                Image(systemName: "arrow.clockwise")
                                    .foregroundColor(.blue)
                                    .onTapGesture {
                                        self.dataIsReady = false
                                        webService.getReports { response in
                                            self.reports = response
                                            self.dataIsReady.toggle()
                                        }
                                    }
                            }
                        }
                    }
                    .padding([.leading, .trailing, .top])
                    
                    if (stocksData.isInternetAvailible) {
                        if (dataIsReady) {
                            ReportsListView(reports: self.reports)
                        } else {
                            HStack {
                                Spacer()
                                VStack (alignment: .center) {
                                    Spacer()
                                    ProgressView()
                                        .progressViewStyle(DefaultProgressViewStyle())
                                    Text("Загружаем информацию...")
                                        .foregroundColor(Color.white.opacity(0.1))
                                        .padding(.top, 16)
                                    Spacer()
                                }
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
                        
                        let reportsCache = try? stocksData.reportsCacheStorage?.object(forKey: "reportsCache")
                        ReportsListView(reports: reportsCache ?? [])
                    }
                    
                    Spacer()
                }
            }
            .onAppear() {
                if (stocksData.isInternetAvailible) {
                    webService.getReports { (res) in
                        self.reports = res
                        dataIsReady.toggle()
                        try? stocksData.reportsCacheStorage?.setObject(res, forKey: "reportsCache")
                    }
                }
            }
        }
    }
}
