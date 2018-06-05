//
//  MapAnnotationView.swift
//  WhalesAppIOS
//
//  Created by Pedro Ribeiro on 05/06/2018.
//  Copyright © 2018 Pedro Ribeiro. All rights reserved.
//

import Foundation
import MapKit

class MapAnnotationView: MKAnnotationView {
    var imgView:UIImageView!
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        self.canShowCallout = true
        self.frame = CGRect(origin: CGPoint.zero,size: CGSize(width: 30, height: 30))
        self.imgView = UIImageView(image: UIImage(named: "Pin"))
        self.imgView.contentMode = .scaleAspectFit
        self.imgView.frame = self.bounds
        self.addSubview(self.imgView)
    }
    
    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
    }
    
}
