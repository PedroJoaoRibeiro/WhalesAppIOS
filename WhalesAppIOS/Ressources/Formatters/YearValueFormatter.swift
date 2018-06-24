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
        // to prevent error
        var x = Int(value)
        if(x > 11){
            x = 11
        }
        return Calendar.current.shortMonthSymbols[x]
    }
}
