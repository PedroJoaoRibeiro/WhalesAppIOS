//
//  GpsViewController.swift
//  WhalesAppIOS
//
//  Created by Pedro Ribeiro on 29/05/2018.
//  Copyright © 2018 Pedro Ribeiro. All rights reserved.
//

import UIKit
import MapKit

class GpsViewController: UIViewController, MKMapViewDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    var selectedData: DataModel?
    
    weak var annotation: MapAnnotation?
    
    
    let regionRadius: CLLocationDistance = 10000
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        let db = DbConnection()
        let arrayData = db.getDataFromDb()
        
        let initialLocation = CLLocationCoordinate2D(latitude: arrayData.last!.latitude, longitude: arrayData.last!.longitude)
        centerMapOnLocation(location: initialLocation)
        
        for obj in arrayData {
            let title = "Date: " + obj.date.toString(withFormat: "yyyy-MM-dd HH:mm:ss")
            let coordinate = CLLocationCoordinate2D(latitude: obj.latitude, longitude: obj.longitude)
            let annotation = MapAnnotation(title: title, data: obj, coordinate: coordinate)
            mapView.addAnnotation(annotation)
        }
        
    }
    
    func centerMapOnLocation(location: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        let reuseIdentifier = "pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        if annotationView == nil {
            annotationView = MapAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        } else {
            annotationView!.annotation = annotation
        }
        return annotationView
    }
    
    
    
}



