//
//  NewsCellView.swift
//  Stocks
//
//  Created by Анас Бен Мустафа on 3/16/21.
//

import SwiftUI

/**
 Ячейка новостной ленты
 */
struct NewsCellView: View {
    
    var news: News
    
    var body: some View {
        HStack {
            VStack {
                HStack {
                    Image(systemName: "newspaper")
                        .foregroundColor(Color.white.opacity(0.5))
                        .font(.caption)
                    Text("News category: \(news.category ?? "")")
                        .foregroundColor(Color.white.opacity(0.5))
                        .font(.caption)
                        .bold()
                    Spacer()
                }
                .padding(.leading, 16).padding(.top, 8)
                
                HStack {
                    Text(news.headline ?? "")
                        .foregroundColor(.white)
                        .font(.headline)
                        .lineLimit(2)
                    
                    Spacer()
                }
                .padding(.leading)
                .padding(.top, 8)
                
                
                HStack {
                    Text("Source: \(news.source ?? "")")
                        .foregroundColor(Color.white.opacity(0.5))
                        .font(.footnote)
                    
                    Spacer()
                }
                .padding(.leading)
                .padding(.top, 8)
                .padding(.bottom, 8)
            }
            
            Image(systemName: "chevron.forward")
                .foregroundColor(Color.white.opacity(0.5))
                .padding()
        }
        .frame(height: 125)
    }
}
