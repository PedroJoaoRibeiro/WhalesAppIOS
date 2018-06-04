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
}


