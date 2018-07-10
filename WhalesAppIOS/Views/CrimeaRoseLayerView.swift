//
//  CrimeaRoseLayerView.swift
//  WhalesAppIOS
//
//  Created by Pedro Ribeiro on 09/07/2018.
//  Copyright © 2018 Pedro Ribeiro. All rights reserved.
//

import UIKit

class CrimeaRoseLayerView: UIView {

    
    override func draw(_ rect: CGRect) {
        drawShapeLayer()
    }
    
    
    private func drawShapeLayer(){
        let path = createREctangle()
        
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.path = path.cgPath
        
        self.layer.addSublayer(shapeLayer)
        
    }
    
    private func createREctangle()->UIBezierPath{
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 0, y: 0))
        
        path.addLine(to: CGPoint(x: 50, y: 0))
        
        path.addLine(to: CGPoint(x: 50, y: 50))
        
        path.addLine(to: CGPoint(x: 0, y: 50))
        
        path.close()
        
        return path
    }
    
    
    /// handles the pinch to zoom gesture -> just scales the view
    @objc func didPinch(pinchGR: UIPinchGestureRecognizer){
        switch pinchGR.state {
        case .changed, .ended:
            let scale = pinchGR.scale
            self.layer.setAffineTransform(self.layer.affineTransform().scaledBy(x: scale, y: scale))
            pinchGR.scale = 1.0
        default:
            break
        }
    }

}
