//
//  GpsViewController.swift
//  WhalesAppIOS
//
//  Created by Pedro Ribeiro on 29/05/2018.
//  Copyright © 2018 Pedro Ribeiro. All rights reserved.
//

import UIKit
import MapKit
import AVFoundation

class GpsViewController: UIViewController, MKMapViewDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    var selectedData: DataModel?
    
    weak var annotation: MapAnnotation?
    
    var player: AVAudioPlayer?
    
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
        
        //playSound()
        
    }
    
    func centerMapOnLocation(location: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "Pompeii", withExtension: "wav") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
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



