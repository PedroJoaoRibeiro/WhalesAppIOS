//
//  MonthValueFormatter.swift
//  WhalesAppIOS
//
//  Created by Pedro Ribeiro on 19/06/2018.
//  Copyright © 2018 Pedro Ribeiro. All rights reserved.
//

import Foundation
import Charts

public class YearValueFormatter: NSObject, IAxisValueFormatter {
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let date = Date(timeIntervalSince1970: value)
        return Calendar.current.shortMonthSymbols[date.month-1]
    }
}
