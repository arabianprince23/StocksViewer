//
//  ReportsView.swift
//  StocksViewer
//
//  Created by Анас Бен Мустафа on 3/31/21.
//

import SwiftUI

struct ReportsView: View {
    
    @EnvironmentObject var stocksData: StocksData
    @ObservedObject var webService: WebService
    @State var reports: [Report] = []
    
    init() {
        webService = WebService()
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                Color(.black)
                    .edgesIgnoringSafeArea(.all)
                
                VStack (alignment: .leading) {
                    //
                    // Верхняя часть, титулы
                    //
                    VStack {
                        viewHeader(text: "Отчетности")
                        HStack {
                            Text(dateForReports())
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                            Spacer()
                        }
                    }
                    .padding([.leading, .trailing, .top])
                
                    ReportsListView(reports: [])
                    
                    Spacer()
                }
            }
        }
    }
}

struct ReportsView_Previews: PreviewProvider {
    static var previews: some View {
        ReportsView()
    }
}
