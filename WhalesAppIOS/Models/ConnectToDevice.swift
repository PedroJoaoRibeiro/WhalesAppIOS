//
//  ConnectToDevice.swift
//  WhalesAppIOS
//
//  Created by Pedro Ribeiro on 08/05/2018.
//  Copyright © 2018 Pedro Ribeiro. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ConnectionToDevice {
    let baseUrlString = "http://192.168.0.1/data?";
    var upcomingDataDictionary = [String: String]()    // deviceId; csvData
    
    func getData(i: Int){
        
        // url with id of the get part
        let url = URL(string: baseUrlString + String(i))
        
        Alamofire.request(url!)
            .validate()
            .responseJSON{ response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    
                    // save the data to the dictionairy
                    // in this case there is data already with that deviceID
                    if let val = self.upcomingDataDictionary[json["deviceId"].string!] {
                        self.upcomingDataDictionary[json["deviceId"].string!] = val + json["csvData"].string!
                    }
                        // in this case there is no data with the device id asked
                    else {
                        self.upcomingDataDictionary[json["deviceId"].string!] = json["csvData"].string!
                    }
                    
                    // check if this is the last piece of data
                    if(json["isFinalData"].boolValue) {
                        print("here")
                        self.convertCSVDataAndSaveToDb(deviceId: json["deviceId"].string!)
                        print("all the data from photon is saved")
                    } else {
                        print(json["dataPart"].int!)
                        self.getData(i: json["dataPart"].int!)
                    }
                case .failure(let error):
                    print(error)
                }
        }
        
    }
    
    private func convertCSVDataAndSaveToDb(deviceId: String){
        let db = DbConnection()
        let csv = upcomingDataDictionary[deviceId]!
        var linesArray = csv.split(separator: ";")
        
        //getting the headers
        let headers = linesArray[0].split(separator: ",")
        
        //remove first element from the array -> headers
        linesArray.remove(at: 0)
        
        for line in linesArray {
            let currentLine = line.split(separator: ",")
            var jsonObj = JSON()
            jsonObj["deviceId"] = JSON(deviceId)
            
            for index in 0..<headers.count {
                let header = String(headers[index])
                
                switch  header{
                case "date":
                    jsonObj[header] = JSON(String(currentLine[index]))
                    break
                case "audioFile":
                    jsonObj[header] = JSON(String(currentLine[index]))
                    break
                default:
                    jsonObj[header] = JSON(Double(String(currentLine[index]))!)
                }
            }
            
            if(!db.checkIfObjectExists(id:deviceId + jsonObj["date"].string!)){
                
                let dataObj = DataModel(isFromServer: false, deviceId: deviceId, date: jsonObj["date"].string!, audioFile: jsonObj["audioFile"].string!, latitude: jsonObj["latitude"].double!, longitude: jsonObj["longitude"].double!, temperature: jsonObj["temperature"].double!, depth: jsonObj["depth"].double!, pollution: jsonObj["pollution"].double!, pressure: jsonObj["pressure"].double!)
                
                db.saveModelToDb(obj: dataObj)
            }
            
        }
    }
}
