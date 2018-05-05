//
//  DbConnection.swift
//  WhalesAppIOS
//
//  Created by Pedro Ribeiro on 04/05/2018.
//  Copyright © 2018 Pedro Ribeiro. All rights reserved.
//

import Foundation
import SQLite3
import SwiftyJSON


class DbConnection {
    
    private let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        .appendingPathComponent("WhalesDatabase.sqlite")
    
    private var db: OpaquePointer?
    
    // queries statements
    private let createtableQuerry = "CREATE TABLE IF NOT EXISTS Whales (id TEXT PRIMARY KEY, jsonString TEXT, isFromServer INTEGER)"
    private let insertQueryString = "INSERT OR IGNORE INTO Whales (id, jsonString, isFromServer) VALUES (?,?,?)"
    private let getDataQueryString = "SELECT * FROM Whales"
    private let getDataQueryStringWithOptions = "SELECT * FROM Whales WHERE isFromServer = ?"
    
    init() {
        do {
            try openDatabase()
        } catch MyErrors.openDB(let msg) {
            print(msg)
        } catch MyErrors.creatingTable(let msg) {
            print(msg)
        }catch {
            print("Unexpected error: \(error).")
        }
        
    }
    
    public func openDatabase() throws {
    
        // connects to the db and creates if not already created
        guard sqlite3_open(fileURL.path, &db) == SQLITE_OK else {
            throw MyErrors.openDB(msg: "error opening database")
        }
        
        // creates db table
        guard sqlite3_exec(db, createtableQuerry, nil, nil, nil) == SQLITE_OK else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            throw MyErrors.creatingTable(msg: "error creating table: \(errmsg)")
        }
    }
    
    public func insertDataIntoDb(id: String, jsonString: String, isFromServer: Bool) -> Bool {
        //creating a statement
        var stmt: OpaquePointer?
        let result = isFromServer ? 1 : 0
        
        //prepare the querry
        if sqlite3_prepare(db, insertQueryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return false
        }
        
        //binding the parameters
        if sqlite3_bind_text(stmt, 1, id, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding id: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_text(stmt, 2, jsonString, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding jsonString: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_int(stmt, 3, Int32(result)) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding isFromServer: \(errmsg)")
            return false
        }
        
        //executing the query to insert values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting: \(errmsg)")
            return false
        }
        
        return true
    }
    
    public func getDataFromDB() -> [JSON] {
        var stmt:OpaquePointer?
        
        var array = [JSON]();
        
        //preparing the query
        if sqlite3_prepare(db, getDataQueryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
        }
        
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            //let id = String(cString: sqlite3_column_text(stmt, 0))
            let jsonString = String(cString: sqlite3_column_text(stmt, 1))
            
            //adding values to list
            array.append(JSON(jsonString))
        }
        return array
    }
    
    public func getDataFromDBWithRestrictions(isFromServer: Bool) -> [JSON] {
        var stmt:OpaquePointer?
        let result = isFromServer ? 1 : 0
        var array = [JSON]();
        
        //preparing the query
        if sqlite3_prepare(db, getDataQueryStringWithOptions, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
        }
        
        //binding the parameters
        if sqlite3_bind_int(stmt, 1, Int32(result)) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding isFromServer: \(errmsg)")
        }
        
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            //let id = String(cString: sqlite3_column_text(stmt, 0))
            let jsonString = String(cString: sqlite3_column_text(stmt, 1))
            
            //adding values to list
            array.append(JSON(jsonString))
        }
        return array
    }
}
