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
        let url = URL(string: "http://192.168.0.1/data?0")
        
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
                        self.convertCSVDataAndSaveToDb(deviceId: json["deviceId"].string!)
                        print("all the data from photon is saved")
                    } else {
                        self.getData(i: i + 1)
                    }
                case .failure(let error):
                    print(error)
                }
        }
        
    }
    
    private func convertCSVDataAndSaveToDb(deviceId: String){
        let db = DbConnection();
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
                    let str = auxFuncFixNeed(str: String(currentLine[index]))
                    jsonObj[header] = JSON(str)
                    break
                default:
                    jsonObj[header] = JSON(Double(String(currentLine[index]))!)
                }
            }
            
            // saves the obj to db
            let id = jsonObj["deviceId"].string! + jsonObj["date"].string!
            if !db.insertDataIntoDb(id: id, jsonString: jsonObj.rawString()!, isFromServer: false) {
                print("can't save data to db")
            }
        }
        
    }
    
    //change the date format that the photon sends
    private func auxFuncFixNeed(str: String) -> String {
        let year = str.prefix(4)
        
        let start = str.index(str.startIndex, offsetBy: 4)
        let end = str.index(str.endIndex, offsetBy: -4)
        let range = start..<end
        let month = str[range]
        
        let start1 = str.index(str.startIndex, offsetBy: 6)
        let end1 = str.index(str.endIndex, offsetBy: -2)
        let range1 = start1..<end1
        let day = str[range1]
        
        let hour = str.suffix(2)
        let string = "\(year)-\(month)-\(day)T\(hour):00:00.000Z"
        return string
    }
}
