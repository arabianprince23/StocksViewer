//  Взято для приложения StocksViewer с pichukov/LightChart
//
//  ChartType.swift
//

import SwiftUI 

public enum ChartType {
    case line
    case curved
}

public enum ChartVisualType {
    case outline(color: Color, lineWidth: CGFloat)
    case filled(color: Color, lineWidth: CGFloat)
    case customFilled(color: Color, lineWidth: CGFloat, fillGradient: LinearGradient)
}

public enum CurrentValueLineType {
    case none
    case line(color: Color, lineWidth: CGFloat)
    case dash(color: Color, lineWidth: CGFloat, dash: [CGFloat])
}
