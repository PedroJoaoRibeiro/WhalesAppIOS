//
//  DataModel.swift
//  WhalesAppIOS
//
//  Created by Pedro Ribeiro on 30/05/2018.
//  Copyright © 2018 Pedro Ribeiro. All rights reserved.
//


import RealmSwift
import SwiftyJSON

class DataModel: Object {
    
    convenience init(isFromServer: Bool, deviceId: String, date: String, audioFile: String, latitude: Double, longitude: Double, temperature: Double, depth: Double, pollution: Double, pressure: Double) {
        self.init()
        
        self.id = deviceId + date
        self.isFromServer = isFromServer
        
        self.date = DateFormatter().stringToDate(str: date)!
        self.deviceId = deviceId
        
        self.audioFile = audioFile
        self.latitude = latitude
        self.longitude = longitude
        
        self.temperature = temperature
        self.depth = depth
        self.pollution = pollution
        self.pressure = pressure
    }
    
    
    @objc dynamic var id = ""
    @objc dynamic var isFromServer = false
    
    @objc dynamic var date = Date()
    @objc dynamic var deviceId = ""
    
    @objc dynamic var audioFile = ""
    
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
    
    
    @objc dynamic var temperature: Double = 0.0
    @objc dynamic var depth: Double = 0.0
    @objc dynamic var pollution: Double = 0.0
    @objc dynamic var pressure: Double = 0.0
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    var coordinates: String {
        get {
            return "Lat: \(self.latitude), Long: \(self.longitude)"
        }
    }
    
    var array: [String] {
        get {
            var array = [String]()
            array.append("Lat: " + String(self.latitude))
            array.append("Long: " + String(self.longitude))
            array.append("Temperature: " + String(self.temperature) + " °C")
            array.append("Depth: " + String(self.depth) + " m")
            array.append("Pollution: " + String(self.pollution))
            array.append("Pressure: " + String(self.pressure) + " Pa")
            return array
        }
    }
    
    public func toJson()->JSON {
        var json = JSON()
        
        json["id"] = JSON(id)
        json["deviceId"] = JSON(deviceId)
        json["date"] = JSON(ISO8601DateFormatter().string(from: date))
        
         json["audioFile"] = JSON(audioFile)
        
         json["latitude"] = JSON(latitude)
         json["longitude"] = JSON(longitude)
        
         json["temperature"] = JSON(temperature)
         json["depth"] = JSON(depth)
         json["pollution"] = JSON(pollution)
         json["pressure"] = JSON(pressure)
        
        return json
    }
    
    public func add(obj: DataModel){
        
        //standard
        self.deviceId = obj.deviceId
        self.id = obj.id
        self.latitude = obj.latitude
        self.longitude = obj.longitude
        //self.date = obj.date
        
        //add values
        self.temperature += obj.temperature
        self.depth += obj.depth
        self.pressure += obj.pressure
        self.pollution += obj.pollution
    }
    
    public func divide(value: Int){
        //divide
        self.temperature /= Double(value)
        self.depth /= Double(value)
        self.pressure /= Double(value)
        self.pollution /= Double(value)
    }
}
