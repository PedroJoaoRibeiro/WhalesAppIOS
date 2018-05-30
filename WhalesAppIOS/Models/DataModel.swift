//
//  DataModel.swift
//  WhalesAppIOS
//
//  Created by Pedro Ribeiro on 30/05/2018.
//  Copyright © 2018 Pedro Ribeiro. All rights reserved.
//


import RealmSwift

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
}
