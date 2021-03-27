//
//  CheckTheConnection.swift
//  StocksViewer
//
//  Created by Анас Бен Мустафа on 3/26/21.
//

import Foundation
import SystemConfiguration

public class Reachability {

    /**
     Проверка подключения к интернету (через WiFi или Cellular)
     */
    class func isConnectedToNetwork() -> Bool {
           var zeroAddress = sockaddr_in()
           zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
           zeroAddress.sin_family = sa_family_t(AF_INET)

           guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
               $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                   SCNetworkReachabilityCreateWithAddress(nil, $0)
               }
           }) else {
               return false
           }

           var flags: SCNetworkReachabilityFlags = []
           if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
               return false
           }
           if flags.isEmpty {
               return false
           }

           let isReachable = flags.contains(.reachable)
           let needsConnection = flags.contains(.connectionRequired)

           return (isReachable && !needsConnection)
       }
}
