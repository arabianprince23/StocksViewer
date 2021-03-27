//
//  StockSearchCell.swift
//  StocksViewer
//
//  Created by Анас Бен Мустафа on 3/18/21.
//

import SwiftUI

struct SearchStockCell: View {
    
    var searchStock: SearchStock
    
    var body: some View {
        HStack {
            HStack {
                VStack (alignment: .leading) {
                    Text(searchStock.symbol ?? "-")
                        .foregroundColor(.white)
                    
                    Text(searchStock.description ?? "-")
                        .foregroundColor(Color.white.opacity(0.5))
                }
                .padding()
                
                Spacer()
                
                Image(systemName: "plus")
                    .foregroundColor(.blue)
                    .padding()
                    .onTapGesture {
                        // TODO
                    }
            }
        }
        .frame(height: 60)
        .background(Color.black)
    }
}

struct StockSearchCell_Previews: PreviewProvider {
    static var previews: some View {
        SearchStockCell(searchStock: SearchStock(symbol: "AAPL", description: "Apple Inc."))
    }
}
