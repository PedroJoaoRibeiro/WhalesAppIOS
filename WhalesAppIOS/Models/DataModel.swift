//
//  DataModel.swift
//  WhalesAppIOS
//
//  Created by Pedro Ribeiro on 30/05/2018.
//  Copyright © 2018 Pedro Ribeiro. All rights reserved.
//


import RealmSwift
import SwiftyJSON

///Object that is used to save the data to Realm and also use it across the application
class DataModel: Object {
    
    /// init of the object used when receiving from server and device
    convenience init(isFromServer: Bool, deviceId: String, date: String, latitude: Double, longitude: Double, temperature: Double, depth: Double, altitude: Double, pressure: Double, turbidity: Double, ph: Double, oxygen: Double) {
        self.init()
        
        self.id = deviceId + date
        self.isFromServer = isFromServer
        
        self.date = DateFormatter().stringToDate(str: date)!
        self.deviceId = deviceId
        
        self.latitude = latitude
        self.longitude = longitude
        
        self.temperature = temperature
        self.depth = abs(depth)
        self.altitude = altitude
        self.pressure = pressure
        self.turbidity = turbidity
        self.ph = ph
        self.oxygen = oxygen
        
        isNull = false
    }
    
    
    @objc dynamic var id = ""
    @objc dynamic var isFromServer = false
    
    @objc dynamic var date = Date()
    @objc dynamic var deviceId = ""
    
    
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
    
    
    @objc dynamic var temperature: Double = 0.0
    @objc dynamic var depth: Double = 0.0
    @objc dynamic var altitude: Double = 0.0
    @objc dynamic var pressure: Double = 0.0
    @objc dynamic var turbidity: Double = 0.0
    @objc dynamic var ph: Double = 0.0
    @objc dynamic var oxygen: Double = 0.0
    
    //variable used to know if the object is a placeholder (ex average of real data)
    var isNull = true
    
    ///returns the primary key id
    override static func primaryKey() -> String? {
        return "id"
    }
    
    //returns coordinates in Lat:..., Long:...
    var coordinates: String {
        get {
            return "Lat: \(self.latitude), Long: \(self.longitude)"
        }
    }
    
    ///returns an array of strings with all the information
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
    
    /// converts the object into JSON to send to the server
    public func toJson()->JSON {
        var json = JSON()
        
        json["id"] = JSON(id)
        json["deviceId"] = JSON(deviceId)
        json["date"] = JSON(ISO8601DateFormatter().string(from: date))
        
        
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
    
    /// used to group objects to then calculate the average
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
        
        self.isNull = false
    }
    
    /// used to divide the values in order to obtain the average
    public func divide(value: Int){
        self.temperature /= Double(value)
        self.depth /= Double(value)
        self.altitude /= Double(value)
        self.pressure /= Double(value)
        self.turbidity /= Double(value)
        self.ph /= Double(value)
        self.oxygen /= Double(value)
    }
}
