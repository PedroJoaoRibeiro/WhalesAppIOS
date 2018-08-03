//
//  DbConnection.swift
//  WhalesAppIOS
//
//  Created by Pedro Ribeiro on 04/05/2018.
//  Copyright © 2018 Pedro Ribeiro. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class DbConnection {
    let realm = try! Realm()
    
    public func saveModelToDb(obj: DataModel){
        try! realm.write {
            realm.add(obj, update: true)
        }
    }
    
    public func getDataFromDb() -> [DataModel] {
        return realm.objects(DataModel.self).map({$0 as DataModel}).sorted(){$0.date < $1.date }
    }
    
    public func getDataFromDb(isFromServer: Bool) -> [DataModel] {
        return realm.objects(DataModel.self).filter("isFromServer = \(isFromServer)") .map({$0 as DataModel}).sorted(){$0.date < $1.date }
    }
    
    public func checkIfObjectExists(id: String) -> Bool {
        if realm.object(ofType: DataModel.self, forPrimaryKey: id) != nil {
            return true
        }
        return false
    }
    
    public func updateData(id: String, isFromServer: Bool) -> Bool{
        try! realm.write {
            realm.create(DataModel.self, value: ["id": id, "isFromServer": isFromServer], update: true)
        }
        return true
    }
    
    public func updateDepth(id: String, depth: Double) -> Bool{
        try! realm.write {
            realm.create(DataModel.self, value: ["id": id, "depth": depth], update: true)
        }
        return true
    }
    
    
    //-------------------- To Manage Data easly --------------//
    
    ///gets the data for one day
    public func getDateForDay(currentDate: Date) -> [DataModel] {
        //connects to the database to get the data
        let db = DbConnection()
        var array = db.getDataFromDb()
        
        array = array.filter { Calendar.current.isDate($0.date, equalTo: currentDate, toGranularity: .day)}
        
        // if there is no data just return nil
        if array.isEmpty {
            return [DataModel]()
        }
        
        return array
    }
    
    ///gets the data for one week all days grouped in average
    public func getDateForWeek(currentDate: Date) -> [DataModel] {
        //connects to the database to get the data
        let db = DbConnection()
        var array = db.getDataFromDb()
        
        array = array.filter { Calendar.current.isDate($0.date, equalTo: currentDate, toGranularity: .weekOfYear )}
        
        
        // if there is no data just return nil
        if array.isEmpty {
            return [DataModel]()
        }
        
        let dict = Dictionary(grouping: array) {$0.date.day}
        
        var finalArray = [DataModel]()
        
        let component = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: currentDate.startOfWeek!)
        var d = Calendar.current.date(from: component)!
        
        for _ in 0..<7 {
            let obj = DataModel()
            obj.date = d
            finalArray.append(obj)
            d = Calendar.current.date(byAdding: .day, value: 1, to: d)!
        }
        
        for (_, value) in dict {
            for obj in finalArray {
                for v in value {
                    if(obj.date.day == v.date.day){
                        obj.add(obj: v)
                    }
                }
                if(value.count > 0 && value[0].date.day == obj.date.day ){
                    obj.divide(value: value.count)
                }
            }
        }
        return finalArray
    }
    
    ///gets the data for one month all days grouped in average
    public func getDateForMonth(currentDate: Date) -> [DataModel] {
        //connects to the database to get the data
        let db = DbConnection()
        var array = db.getDataFromDb()
        
        array = array.filter { Calendar.current.isDate($0.date, equalTo: currentDate, toGranularity: .month)}
        
        // if there is no data just return nil
        if array.isEmpty {
            return [DataModel]()
        }
        
        let dict = Dictionary(grouping: array) {$0.date.day}
        
        var finalArray = [DataModel]()
        
        let range = Calendar.current.range(of: .day, in: .month, for: currentDate)!
        
        var component = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: currentDate)
        component.day = 1
        var d = Calendar.current.date(from: component)!
        
        for _ in 0..<range.count {
            let obj = DataModel()
            obj.date = d
            finalArray.append(obj)
            d = Calendar.current.date(byAdding: .day, value: 1, to: d)!
        }
        
        for (key, value) in dict {
            for v in value {
                finalArray[key-1].add(obj: v)
            }
            finalArray[key-1].divide(value: value.count)
        }
        return finalArray
    }
    
    ///gets the data for one year all grouped in average
    public func getDateForYear(currentDate: Date) -> [DataModel] {
        var array = self.getDataFromDb()
        
        array = array.filter { Calendar.current.isDate($0.date, equalTo: currentDate, toGranularity: .year)}
        
        // if there is no data just return nil
        if array.isEmpty {
            return [DataModel]()
        }
        
        let dict = Dictionary(grouping: array) {$0.date.month}
        
        //initialize the array with fixed size
        var finalArray = [DataModel]()
        var component = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: currentDate)
        component.month = 1
        component.day = 1
        var d = Calendar.current.date(from: component)!
        for _ in 0..<12 {
            let obj = DataModel()
            obj.date = d
            finalArray.append(obj)
            d = Calendar.current.date(byAdding: .month, value: 1, to: d)!
        }
        
        for (key, value) in dict {
            for v in value {
                finalArray[key-1].add(obj: v)
            }
            finalArray[key-1].divide(value: value.count)
        }
        
        return finalArray
    }
}


