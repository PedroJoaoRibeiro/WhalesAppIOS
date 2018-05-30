//
//  ConnectionToServer.swift
//  WhalesAppIOS
//
//  Created by Pedro Ribeiro on 04/05/2018.
//  Copyright © 2018 Pedro Ribeiro. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
/*

class ConnectionToServer {
    private let serverUrl = URL(string: "http://127.0.0.1:8080/data")
    
    public func sendDataToServer(){
        let db = DbConnection();
        
        let arrayData = db.getDataFromDBWithRestrictions(isFromServer: false)
        print(arrayData.count)
        if !arrayData.isEmpty {
            
            var request = URLRequest(url: serverUrl!)
            request.httpMethod = HTTPMethod.post.rawValue
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let data = (JSON(arrayData).rawString()! .data(using: .utf8))! as Data
            
            request.httpBody = data
            
            Alamofire.request(request).responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    print(value)
                    
                    for json in arrayData {
                        let id = json["deviceId"].string! + json["date"].string!
                        if !db.updateData(id: id, isFromServer: true){
                            print("can't update data in db")
                        }
                    }
                    
                    print(db.getDataFromDBWithRestrictions(isFromServer: false).count)
                case .failure(let error):
                    print(error)
                }
            }
        }
        else {
                print("There is no data to send to the server")
            }
        }
        
        public func getDataFromServer() {
            Alamofire.request(serverUrl!)
                .validate()
                .responseJSON{ response in
                    switch response.result {
                    case .success(let value):
                        let db = DbConnection();
                        let json = JSON(value)
                        for (_,subJson):(String, JSON) in json {
                            let id = subJson["deviceId"].string! + subJson["date"].string!
                            if !db.insertDataIntoDb(id: id, jsonString: subJson.rawString()!, isFromServer: true) {
                                print("can't save data to db")
                            }
                        }
                    case .failure(let error):
                        print(error)
                    }
            }
        }
}
 
 */
