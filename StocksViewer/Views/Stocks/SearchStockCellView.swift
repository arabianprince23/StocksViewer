//
//  StockSearchCell.swift
//  StocksViewer
//
//  Created by Анас Бен Мустафа on 3/18/21.
//

import SwiftUI

/**
 
 */
struct SearchStockCellView: View {
    
    @ObservedObject var webService: WebService
    @ObservedObject var stockData: StocksData
    var showAddButton: Bool
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
                
                Spacer()
                
                //
                // Показываем кнопку добавления только если акции пока нет в списке избранного
                //
                if (showAddButton) {
                    Image(systemName: "plus")
                        .foregroundColor(.blue)
                        .onTapGesture {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred(intensity: 1)
                            stockData.saveStockSymbol(with: searchStock.symbol ?? "")
                        }
                }
            }
        }
        .frame(height: 60)
        .background(Color.black)
    }
}
