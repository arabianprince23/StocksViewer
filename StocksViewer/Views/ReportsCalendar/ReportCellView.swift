//
//  ReportCellView.swift
//  StocksViewer
//
//  Created by Анас Бен Мустафа on 3/31/21.
//

import SwiftUI

struct ReportCellView: View {
    
    @State var presentAlert: Bool = false
    var report: Report

    var body: some View {
        HStack {
            VStack (alignment: .leading) {
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
                Text("Добавить событие")
                    .foregroundColor(.blue)
                    .onTapGesture {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        let date = dateFormatter.date(from: report.date ?? "")
                        addEventToCalendar(title: "Отчётность \(report.symbol ?? "")", description: "Напоминание об отчётности \(report.symbol ?? "")", startDate: date ?? Date(), endDate: date ?? Date())
                        self.presentAlert.toggle()
                    }
                    .alert(isPresented: $presentAlert, content: {
                        Alert(title: Text("Событие добавлено"),
                              message: Text("Напоминание об отчётности \(report.symbol ?? "-") успешно добавлено в календарь!"),
                              dismissButton: .default(Text("Хорошо")))
                    })
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
