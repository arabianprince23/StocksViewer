//
//  WebService.swift
//  Stocks
//
//  Created by Анас Бен Мустафа on 3/18/21.
//

import SwiftUI
import SwiftyJSON
import Alamofire

class WebService: ObservableObject {
    
    let tokenFinHub: String = "c18dev748v6oak5h3l2g"
    let tokenIEX: String = "sk_fe10468fa08246d7b2a7470b21975b78"
    
    /**
     Функция, делающая запрос не сервер и возвращающая массив данных типа News
     */
    func getNewsArray(completion: @escaping ([News]) -> Void) {
        
        var news: [News] = []
        let newsDataURL = "https://finnhub.io/api/v1/news?category=general&token=\(tokenFinHub)"
        
        AF.request(newsDataURL, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                for (_, subJson) : (String, JSON) in json {
                    let category: String? = subJson["category"].string
                    let headline: String? = subJson["headline"].string
                    let url: String? = subJson["url"].string
                    let source: String? = subJson["source"].string
                    
                    news.append(News(category: category, headline: headline, url: url, source: source))
                }
                
                completion(news)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    /**
     Функция, делающая запрос на сервер и возвращающая массив данных типа SearchSock
     */
    func getSearchingStocks(searchTerm: String, completion: @escaping ([SearchStock]) -> Void) {
        
        var searchedStocks: [SearchStock] = []
        let stocksDataURL = "https://finnhub.io/api/v1/search?q=\(searchTerm)&token=\(tokenFinHub)"
        
        AF.request(stocksDataURL, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                
                for (_, subJson) : (String, JSON) in json["result"] {
                    let symbol: String? = subJson["symbol"].string
                    let description: String? = subJson["description"].string
                    
                    //
                    // В силу использования разных ресурсов, приходится исключать из поиска акции с некоторыми символами,
                    // поскольку один из ресурсов не пропускает подобные запросы
                    //
                    if (!((symbol?.contains("."))!) && !((symbol?.contains("^"))!) && !((symbol?.contains(":"))!) && !((symbol?.contains("-"))!)) {
                        searchedStocks.append(SearchStock(symbol: symbol, description: description))
                    }
                }
                
                completion(searchedStocks)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    /**
     Получение детальной информации об акции по тикеру
     */
    func getStockBySymbol(symbol: String, completion: @escaping (Stock) -> Void) {
        
        let stockURL = "https://cloud.iexapis.com/v1/stock/\(symbol)/quote?token=\(tokenIEX)"
        
        AF.request(stockURL, method: .get, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                let description: String? = json["companyName"].string
                let price: Float? = json["latestPrice"].float
                let change: Float? = json["change"].float
                let weeks52Low: Float? = json["week52Low"].float
                let weeks52High: Float? = json["week52High"].float
                let peRatio: Float? = json["peRatio"].float
                let marketCap: Int? = json["marketCap"].int
                
                completion(Stock(symbol: symbol, description: description, price: price, change: change, week52Low: weeks52Low, week52High: weeks52High, peRatio: peRatio, marketCap: marketCap))
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    /**
     Получение точек для графика по акции за опредленный период
     */
    func getChartDataForStock(for period: String, symbol: String, completion: @escaping ([Double]) -> Void) {
        
        var resolution = ""
        var resultData: [Double] = []
        var firstDay = TimeInterval()
        var lastDay = TimeInterval()
        
        switch period {
        case "Day":
            firstDay = ((Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()) as Date).timeIntervalSince1970
            lastDay = Date().timeIntervalSince1970
            resolution = "15"
            
        case "Week":
            firstDay = ((Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()) as Date).timeIntervalSince1970
            lastDay = Date().timeIntervalSince1970
            resolution = "60"
            
        case "Month":
            firstDay = ((Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()) as Date).timeIntervalSince1970
            lastDay = Date().timeIntervalSince1970
            resolution = "D"
            
        case "Year":
            firstDay = ((Calendar.current.date(byAdding: .year, value: -1, to: Date()) ?? Date()) as Date).timeIntervalSince1970
            lastDay = Date().timeIntervalSince1970
            resolution = "W"
        default:
            print("Invailid period argument!")
        }
        
        let dataUrl = URL(string: "https://finnhub.io/api/v1/stock/candle?symbol=\(symbol)&resolution=\(resolution)&from=\(Int(firstDay))&to=\(Int(lastDay))&token=\(tokenFinHub)")!
        
        AF.request(dataUrl, method: .get, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(_):
                
                if let responseJSON = response.value as? [String : Any] {
                    if let valueArray = responseJSON["c"] as? [Double] {
                        resultData = valueArray
                    }
                }
                
                completion(resultData)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    /**
     Возвращает новости компании по тикеру
     */
    func getCompanyNews(symbol: String, completion: @escaping ([News]) -> Void) {
        
        var news: [News] = []
        
        guard let weekAgoDate = (Calendar.current.date(
                                    byAdding: .day,
                                    value: -7,
                                    to: Date()) as Date?) else { return }
        
        let newsDataURL = "https://finnhub.io/api/v1/company-news?symbol=\(symbol)&from=\(weekAgoDate.getFormattedDate(format: "YYYY-MM-dd"))&to=\(Date().getFormattedDate(format: "YYYY-MM-dd"))&token=\(tokenFinHub)"
        
        AF.request(newsDataURL, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                var iterator = 0
                
                for (_, subJson) : (String, JSON) in json {
                    let category: String? = subJson["category"].string
                    let headline: String? = subJson["headline"].string
                    let url: String? = subJson["url"].string
                    let source: String? = subJson["source"].string
                    iterator += 1
                    
                    if (iterator == 10) {
                        break
                    } else {
                        news.append(News(category: category, headline: headline, url: url, source: source))
                    }
                }
                
                completion(news)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getReports(completion: @escaping ([Report]) -> Void) {
        // https://finnhub.io/api/v1/calendar/earnings?from=2021-03-01&to=2021-03-09&token=c18dev748v6oak5h3l2g
        
        var reports: [Report] = []
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateAfterWeek = (Calendar.current.date(byAdding: .day, value: +7, to: Date()) ?? Date()) as Date
        
        let reportsDataURL = "https://finnhub.io/api/v1/calendar/earnings?from=\(dateFormatter.string(from: Date()))&to=\(dateFormatter.string(from: dateAfterWeek))&token=\(tokenFinHub)"
        
        AF.request(reportsDataURL, method: .get, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                
                // TODO
                
                completion(reports)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
