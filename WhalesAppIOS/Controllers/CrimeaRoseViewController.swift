//
//  CrimeaRoseViewController.swift
//  WhalesAppIOS
//
//  Created by Pedro Ribeiro on 29/05/2018.
//  Copyright © 2018 Pedro Ribeiro. All rights reserved.
//


import UIKit

class CrimeaRoseViewController: UIViewController {

    @IBOutlet weak var crimeaRoseView: CrimeaRoseView! {
        didSet {
            // sets the gestures recognizers for the view
            let pinch = UIPinchGestureRecognizer(target: crimeaRoseView, action: #selector(crimeaRoseView.didPinch(pinchGR:)))
            let panGR = UIPanGestureRecognizer(target: crimeaRoseView, action: #selector(crimeaRoseView.didPan(panGR:)))
            let rotationGR = UIRotationGestureRecognizer(target: crimeaRoseView, action: #selector(crimeaRoseView.didRotate(rotationGR:)))
            let tapGR = UITapGestureRecognizer(target: self, action: #selector(didTap(tapGR:)))
            
            crimeaRoseView.addGestureRecognizer(pinch)
            crimeaRoseView.addGestureRecognizer(panGR)
            crimeaRoseView.addGestureRecognizer(rotationGR)
            crimeaRoseView.addGestureRecognizer(tapGR)
            
        }
    }
    
    private var currentDate = Date()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let array = getDateForYear()
        var arrayOfLabels = [String]()
        
        var arrayOfCrimeaRoseData = [CrimeaRoseData]()
        
        
        var incre = -26.0
        var arrayOfData = [Double]()
        for _ in 0..<array.count {
            arrayOfData.append(incre)
            incre += 5
        }
        arrayOfCrimeaRoseData.append(CrimeaRoseData(arrayOfData: arrayOfData, color: UIColor(red:0.02, green:0.59, blue:1.00, alpha:1.0)))
        
        arrayOfData = [Double]()
        incre = 0.0
        for _ in 0..<array.count {
            arrayOfData.append(incre)
            incre += 5
        }
        arrayOfCrimeaRoseData.append(CrimeaRoseData(arrayOfData: arrayOfData, color: UIColor(red:0.95, green:0.91, blue:0.31, alpha:1.0)))
        
        arrayOfData = [Double]()
         incre = -26.0
        for i in 0..<array.count {
            arrayOfData.append(incre)
            arrayOfLabels.append(Calendar.current.shortMonthSymbols[i])
            incre += 10
        }
        arrayOfCrimeaRoseData.append(CrimeaRoseData(arrayOfData: arrayOfData, color: UIColor(red:0.91, green:0.28, blue:0.33, alpha:1.0)))
        
        do {
            try crimeaRoseView.drawRose(arrayOfCrimeaRoseData: arrayOfCrimeaRoseData, arrayOfLabels: arrayOfLabels)
        } catch {
            print(error)
        }
        
    }
    
    
    private func getDateForYear() -> [DataModel] {
        //connects to the database to get the data
        let db = DbConnection()
        var array = db.getDataFromDb()
        
        array = array.filter { Calendar.current.isDate($0.date, equalTo: currentDate, toGranularity: .year)}
        
        // if there is no data just return nil
        if array.isEmpty {
            return [DataModel]()
        }
        
        let dict = Dictionary(grouping: array) {$0.date.month}
        
        //initialize the array with fixed size
        var finalArray = [DataModel]()
        var component = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: currentDate)
        component.month = 1
        component.day = 1
        var d = Calendar.current.date(from: component)!
        for _ in 0..<12 {
            let obj = DataModel()
            obj.date = d
            finalArray.append(obj)
            d = Calendar.current.date(byAdding: .month, value: 1, to: d)!
        }
        
        for (key, value) in dict {
            for v in value {
                finalArray[key-1].add(obj: v)
            }
            finalArray[key-1].divide(value: value.count)
        }
        
        return finalArray
    }
    
    //------------------- Handling touch events
    @objc func didTap(tapGR: UITapGestureRecognizer){
        switch tapGR.state {
        case .ended:
            let index = crimeaRoseView.checkTap(point: tapGR.location(in: crimeaRoseView))
            if(index != -1){
                print(Calendar.current.monthSymbols[index])
            }
        default:
            break
        }
    }
    
    
}
