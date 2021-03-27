//
//  NewsListView.swift
//  Stocks
//
//  Created by Анас Бен Мустафа on 3/16/21.
//

import SwiftUI

/**
 Лента новостей
 */
struct NewsListView: View {
    
    var news: [News] = []
    
    init(news: [News]) {
        self.news = news
    }
    
    var body: some View {
        ScrollView {
            ForEach(self.news, id: \.headline) { news in
                NewsCellView(news: news)
                    .onTapGesture {
                        UIApplication.shared.open(URL(string: news.url ?? "https://www.cnbc.com/world/?region=world")!, options: [:], completionHandler: nil)
                    }
                
                Divider()
                    .background(Color.white.opacity(0.2))
                    .padding(.leading)
            }
        }
    }
}
