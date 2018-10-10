//
//  CrimeaRoseViewController.swift
//  WhalesAppIOS
//
//  Created by Pedro Ribeiro on 29/05/2018.
//  Copyright © 2018 Pedro Ribeiro. All rights reserved.
//


import UIKit
import DatePickerDialog

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
    
    
    @IBOutlet weak var blueLabel: UILabel!
    @IBOutlet weak var yellowLabel: UILabel!
    
    
    private var currentDate = Date()
    
    private var firstDateToCompare = Date()
    private var secondDateToCompare = Date()
    
    private let pickerData = ["Day", "Week", "Month", "Year"]
    
    
    private let firstUIColor = UIColor(red:0.02, green:0.59, blue:1.00, alpha:1.0)
    private let secondUIColor = UIColor(red:0.95, green:0.91, blue:0.31, alpha:1.0)
    
    // arrays with the data
    private var arrayLabels = [String]()
    private var arrayOfCrimeaRoseData = [CrimeaRoseData]()
    private var indexTouched = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dateTypePicker.delegate = self
        self.dateTypePicker.dataSource = self
        
        leftDateLabel.backgroundColor = firstUIColor
        rightDateLabel.backgroundColor = secondUIColor
        
        dateTypePicker.selectRow(3, inComponent: 0, animated: false)
        
        firstDateToCompare = Date() // current Date
        secondDateToCompare = Calendar.current.date(byAdding: .year, value: 0, to: firstDateToCompare)! // subtract one year to the current date
        
        updateLabels()
        drawChartForYear()
        
    }
    
    ///draws the data to compare by day
    private func drawChartForDay(){
        let arrayFirstdDay = DbConnection().getDateForDay(currentDate: firstDateToCompare)
        let arraySecondDay = DbConnection().getDateForDay(currentDate: secondDateToCompare)

        var arrayOfDataFirst: [Double]
        var arrayOfDataSecond: [Double]
        
        var (minValue, maxValue) = getMinMaxValue(minValue: Double.greatestFiniteMagnitude, maxValue: Double.leastNormalMagnitude, array: arrayFirstdDay)
        (minValue, maxValue) = getMinMaxValue(minValue: minValue, maxValue: maxValue, array: arraySecondDay)
        
        // take 10 % of the min value to note diference between no values and the actual min value
        if minValue == Double.greatestFiniteMagnitude {
            //means that there is nothing to draw
            minValue = 0
            maxValue = 0
        } else {
            // scalle is better if starts always from zero
            minValue = 0
        }
        
        
        if arrayFirstdDay.isEmpty {
            arrayOfDataFirst = Array(repeating: 0, count: 24)
        } else {
            arrayOfDataFirst = getArrayOfDataFromSelectedComponent(array: arrayFirstdDay, minValue: minValue)
        }
        
        if arraySecondDay.isEmpty {
            arrayOfDataSecond = Array(repeating: 0, count: 24)
        } else {
            arrayOfDataSecond = getArrayOfDataFromSelectedComponent(array: arraySecondDay, minValue: minValue)
        }
        
        arrayOfCrimeaRoseData = [CrimeaRoseData]()
        
        arrayOfCrimeaRoseData.append(CrimeaRoseData(arrayOfData: arrayOfDataFirst, color: firstUIColor))
        arrayOfCrimeaRoseData.append(CrimeaRoseData(arrayOfData: arrayOfDataSecond, color: secondUIColor))
        
        
        crimeaRoseView.drawRose(arrayOfCrimeaRoseData: arrayOfCrimeaRoseData, arrayOfLabels: getArrayOfLabels(), maxValue: maxValue, minValue: minValue)
        
    }
    
    ///draws the data to compare by week
    private func drawChartForWeek(){
        
        let arrayFirstWeek = DbConnection().getDateForWeek(currentDate: firstDateToCompare)
        let arraySecondWeek = DbConnection().getDateForWeek(currentDate: secondDateToCompare)
        
        var arrayOfDataFirst: [Double]
        var arrayOfDataSecond: [Double]
        
        var (minValue, maxValue) = getMinMaxValue(minValue: Double.greatestFiniteMagnitude, maxValue: Double.leastNormalMagnitude, array: arrayFirstWeek)
        (minValue, maxValue) = getMinMaxValue(minValue: minValue, maxValue: maxValue, array: arraySecondWeek)
        
        // take 10 % of the min value to note diference between no values and the actual min value
        if minValue == Double.greatestFiniteMagnitude {
            //means that there is nothing to draw
            minValue = 0
            maxValue = 0
        } else {
            // scalle is better if starts always from zero
            minValue = 0
        }
        
        
        if arrayFirstWeek.isEmpty {
            arrayOfDataFirst = Array(repeating: 0, count: 7)
        } else {
            arrayOfDataFirst = getArrayOfDataFromSelectedComponent(array: arrayFirstWeek, minValue: minValue)
        }
        
        if arraySecondWeek.isEmpty {
            arrayOfDataSecond = Array(repeating: 0, count: 7)
        } else {
            arrayOfDataSecond = getArrayOfDataFromSelectedComponent(array: arraySecondWeek, minValue: minValue)
        }
        
        arrayOfCrimeaRoseData = [CrimeaRoseData]()
        
        arrayOfCrimeaRoseData.append(CrimeaRoseData(arrayOfData: arrayOfDataFirst, color: firstUIColor))
        arrayOfCrimeaRoseData.append(CrimeaRoseData(arrayOfData: arrayOfDataSecond, color: secondUIColor))
        
        
        crimeaRoseView.drawRose(arrayOfCrimeaRoseData: arrayOfCrimeaRoseData, arrayOfLabels: getArrayOfLabels(), maxValue: maxValue, minValue: minValue)
        
    }
    
    ///draws the data to compare by month
    private func drawChartForMonth(){
        let arrayFirstMonth = DbConnection().getDateForMonth(currentDate: firstDateToCompare)
        let arraySecondMonth = DbConnection().getDateForMonth(currentDate: secondDateToCompare)
        
        var arrayOfDataFirst: [Double]
        var arrayOfDataSecond: [Double]
        
        var (minValue, maxValue) = getMinMaxValue(minValue: Double.greatestFiniteMagnitude, maxValue: Double.leastNormalMagnitude, array: arrayFirstMonth)
        (minValue, maxValue) = getMinMaxValue(minValue: minValue, maxValue: maxValue, array: arraySecondMonth)
        
        // take 10 % of the min value to note diference between no values and the actual min value
        if minValue == Double.greatestFiniteMagnitude {
            //means that there is nothing to draw
            minValue = 0
            maxValue = 0
        } else {
            // scalle is better if starts always from zero
            minValue = 0
        }
        
        
        if arrayFirstMonth.isEmpty {
            arrayOfDataFirst = Array(repeating: 0, count: 12)
        } else {
            arrayOfDataFirst = getArrayOfDataFromSelectedComponent(array: arrayFirstMonth, minValue: minValue)
        }
        
        if arraySecondMonth.isEmpty {
            arrayOfDataSecond = Array(repeating: 0, count: 12)
        } else {
            arrayOfDataSecond = getArrayOfDataFromSelectedComponent(array: arraySecondMonth, minValue: minValue)
        }
        
        //array that handles the data
        arrayOfCrimeaRoseData = [CrimeaRoseData]()
        
        arrayOfCrimeaRoseData.append(CrimeaRoseData(arrayOfData: arrayOfDataFirst, color: firstUIColor))
        arrayOfCrimeaRoseData.append(CrimeaRoseData(arrayOfData: arrayOfDataSecond, color: secondUIColor))
        
        crimeaRoseView.drawRose(arrayOfCrimeaRoseData: arrayOfCrimeaRoseData, arrayOfLabels: getArrayOfLabels(), maxValue: maxValue, minValue: minValue)
        
    }
    
    ///draws the data to compare by year
    private func drawChartForYear(){
        let arrayFirstYear = DbConnection().getDateForYear(currentDate: firstDateToCompare)
        let arraySecondYear = DbConnection().getDateForYear(currentDate: secondDateToCompare)
        
        var arrayOfDataFirst: [Double]
        var arrayOfDataSecond: [Double]
        
        var (minValue, maxValue) = getMinMaxValue(minValue: Double.greatestFiniteMagnitude, maxValue: Double.leastNormalMagnitude, array: arrayFirstYear)
        (minValue, maxValue) = getMinMaxValue(minValue: minValue, maxValue: maxValue, array: arraySecondYear)
        
        // take 10 % of the min value to note diference between no values and the actual min value
        if minValue == Double.greatestFiniteMagnitude {
            //means that there is nothing to draw
            minValue = 0
            maxValue = 0
        } else {
            // scalle is better if starts always from zero
            minValue = 0
        }
        
        if arrayFirstYear.isEmpty {
            arrayOfDataFirst = Array(repeating: minValue, count: 12)
        } else {
            arrayOfDataFirst = getArrayOfDataFromSelectedComponent(array: arrayFirstYear, minValue: minValue)
        }
        
        if arraySecondYear.isEmpty {
            arrayOfDataSecond = Array(repeating: minValue, count: 12)
        } else {
            arrayOfDataSecond = getArrayOfDataFromSelectedComponent(array: arraySecondYear, minValue: minValue)
        }
        
        
        //array that handles the data
        arrayOfCrimeaRoseData = [CrimeaRoseData]()
        
        arrayOfCrimeaRoseData.append(CrimeaRoseData(arrayOfData: arrayOfDataFirst, color: firstUIColor))
        arrayOfCrimeaRoseData.append(CrimeaRoseData(arrayOfData: arrayOfDataSecond, color: secondUIColor))
        
        
        crimeaRoseView.drawRose(arrayOfCrimeaRoseData: arrayOfCrimeaRoseData, arrayOfLabels: getArrayOfLabels(), maxValue: maxValue, minValue: minValue)
        
    }
    
    
    /// returns an array based on the component selected in the segmentedControl
    private func getArrayOfDataFromSelectedComponent(array: [DataModel], minValue:Double)->[Double]{
        var arrayOfData = [Double]()
        
        for obj in array {
            if obj.isNull {
                arrayOfData.append(minValue)
            } else {
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
        }
        
        return arrayOfData
    }
    
    private func getMinMaxValue(minValue: Double, maxValue: Double, array: [DataModel]) -> (Double, Double) {
        var min = minValue
        var max = maxValue
        for obj in array {
            if !obj.isNull {
                switch segmentedControl.selectedSegmentIndex {
                case 0:
                    if min > obj.temperature{
                        min = obj.temperature
                    }
                    if max < obj.temperature{
                        max = obj.temperature
                    }
                    break
                case 1:
                    if min > obj.depth{
                        min = obj.depth
                    }
                    if max < obj.depth{
                        max = obj.depth
                    }
                    break
                case 2:
                    if min > obj.pressure{
                        min = obj.pressure
                    }
                    if max < obj.pressure{
                        max = obj.pressure
                    }
                    break
                case 3:
                    if min > obj.turbidity{
                        min = obj.turbidity
                    }
                    if max < obj.turbidity{
                        max = obj.turbidity
                    }
                    break
                case 4:
                    if min > obj.ph{
                        min = obj.ph
                    }
                    if max < obj.ph{
                        max = obj.ph
                    }
                    break
                case 5:
                    if min > obj.oxygen{
                        min = obj.oxygen
                    }
                    if max < obj.oxygen{
                        max = obj.oxygen
                    }
                    break
                default:
                    fatalError("segmented control index error in CrimeaRoseViewController")
                }
            }
        }
        return (min,max)
    }
    
    /// returns an array of the labels for the selected data
    private func getArrayOfLabels() -> [String]{
        var arrayOfLabels = [String]()
        
        switch dateTypePicker.selectedRow(inComponent: 0) {
            case 0: //Day
                for i in 1...24 {
                    arrayOfLabels.append(String(i))
                }
                break
            case 1: //Week
                for i in 0..<7 {
                    arrayOfLabels.append(Calendar.current.shortWeekdaySymbols[i])
                }
                break
            case 2: //Month
                var range = Calendar.current.range(of: .day, in: .month, for: firstDateToCompare)!
                var numDays = range.count
                
                range = Calendar.current.range(of: .day, in: .month, for: secondDateToCompare)!
                if numDays < range.count {
                    numDays = range.count
                }
                for i in 1...numDays {
                    arrayOfLabels.append(String(i))
                }
                break
            case 3: //Year
                for i in 0..<12 {
                    arrayOfLabels.append(Calendar.current.shortMonthSymbols[i])
                }
                break
            default:
                fatalError("pickerView in crimeaRose have more items then expected")
        }
        arrayLabels = arrayOfLabels
        return arrayOfLabels
    }
    
    /// updates the rose by checking what is selected in the dateTypePicker
    private func updateRose(){
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
    
    /// updates the labels and all the other components
    private func updateLabels(){
        switch dateTypePicker.selectedRow(inComponent: 0) {
        case 0: //Day
            leftDateLabel.text = "\(firstDateToCompare.toString(withFormat: "dd MMM yyyy"))"
            rightDateLabel.text = "\(secondDateToCompare.toString(withFormat: "dd MMM yyyy"))"
            break
        case 1: //Week
            leftDateLabel.text = "\(firstDateToCompare.startOfWeek!.toString(withFormat: "dd/MMM")) - \(firstDateToCompare.endOfWeek!.toString(withFormat: "dd/MMM"))"
            rightDateLabel.text = "\(secondDateToCompare.startOfWeek!.toString(withFormat: "dd/MMM")) - \(secondDateToCompare.endOfWeek!.toString(withFormat: "dd/MMM"))"
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
        updateRose()
        
        if indexTouched != -1 {
            blueLabel.text = String(format: "%.02f \(getEndOfStringForDataType())", arrayOfCrimeaRoseData[0].arrayOfData[indexTouched])
            yellowLabel.text = String(format: "%.02f \(getEndOfStringForDataType())", arrayOfCrimeaRoseData[1].arrayOfData[indexTouched])
        }

    }
    
    
    //------------------- Handling touch events
    ///recognizer for the tap on a view
    @objc func didTap(tapGR: UITapGestureRecognizer){
        switch tapGR.state {
        case .ended:
            for subview in crimeaRoseView.subviews {
                if subview.frame.contains(tapGR.location(in: crimeaRoseView)) {
                    if subview is UILabel {
                        blueLabel.text = ""
                        yellowLabel.text = ""
                    }
                }
            }
            
            
            let index = crimeaRoseView.checkTap(point: tapGR.location(in: crimeaRoseView))
            if(index != -1){
                indexTouched = index
                blueLabel.text = String(format: "%.02f \(getEndOfStringForDataType())", arrayOfCrimeaRoseData[0].arrayOfData[index])
                yellowLabel.text = String(format: "%.02f \(getEndOfStringForDataType())", arrayOfCrimeaRoseData[1].arrayOfData[index])
            }
        default:
            break
        }
    }
    
    ///returns the end symbol for the type of data selected
    private func getEndOfStringForDataType() -> String{
        switch segmentedControl.selectedSegmentIndex {
            case 0:
                return "°C"
            case 1:
                return "m"
            case 2:
                return "bar"
            case 3:
                return ""
            case 4:
                return "pH"
            case 5:
                return "mg/L"
            default:
                fatalError("segmented control index error in CrimeaRoseViewController")
            }
    }
    
    
    //--------------Handles changes
    ///handles the change on the segmented control, basicly only needs to check which dateTypePicker is selected and call the respective method
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        updateLabels()
    }
    
    @IBAction func firstDateButtonTouched(_ sender: UIButton) {
        DatePickerDialog().show( "Pick a Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: firstDateToCompare ,datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                self.firstDateToCompare = dt
                self.updateLabels()
            }
        }
    }
    
    @IBAction func secondDateButtonTouched(_ sender: UIButton) {
        DatePickerDialog().show( "Pick a Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: secondDateToCompare, datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                self.secondDateToCompare = dt
                self.updateLabels()
            }
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
    
    /// Handles the selection of a new row
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        ///remove label because of possible crash index out of range
        indexTouched = -1
        blueLabel.text = ""
        yellowLabel.text = ""
        
        updateLabels()
    }
}
