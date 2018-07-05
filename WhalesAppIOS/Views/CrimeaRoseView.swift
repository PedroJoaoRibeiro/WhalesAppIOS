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
    
    //------------------- public vars can be set by the user
    
    ///color of the line that draws the bounds of the rose default: black
    public var lineColor = UIColor.black
    
    ///with of the line that draws the bounds of the rose default: 1.0
    public var lineWidth:CGFloat = 1.0
    
    ///maximum value to show
    public var maxValue:CGFloat = 25
    
    ///minimum value to show
    public var minValue:CGFloat = -25

    
    //----------------- Main Drawing function -------------//
    
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        //if there is no data to show just present a label saying that
        if(arrayOfLabels.count == 0) {
            //TODO
        } else {
            
            var arrayOfObjs = [ObjtoDraw]()
            
            for array in arrayOfCrimeaRoseData {
                
                //seting the angle of each small circle
                let angle = (2*CGFloat.pi) / CGFloat(arrayOfLabels.count)
                var startAngle = CGFloat(2*CGFloat.pi);
                
                for obj in array.arrayOfData{
                    let radius = scale(value: CGFloat(obj))
                    
                    arrayOfObjs.append(ObjtoDraw(radius: radius, startAngle: startAngle, endAngle: startAngle - angle, fillColor: array.color))
                    
                    startAngle = startAngle - angle
                }
            }
            
            for obj in arrayOfObjs.sorted(by: {$0.radius > $1.radius}){
                drawSmallSemiCircle(radius: obj.radius, startAngle: obj.startAngle, endAngle: obj.endAngle, fillColor: obj.fillColor)
            }
        }
    }
    
    //------------------- Methods -----------------------//
    
    /// updates the view call this when there is changes in the data
    private func updateDisplay(){
        self.setNeedsDisplay()
        self.setNeedsLayout()
    }
    
    /// calls the method to draw the vew with the data. Needs the values, the labels, and the colors
    public func drawRose(arrayOfCrimeaRoseData: [CrimeaRoseData], arrayOfLabels:[String]) throws{
        
        for obj in arrayOfCrimeaRoseData {
            if(obj.arrayOfData.count != arrayOfLabels.count){
                throw MyErrors.DiferentNumberOfElements(msg: "the number of labels doesn't match the number of elements in one of the arrays")
            }
        }
        
        
        self.arrayOfCrimeaRoseData = arrayOfCrimeaRoseData
        self.arrayOfLabels = arrayOfLabels
        
        // sets the scale to be the maximum of the data
        for array in arrayOfCrimeaRoseData {
            if(maxValue < CGFloat(array.arrayOfData.max()!)){
                maxValue = CGFloat(array.arrayOfData.max()!)
            }
            if(minValue > CGFloat(array.arrayOfData.min()!)){
                minValue = CGFloat(array.arrayOfData.min()!)
            }
        }
        updateDisplay()
    }
    
    ///draws a semicircle in the center of the view
    private func drawSmallSemiCircle(radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, fillColor: UIColor) {
        
        let path = UIBezierPath()
        
        path.addArc(withCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        path.addLine(to: CGPoint(x: bounds.midX, y: bounds.midY))
        path.close()
        
        path.lineWidth = lineWidth
        
        lineColor.setStroke()
        fillColor.setFill()
        path.fill()
        path.stroke()
    }
    
    ///https://stackoverflow.com/questions/5294955/how-to-scale-down-a-range-of-numbers-with-a-known-min-and-max-value ---
    /// a is 0 and b is the viewRadius
    private func scale(value: CGFloat) -> CGFloat{
        return (viewRadius * (value - minValue)) / (maxValue - minValue)
    }
    

}

extension CrimeaRoseView {
    
    private var viewRadius: CGFloat {
        get {
            if bounds.width > bounds.height {
                return (bounds.height - 30)/2
            } else {
                return (bounds.width - 30)/2
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
    
    init(radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, fillColor: UIColor) {
        self.radius = radius
        self.startAngle = startAngle
        self.endAngle = endAngle
        self.fillColor = fillColor
    }
}

