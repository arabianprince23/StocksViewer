//
//  SearchView.swift
//  StocksViewer
//
//  Created by Анас Бен Мустафа on 3/20/21.
//

import SwiftUI

/**
 Поисковая строка
 */
struct SearchView: View {
    
    @Binding var searchTerm: String
    
    var body: some View {
        HStack (alignment: .center) {
            Image(systemName: "magnifyingglass")
                .padding(.leading, 8)
            
            TextField("Поиск", text: $searchTerm)
                .frame(height: 30)
            
            if (self.searchTerm != "") {
                Image(systemName: "xmark.circle.fill")
                    .padding(.trailing)
                    .onTapGesture {
                        self.searchTerm = ""
                    }
            }
        }
        .foregroundColor(Color.gray)
        .background(Color(.white).opacity(0.1))
        .cornerRadius(8)
        .padding([.leading, .trailing])
    }
}
