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
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var dateTypePicker: UIPickerView!
    
    @IBOutlet weak var leftButtonDatePicker: UIButton!
    @IBOutlet weak var rightButtonDatePicker: UIButton!
    
    @IBOutlet weak var leftDateLabel: UILabel!
    @IBOutlet weak var rightDateLabel: UILabel!
    
    private var currentDate = Date()
    
    private var firstDateToCompare = Date()
    private var secondDateToCompare = Date()
    
    private let pickerData = ["Day", "Week", "Moth", "Year"]
    
    
    private let firstUIColor = UIColor(red:0.02, green:0.59, blue:1.00, alpha:1.0)
    private let secondUIColor = UIColor(red:0.95, green:0.91, blue:0.31, alpha:1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dateTypePicker.delegate = self
        self.dateTypePicker.dataSource = self
        
        dateTypePicker.selectRow(3, inComponent: 0, animated: false)
        
        firstDateToCompare = Date() // current Date
        secondDateToCompare = Calendar.current.date(byAdding: .year, value: -1, to: firstDateToCompare)! // subtract one year to the current date
        
        
        drawChartForYear()
        
    }
    
    
    private func drawChartForDay(){
        
    }
    private func drawChartForWeek(){
        
    }
    private func drawChartForMonth(){
        
    }
    
    ///draws the data to compare by year
    private func drawChartForYear(){
        let arrayFirstYear = DbConnection().getDateForYear(currentDate: firstDateToCompare)
        let arraySecondYear = DbConnection().getDateForYear(currentDate: secondDateToCompare)
        
        var arrayOfDataFirst: [Double]
        var arrayOfDataSecond: [Double]
        
        if arrayFirstYear.isEmpty {
            arrayOfDataFirst = Array(repeating: 0, count: 12)
        } else {
            arrayOfDataFirst = getArrayOfDataFromSelectedComponent(array: arrayFirstYear)
        }
        
        if arraySecondYear.isEmpty {
            arrayOfDataSecond = Array(repeating: 0, count: 12)
        } else {
            arrayOfDataSecond = getArrayOfDataFromSelectedComponent(array: arraySecondYear)
        }
        
        
        //array that handles the data
        var arrayOfCrimeaRoseData = [CrimeaRoseData]()
        
        arrayOfCrimeaRoseData.append(CrimeaRoseData(arrayOfData: arrayOfDataFirst, color: firstUIColor))
        arrayOfCrimeaRoseData.append(CrimeaRoseData(arrayOfData: arrayOfDataSecond, color: secondUIColor))
        
        
        do {
            try crimeaRoseView.drawRose(arrayOfCrimeaRoseData: arrayOfCrimeaRoseData, arrayOfLabels: getArrayOfLabels())
            updateLabels()
        } catch {
            print(error)
        }
    }
    
    
    /// returns an array based on the component selected in the segmentedControl
    private func getArrayOfDataFromSelectedComponent(array: [DataModel])->[Double]{
        var arrayOfData = [Double]()
        
        for obj in array {
            switch segmentedControl.selectedSegmentIndex {
                case 0:
                    arrayOfData.append(obj.temperature)
                    break
                case 1:
                    arrayOfData.append(obj.depth)
                    break
                case 2:
                    arrayOfData.append(obj.pressure)
                    break
                case 3:
                    arrayOfData.append(obj.turbidity)
                    break
                case 4:
                    arrayOfData.append(obj.ph)
                    break
                case 5:
                    arrayOfData.append(obj.oxygen)
                    break
                default:
                    fatalError("segmented control index error in CrimeaRoseViewController")
            }
        }
        
        return arrayOfData
    }
    
    /// returns an array of the labels for the selected data
    private func getArrayOfLabels() -> [String]{
        var arrayOfLabels = [String]()
        
        switch dateTypePicker.selectedRow(inComponent: 0) {
        case 0: //Day
            
            break
        case 1: //Week
            
            break
        case 2: //Month
            
            break
        case 3: //Year
            for i in 0..<12 {
                arrayOfLabels.append(Calendar.current.shortMonthSymbols[i])
            }
            break
        default:
            fatalError("pickerView in crimeaRose have more items then expected")
        }
        
        return arrayOfLabels
    }
    
    private func updateLabels(){
        switch dateTypePicker.selectedRow(inComponent: 0) {
        case 0: //Day
            leftDateLabel.text = "Year: \(firstDateToCompare.toString(withFormat: "dd MMM yyyy"))"
            rightDateLabel.text = "Year: \(secondDateToCompare.toString(withFormat: "dd MMM yyyy"))"
            break
        case 1: //Week
            leftDateLabel.text = "Year: \(firstDateToCompare.toString(withFormat: "yyyy")) TODO"
            rightDateLabel.text = "Year: \(secondDateToCompare.toString(withFormat: "yyyy")) TODO"
            break
        case 2: //Month
            leftDateLabel.text = "\(firstDateToCompare.toString(withFormat: "MMM yyyy"))"
            rightDateLabel.text = "\(secondDateToCompare.toString(withFormat: "MMM yyyy"))"

            break
        case 3: //Year
            leftDateLabel.text = "\(firstDateToCompare.toString(withFormat: "yyyy"))"
            rightDateLabel.text = "\(secondDateToCompare.toString(withFormat: "yyyy"))"
            break
        default:
            fatalError("pickerView in crimeaRose have more items then expected")
        }
        
    }
    
    
    //------------------- Handling touch events
    ///recognizer for the tap on a view
    @objc func didTap(tapGR: UITapGestureRecognizer){
        switch tapGR.state {
        case .ended:
            for subview in crimeaRoseView.subviews {
                if subview.frame.contains(tapGR.location(in: crimeaRoseView)) {
                    if let label = subview as? UILabel {
                        print(label.text!)
                    }
                }
            }
            
            
            let index = crimeaRoseView.checkTap(point: tapGR.location(in: crimeaRoseView))
            if(index != -1){
                print(Calendar.current.monthSymbols[index])
            }
        default:
            break
        }
    }
    
    
    //--------------Handles changes
    ///handles the change on the segmented control, basicly only needs to check which dateTypePicker is selected and call the respective method
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        switch dateTypePicker.selectedRow(inComponent: 0) {
        case 0: //Day
            drawChartForDay()
            break
        case 1: //Week
            drawChartForWeek()
            break
        case 2: //Month
            drawChartForMonth()
            break
        case 3: //Year
            drawChartForYear()
            break
        default:
            fatalError("pickerView in crimeaRose have more items then expected")
        }
    }
    
    @IBAction func firstDateButtonTouched(_ sender: UIButton) {
    }
    
    @IBAction func secondDateButtonTouched(_ sender: UIButton) {
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
    
    /// Handles the selection of a new row
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row {
        case 0: //Day
            drawChartForDay()
            break
        case 1: //Week
            drawChartForWeek()
            break
        case 2: //Month
            drawChartForMonth()
            break
        case 3: //Year
            drawChartForYear()
            break
        default:
            fatalError("pickerView in crimeaRose have more items then expected")
        }
    }
}
