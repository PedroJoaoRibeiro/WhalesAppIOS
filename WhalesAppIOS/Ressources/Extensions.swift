//
//  Extensions.swift
//  WhalesAppIOS
//
//  Created by Pedro Ribeiro on 04/05/2018.
//  Copyright © 2018 Pedro Ribeiro. All rights reserved.
//

import Foundation
import SwiftyJSON

extension DateFormatter {
    
    func jsonDateToDate(str: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let yourDate = formatter.date(from: str)
        return yourDate
    }
    
    func csvDateToDate(str: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHH"
        let yourDate = formatter.date(from: str)
        return yourDate
    }
}

