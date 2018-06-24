//
//  MonthValueFormatter.swift
//  WhalesAppIOS
//
//  Created by Pedro Ribeiro on 19/06/2018.
//  Copyright © 2018 Pedro Ribeiro. All rights reserved.
//

import Foundation
import Charts

public class WeekValueFormatter: NSObject, IAxisValueFormatter {
    
    private var initialWeekDate: Date = Date()
    
    init(initialWeekDate: Date) {
        super.init()
        self.initialWeekDate = initialWeekDate
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let d = Calendar.current.date(byAdding: .day, value: Int(value), to: initialWeekDate)!
        return "\(d.day)/\(d.month)"
    }
}
