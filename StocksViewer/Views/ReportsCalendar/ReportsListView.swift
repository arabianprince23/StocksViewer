//
//  ReportsListView.swift
//  StocksViewer
//
//  Created by Анас Бен Мустафа on 3/31/21.
//

import SwiftUI

struct ReportsListView: View {
    
    var reports: [Report] = []
    
    init(reports: [Report]) {
        self.reports = reports
    }
    
    var body: some View {
        ScrollView {
            ForEach(self.reports.reversed(), id: \.symbol) { report in
                ReportCellView(report: report)
                Divider()
                    .background(Color.white.opacity(0.2))
                    .padding(.leading)
            }
        }
    }
}
