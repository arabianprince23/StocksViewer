//
//  ReportCellView.swift
//  StocksViewer
//
//  Created by Анас Бен Мустафа on 3/31/21.
//

import SwiftUI

struct ReportCellView: View {
    
    var report: Report

    var body: some View {
        HStack {
            VStack {
                Text(report.symbol ?? "-")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                Text(report.date ?? "-")
                    .font(.title3)
                    .foregroundColor(Color.gray)
            }
            Spacer()
            VStack (alignment: .center) {
                Image(systemName: "plus")
                    .foregroundColor(.blue)
                    .onTapGesture {
                        // TODO
                    }
            }
            
        }
        .frame(height: 60)
        .padding([.leading, .trailing])
    }
}

struct ReportCellView_Previews: PreviewProvider {
    static var previews: some View {
        ReportCellView(report: Report(symbol: "AAPL", date: "21-04-2021"))
    }
}
