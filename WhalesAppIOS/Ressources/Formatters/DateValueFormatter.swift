//
//  DateValueFormatter.swift
//  WhalesAppIOS
//
//  Created by Pedro Ribeiro on 05/05/2018.
//  Copyright © 2018 Pedro Ribeiro. All rights reserved.
//

import Foundation
import Charts

public class DateValueFormatter: NSObject, IAxisValueFormatter {
    private let dateFormatter = DateFormatter()
    
    init(format: String) {
        super.init()
        dateFormatter.dateFormat = format
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}
