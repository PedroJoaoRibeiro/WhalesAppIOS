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
    
    convenience init(isFromServer: Bool, deviceId: String, date: String, audioFile: String, latitude: Double, longitude: Double, temperature: Double, depth: Double, altitude: Double, pressure: Double, turbidity: Double, ph: Double, oxygen: Double) {
        self.init()
        
        self.id = deviceId + date
        self.isFromServer = isFromServer
        
        self.date = DateFormatter().stringToDate(str: date)!
        self.deviceId = deviceId
        
        self.audioFile = audioFile
        self.latitude = latitude
        self.longitude = longitude
        
        self.temperature = temperature
        self.depth = abs(depth)
        self.altitude = altitude
        self.pressure = pressure
        self.turbidity = turbidity
        self.ph = ph
        self.oxygen = oxygen
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
    @objc dynamic var altitude: Double = 0.0
    @objc dynamic var pressure: Double = 0.0
    @objc dynamic var turbidity: Double = 0.0
    @objc dynamic var ph: Double = 0.0
    @objc dynamic var oxygen: Double = 0.0
    
    
    
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
            array.append(String(format: "Lat: %.04f", self.latitude))
            array.append(String(format: "Long: %.04f", self.longitude))
            array.append(String(format: "Temperature: %.02f °C", self.temperature))
            array.append(String(format: "Depth: %.02f m", self.depth))
            array.append(String(format: "Altitude: %.02f m", self.altitude))
            array.append(String(format: "Pressure: %.02f bar", self.pressure))
            array.append(String(format: "Turbidity: %d", self.turbidity))
            array.append(String(format: "Ph: %.02f", self.ph))
            array.append(String(format: "Oxygen: %.02f mg/L", self.oxygen))
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
        json["altitude"] = JSON(altitude)
        json["pressure"] = JSON(pressure)
        json["turbidity"] = JSON(turbidity)
        json["ph"] = JSON(ph)
        json["oxygen"] = JSON(oxygen)
        
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
        self.altitude += obj.altitude
        self.pressure += obj.pressure
        self.turbidity += obj.turbidity
        self.ph += obj.ph
        self.oxygen += obj.oxygen
    }
    
    public func divide(value: Int){
        //divide
        self.temperature /= Double(value)
        self.depth /= Double(value)
        self.altitude /= Double(value)
        self.pressure /= Double(value)
        self.turbidity /= Double(value)
        self.ph /= Double(value)
        self.oxygen /= Double(value)
    }
}
