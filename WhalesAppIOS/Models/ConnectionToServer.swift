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
    private let serverUrl = URL(string: "http://192.168.0.112:8080/data")
    
    public func sendDataToServer(){
        //checks to see if there is internte connection
        if !NetworkReachabilityManager()!.isReachable {
            print("Network not available")
            return
        }
        
        let db = DbConnection();
        
        let arrayData = db.getDataFromDb(isFromServer: false)
        print(arrayData.count)
        if !arrayData.isEmpty {
            
            var request = URLRequest(url: serverUrl!)
            request.httpMethod = HTTPMethod.post.rawValue
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            var array = [JSON]()
            for obj in arrayData {
                array.append(obj.toJson())
                
            }
            let data = (JSON(array).rawString()! .data(using: .utf8))! as Data
            
            print(JSON(array).rawString()!)
            request.httpBody = data
            
            Alamofire.request(request).responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    print(value)
                    
                    for obj in arrayData {
                        if !db.updateData(id: obj.id, isFromServer: true){
                            print("can't update data in db")
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
        else {
            print("There is no data to send to the server")
        }
    }
    
    public func getDataFromServer(completion : @escaping ()->()) {
        //checks to see if there is internte connection
        if !NetworkReachabilityManager()!.isReachable {
            print("Network not available")
            return
        }
        
        
        Alamofire.request(serverUrl!)
            .validate()
            .responseJSON{ response in
                switch response.result {
                case .success(let value):
                    let db = DbConnection();
                    let json = JSON(value)
                    for (_,jsonObj):(String, JSON) in json {
                        
                        let dataObj = DataModel(isFromServer: true, deviceId: jsonObj["deviceId"].string!, date: jsonObj["date"].string!, latitude: jsonObj["latitude"].double!, longitude: jsonObj["longitude"].double!, temperature: jsonObj["temperature"].double!, depth: jsonObj["depth"].double!, altitude: jsonObj["altitude"].double!, pressure: jsonObj["pressure"].double!, turbidity: jsonObj["turbidity"].double!, ph: jsonObj["ph"].double!, oxygen: jsonObj["oxygen"].double!)
                        
                        db.saveModelToDb(obj: dataObj)
                    }
                    
                    completion()
                case .failure(let error):
                    completion()
                    print(error)
                }
        }
    }
}


