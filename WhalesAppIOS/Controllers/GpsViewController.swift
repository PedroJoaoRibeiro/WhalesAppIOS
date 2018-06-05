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
    let regionRadius: CLLocationDistance = 10000
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let initialLocation = CLLocationCoordinate2D(latitude: 32.62317397863358, longitude: -16.90042078632814)
        
        centerMapOnLocation(location: initialLocation)
        
        
        mapView.delegate = self
        
        let db = DbConnection()
        let arrayData = db.getDataFromDb()
        
        let title = "Date: " + arrayData[0].date.toString(withFormat: "yyyy-MM-dd HH:mm:ss")
        
        let annotation = MapAnnotation(title: title, data: arrayData[0], coordinate: initialLocation)
        mapView.addAnnotation(annotation)
        
    }
    
    func centerMapOnLocation(location: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? MapAnnotation else {
            return nil
        }
        
        let reuseIdentifier = "pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        configureDetailView(annotationView: annotationView!)
        
        return annotationView
    }
    
    func configureDetailView(annotationView: MKAnnotationView) {
        let width = 300
        let height = 200
        
        let snapshotView = UIView()
        let views = ["snapshotView": snapshotView]
        snapshotView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[snapshotView(300)]", options: [], metrics: nil, views: views))
        snapshotView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[snapshotView(200)]", options: [], metrics: nil, views: views))
        
        
        
        annotationView.detailCalloutAccessoryView = snapshotView
    }
    
    
    
}



