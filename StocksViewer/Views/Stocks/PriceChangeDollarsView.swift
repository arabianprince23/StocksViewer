//
//  ChangeView.swift
//  StocksViewer
//
//  Created by Анас Бен Мустафа on 3/31/21.
//

import SwiftUI

struct PriceChangeDollarsView: View {
    var change: Float?
    
    var body: some View {
        if (change ?? 0.0 >= 0) {
            Text("    +\(NSString(format: "%.2f", change ?? ""))")
                .foregroundColor(Color.white)
                .font(.subheadline)
                .bold()
                .padding(2)
                .padding(.trailing, 4)
                .background(Color.green)
                .cornerRadius(4)
        } else {
            Text("    \(NSString(format: "%.2f", change ?? ""))")
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
