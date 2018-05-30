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
            realm.add(obj)
        }
    }
    
    public func getDataFromDb() -> [DataModel] {
        return realm.objects(DataModel.self).map({$0 as DataModel})
    }
    
    public func getDataFromDb(isFromServer: Bool) -> [DataModel] {
        return realm.objects(DataModel.self).filter("isFromServer = \(isFromServer)") .map({$0 as DataModel})
    }
    
    public func checkIfObjectExists(id: String) -> Bool {
        if realm.object(ofType: DataModel.self, forPrimaryKey: id) != nil {
            return true
        }
        return false
    }
}


