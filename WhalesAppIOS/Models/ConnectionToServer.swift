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


class ConnectionToServer {
    private let serverUrl = URL(string: "http://192.168.1.78:8080/data")
    
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
