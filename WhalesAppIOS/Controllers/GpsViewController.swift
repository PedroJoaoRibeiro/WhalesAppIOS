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
    
    @IBOutlet weak var popUpView: PopUpView!
    
    @IBOutlet var arrayLabels: [UILabel]!
    
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
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? MapAnnotation else {
            return
        }
        
        self.annotation = annotation
        
        updateLabels(annotation: annotation)
        
        popUpView.showView()
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView){
        guard let _ = view.annotation as? MapAnnotation else {
            return
        }
        
        popUpView.hideView()
    }
    
    private func updateLabels(annotation: MapAnnotation){
        for label in arrayLabels {
            switch label.accessibilityIdentifier {
            case "Date":
                label.text = "Date: " + annotation.data.date.toString(withFormat: "yyyy-MM-dd HH:mm:ss")
                break
            case "Latitude":
                label.text = "Lat: " + String(annotation.data.latitude)
                break
            case "Longitude":
                label.text = "Long: " + String(annotation.data.longitude)
                break
            case "Temperature":
                label.text = "Temperature: " + String(annotation.data.temperature)
                break
            case "Depth":
                label.text = "Depth: " + String(annotation.data.depth)
                break
            case "Pollution":
                label.text = "Pollution: " + String(annotation.data.pollution)
                break
            case "Pressure":
                label.text = "Pressure: " + String(annotation.data.pressure)
                break
                
            default:
                break
            }
        }
    }
    
    
}



