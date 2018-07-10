//
//  ExploreDataViewController.swift
//  WhalesAppIOS
//
//  Created by Pedro Ribeiro on 05/05/2018.
//  Copyright © 2018 Pedro Ribeiro. All rights reserved.
//

import Foundation
import UIKit
import Charts
import SwiftyJSON



class ExploreDataViewController: UIViewController {
    

    @IBOutlet weak var crimeaRoseView: CrimeaRoseLayerView! {
        didSet{
            let pinch = UIPinchGestureRecognizer(target: crimeaRoseView, action: #selector(crimeaRoseView.didPinch(pinchGR:)))
            
            crimeaRoseView.addGestureRecognizer(pinch)
        }
    }
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }    
}


