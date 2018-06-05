//
//  Extensions.swift
//  WhalesAppIOS
//
//  Created by Pedro Ribeiro on 04/05/2018.
//  Copyright © 2018 Pedro Ribeiro. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

extension DateFormatter {
    
    func jsonDateToDate(str: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let yourDate = formatter.date(from: str)
        return yourDate
    }
    
    func stringToDate(str: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let yourDate = formatter.date(from: str)
        return yourDate
    }
}

extension Date {
    
    func toString(withFormat format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let myString = formatter.string(from: self)
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = format
        
        return formatter.string(from: yourDate!)
    }
}

extension UIColor {
    static var mainPink = UIColor(red: 232/255, green: 68/255, blue: 133/255, alpha: 1)
}

