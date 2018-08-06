//
//  CrimeaRoseView.swift
//  WhalesAppIOS
//
//  Created by Pedro Ribeiro on 04/07/2018.
//  Copyright © 2018 Pedro Ribeiro. All rights reserved.
//

import UIKit

class CrimeaRoseView: UIView {
    //------------------- private vars cannot be set by the user
    
    private var arrayOfCrimeaRoseData = [CrimeaRoseData]()
    private var arrayOfLabels = [String]()
    private var arrayOfPaths = [UIBezierPath: Int]()
    
    //------------------- public vars can be set by the user
    
    ///color of the line that draws the bounds of the rose default: black
    public var lineColor = UIColor.black
    
    ///with of the line that draws the bounds of the rose default: 1.0
    public var lineWidth:CGFloat = 1.0
    
    ///maximum value to show
    public var maxValue:CGFloat = CGFloat.leastNormalMagnitude
    
    ///minimum value to show
    public var minValue:CGFloat = CGFloat.greatestFiniteMagnitude
    
    ///font for the labels around the circle -> default "Helvetica-Bold" size: 12
    public var labelFont = UIFont(name: "Helvetica-Bold", size: 12)
    
    ///color for the labels around the circle -> default black
    public var labelTextColor = UIColor.black
    
    ///hides the labels around the circles -> default false
    private var areLabelsHidden = false
    
    
    //----------------------- Public Methods ------------------------//
    
