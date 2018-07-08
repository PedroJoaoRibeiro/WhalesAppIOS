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
    @IBOutlet weak var dateTypePicker: UIPickerView!
    
    private var currentDate = Date()
    
    private let pickerData = ["Day", "Week", "Moth", "Year"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dateTypePicker.delegate = self
        self.dateTypePicker.dataSource = self
        
        
        let array = DbConnection().getDateForYear(currentDate: Date())
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
    private func drawChartForDay(){
        
    }
    private func drawChartForWeek(){
        
    }
    private func drawChartForMonth(){
        
    }
    private func drawChartForYear(){
        
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

extension CrimeaRoseViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    /// The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /// The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    /// The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
}
