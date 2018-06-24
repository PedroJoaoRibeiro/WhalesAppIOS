//
//  MonthValueFormatter.swift
//  WhalesAppIOS
//
//  Created by Pedro Ribeiro on 19/06/2018.
//  Copyright © 2018 Pedro Ribeiro. All rights reserved.
//

import Foundation
import Charts

public class DayValueFormatter: NSObject, IAxisValueFormatter {
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return String(format: "%.0f", value)
    }
}