    /// calls the method to draw the vew with the data. Needs the values, the labels, and the colors
    public func drawRose(arrayOfCrimeaRoseData: [CrimeaRoseData], arrayOfLabels:[String], maxValue: Double, minValue: Double) {
        //cleans the data
        self.arrayOfCrimeaRoseData = [CrimeaRoseData]()
        self.arrayOfLabels = [String]()
        self.arrayOfPaths = [UIBezierPath: Int]()
        self.maxValue = CGFloat(maxValue)
        self.minValue = CGFloat(minValue)
        
        _ = self.subviews.map({$0.removeFromSuperview()})
        
        self.arrayOfCrimeaRoseData = arrayOfCrimeaRoseData
        self.arrayOfLabels = arrayOfLabels
        
        print(maxValue)
        print(minValue)
        
        updateDisplay()
    }

    
    //----------------- Main Drawing function -------------//
    
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        //if there is no data to show just present a label saying that
        if(maxValue == minValue) {
            let label = UILabel()
            
            let x: CGFloat = bounds.midX
            let y: CGFloat = bounds.midY
            
            label.font = labelFont
            label.frame = CGRect(x: x, y: y, width: bounds.width, height: 50)
            label.text = "There is no data for the current selected dates"
            label.textAlignment = .center
            label.textColor = labelTextColor
            label.isHidden = areLabelsHidden
            
            label.center = CGPoint(x: x, y: y)
    
            self.addSubview(label)
        } else {
            
            var arrayOfObjs = [ObjtoDraw]()
            
            for array in arrayOfCrimeaRoseData {
                
                //seting the angle of each small circle
                let angle = (2*CGFloat.pi) / CGFloat(arrayOfLabels.count)
                var startAngle = CGFloat(2*CGFloat.pi);
                
                for i in 0..<array.arrayOfData.count{
                    let radius = scale(value: CGFloat(array.arrayOfData[i]))
                    
                    arrayOfObjs.append(ObjtoDraw(radius: radius, startAngle: startAngle, endAngle: startAngle - angle, fillColor: array.color, category: i))
                    
                    startAngle = startAngle - angle
                }
            }
            
            for obj in arrayOfObjs.sorted(by: {$0.radius > $1.radius}){
                drawSmallSemiCircle(radius: obj.radius, startAngle: obj.startAngle, endAngle: obj.endAngle, fillColor: obj.fillColor, category: obj.category)
            }
            
            // draws labels
            let angle = (2*CGFloat.pi) / CGFloat(arrayOfLabels.count)
            var startAngle = CGFloat(2*CGFloat.pi);
            for i in 0..<arrayOfLabels.count {
                let obj = arrayOfObjs.filter({$0.startAngle == startAngle}).max(by: {$0.radius < $1.radius})!
                
                drawLabels(string: arrayOfLabels[i], angle: startAngle - (angle/2), radius: obj.radius)
                
                startAngle = startAngle - angle
            }
        }
        
    }
    
    
    //------------------- Handling Events ---------------//
    
    /// handles the pinch to zoom gesture -> just scales the view
    @objc func didPinch(pinchGR: UIPinchGestureRecognizer){
        switch pinchGR.state {
        case .changed, .ended:
            let scale = pinchGR.scale
            self.transform = self.transform.scaledBy(x: scale, y: scale)
            pinchGR.scale = 1.0
        default:
            break
        }
    }
    
    /// handles the pan gesture -> just changes the center of the view to the new coordinates
    @objc func didPan(panGR: UIPanGestureRecognizer){
        switch panGR.state {
        case .changed, .ended:
            let translation = panGR.translation(in: self)
            
            self.center.x += translation.x
            self.center.y += translation.y
            
            panGR.setTranslation(CGPoint(x: 0, y: 0), in: self)
            
            
        default:
            break
        }
    }
    
    /// handles the rotation of the view -> does a transformation on the view based on the rotation aplied
    @objc func didRotate(rotationGR: UIRotationGestureRecognizer){
        switch rotationGR.state {
        case .changed, .ended :
            let rotation = rotationGR.rotation
            self.transform = self.transform.rotated(by: rotation)
            rotationGR.rotation = 0.0
        default:
            break
        }
    }
    
    public func checkTap(point: CGPoint)->Int{
        for (path, index) in arrayOfPaths {
            if path.contains(point){
                return index
            }
        }
        
        return -1
    }
    
    //------------------- Methods -----------------------//
    
    
    
    /// updates the view call this when there is changes in the data
    private func updateDisplay(){
        self.setNeedsDisplay()
        self.setNeedsLayout()
    }
    
    
    ///draws a semicircle in the center of the view
    private func drawSmallSemiCircle(radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, fillColor: UIColor, category: Int) {
        
        let path = UIBezierPath()
        
        path.addArc(withCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        path.addLine(to: CGPoint(x: bounds.midX, y: bounds.midY))
        path.close()
        
        path.lineWidth = lineWidth
        
        lineColor.setStroke()
        fillColor.setFill()
        path.fill()
        path.stroke()
        
        arrayOfPaths[path] = category
    }
    
    ///https://stackoverflow.com/questions/5294955/how-to-scale-down-a-range-of-numbers-with-a-known-min-and-max-value ---
    /// a is 0 and b is the viewRadius
    private func scale(value: CGFloat) -> CGFloat{
        return (viewRadius * (value - minValue)) / (maxValue - minValue)
    }
    
    
    /// draws the text Labels -> label is centered 15 points away from the maximum radius value obtained
    private func drawLabels(string: String, angle: CGFloat, radius: CGFloat){
        let label = UILabel()
        
        var r: CGFloat
        
        if radius > viewRadius/2 {
            r = radius
        } else {
            r = viewRadius/2
        }
        
        let x: CGFloat = bounds.midX + ((r + 15) * cos(angle))
        let y: CGFloat = bounds.midY + ((r + 15) * sin(angle))
        
        label.font = labelFont
        label.frame = CGRect(x: x, y: y, width: 30, height: 30)
        label.text = string
        label.textAlignment = .center
        label.textColor = labelTextColor
        label.isHidden = areLabelsHidden
        
        label.center = CGPoint(x: x, y: y)
        
        self.addSubview(label)
    }
    
    
    

}

extension CrimeaRoseView {
    
    private var viewRadius: CGFloat {
        get {
            if bounds.width > bounds.height {
                return (bounds.height - 50)/2
            } else {
                return (bounds.width - 50)/2
            }
        }
    }
    
    private var getRangeForRadius: CGFloat {
        get {
            return abs(maxValue) + abs(minValue)
        }
    }
    
    
}

struct CrimeaRoseData {
    var arrayOfData = [Double]()
    var color = UIColor()
    
    init(arrayOfData: [Double], color: UIColor) {
        self.arrayOfData = arrayOfData
        self.color = color
    }
}

struct ObjtoDraw {
    var radius: CGFloat = 0
    var startAngle: CGFloat = 0
    var endAngle: CGFloat = 0
    var fillColor = UIColor()
    var category = -1;
    init(radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, fillColor: UIColor, category: Int) {
        self.radius = radius
        self.startAngle = startAngle
        self.endAngle = endAngle
        self.fillColor = fillColor
        self.category = category
    }
}

