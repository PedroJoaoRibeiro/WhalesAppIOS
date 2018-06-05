//
//  MapAnnotation.swift
//  WhalesAppIOS
//
//  Created by Pedro Ribeiro on 04/06/2018.
//  Copyright © 2018 Pedro Ribeiro. All rights reserved.
//

import Foundation
import MapKit

class MapAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    
    let title: String?
    let data: DataModel
    let pinCustomImageName = "whaleIcon"
    
    
    init(title: String, data: DataModel, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.data = data
        self.coordinate = coordinate
        
        super.init()
    }
    
}
