//
//  HorizontalStockInfoView.swift
//  StocksViewer
//
//  Created by Анас Бен Мустафа on 3/31/21.
//

import SwiftUI

struct CompanyIndicatorsView: View {
    
    var stock: Stock
    
    var body: some View {
        VStack {
            HStack {
                Text("Рыночн. кап.")
                    .foregroundColor(Color.white)
                Spacer()
                Text(separatedNumber(marketCap: stock.marketCap ?? 0))
                    .foregroundColor(Color.white)
            }
            
            Divider()
                .background(Color.white.opacity(0.15))
            HStack {
                Text("P/E компании")
                    .foregroundColor(Color.white)
                Spacer()
                Text("\(NSString(format: "%.2f", stock.peRatio ?? ""))")
                    .foregroundColor(Color.white)
            }
            
            Divider()
                .background(Color.white.opacity(0.15))
            HStack {
                Text("Год. максимум")
                    .foregroundColor(Color.white)
                Spacer()
                Text("\(NSString(format: "%.2f", stock.week52High ?? ""))")
                    .foregroundColor(Color.white)
            }
            
            Divider()
                .background(Color.white.opacity(0.15))
            HStack {
                Text("Год. минимум")
                    .foregroundColor(Color.white)
                Spacer()
                Text("\(NSString(format: "%.2f", stock.week52Low ?? ""))")
                    .foregroundColor(Color.white)
            }
            Divider()
                .background(Color.white.opacity(0.15))
            
            HStack {
                Text("Год. изменение")
                    .foregroundColor(Color.white)
                Spacer()
                Text("\(NSString(format: "%.2f", (stock.week52High ?? 0.0) - (stock.week52Low ?? 0.0)))")
                    .foregroundColor(Color.white)
            }
            Divider()
                .background(Color.white.opacity(0.15))
        }
        .padding()
    }
}
