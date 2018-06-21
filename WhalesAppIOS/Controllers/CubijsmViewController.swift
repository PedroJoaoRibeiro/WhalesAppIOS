//
//  CubijsmViewController.swift
//  WhalesAppIOS
//
//  Created by Pedro Ribeiro on 29/05/2018.
//  Copyright © 2018 Pedro Ribeiro. All rights reserved.
//

import UIKit
import Charts

class CubijsmViewController: UIViewController {
    
    @IBOutlet weak var cubiChartView: LineChartView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    private var currentDate = Date()
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        
//        let db = DbConnection()
//        let array = db.getDataFromDb()
//        var date = DateFormatter().stringToDate(str: "2017-12-23T06:00:00Z")!
//
//        for i in array {
//            if db.updateDates(id: i.id, newDate: date) {
//                date = Calendar.current.date(byAdding: .hour, value: 6, to: date)!
//            } else {
//                print("here")
//            }
//        }
//
//        print(db.getDataFromDb())
        
        updateLabel()
        setChartOptions()
        drawCubicChartDay()
        
    }
    
    // Actions
    
    @IBAction func segmentedControllChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            drawCubicChartDay()
            break
        case 1:
            drawCubicChartWeek()
        case 2:
            drawCubicChartMonth()
        case 3:
            drawCubicChartYear()
        default:
            break
        }
        updateLabel()
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        let calendar = Calendar.current
        switch segmentedControl.selectedSegmentIndex {
        case 0: //subtract a day in the currentDate
            currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
            drawCubicChartDay()
            break
        case 1: //subtract a week in the currentDate
            currentDate = calendar.date(byAdding: .day, value: -7, to: currentDate)!
            drawCubicChartWeek()
            break
        case 2: //subtract a month in the currentDate
            currentDate = calendar.date(byAdding: .month, value: -1, to: currentDate)!
            drawCubicChartMonth()
            break
        case 3: //subtract a year in the currentDate
            currentDate = calendar.date(byAdding: .year, value: -1, to: currentDate)!
            drawCubicChartYear()
            break
        default:
            break
        }
        updateLabel()
    }
    
    
    @IBAction func forwardButtonPressed(_ sender: UIButton) {
        let calendar = Calendar.current
        switch segmentedControl.selectedSegmentIndex {
        case 0: //add a day in the currentDate
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
            drawCubicChartDay()
            break
        case 1: //add a week in the currentDate
            currentDate = calendar.date(byAdding: .day, value: 7, to: currentDate)!
            drawCubicChartWeek()
            break
        case 2: //add a month in the currentDate
            currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate)!
            drawCubicChartMonth()
            break
        case 3: //add a year in the currentDate
            currentDate = calendar.date(byAdding: .year, value: 1, to: currentDate)!
            drawCubicChartYear()
            break
        default:
            break
        }
        updateLabel()
    }
    
    // Date selection Methods
    
    private func getDateForDay() -> [DataModel] {
        //connects to the database to get the data
        let db = DbConnection()
        let arrayOfData = db.getDataFromDb()
        
        return arrayOfData.filter { Calendar.current.isDate($0.date, inSameDayAs: currentDate)}
    }
    
    private func getDateForWeek() -> [DataModel] {
        //connects to the database to get the data
        let db = DbConnection()
        let arrayOfData = db.getDataFromDb()
        
        return arrayOfData.filter { Calendar.current.isDate($0.date, equalTo: currentDate, toGranularity: .weekOfYear)}
    }
    
    private func getDateForMonth() -> [DataModel] {
        //connects to the database to get the data
        let db = DbConnection()
        var arrayOfData = db.getDataFromDb()
        
        arrayOfData = arrayOfData.filter { Calendar.current.isDate($0.date, equalTo: currentDate, toGranularity: .month)}
        
        // if there is no data just return nil
        if arrayOfData.isEmpty {
            return [DataModel]()
        }
        
        let dict = Dictionary(grouping: arrayOfData) {$0.date.day}
        
        var finalArray = [DataModel]()

        let range = Calendar.current.range(of: .day, in: .month, for: currentDate)!
        
        var component = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: currentDate)
        component.day = 1
        var d = Calendar.current.date(from: component)!
        
        for _ in 0..<range.count {
            let obj = DataModel()
            obj.date = d
            finalArray.append(obj)
            d = Calendar.current.date(byAdding: .day, value: 1, to: d)!
        }
        
        for (key, value) in dict {
            for v in value {
                finalArray[key-1].add(obj: v)
            }
            finalArray[key-1].divide(value: value.count)
        }
        return finalArray
    }
    
    private func getDateForYear() -> [DataModel] {
        //connects to the database to get the data
        let db = DbConnection()
        var arrayOfData = db.getDataFromDb()
        
        arrayOfData = arrayOfData.filter { Calendar.current.isDate($0.date, equalTo: currentDate, toGranularity: .year)}
        
        // if there is no data just return nil
        if arrayOfData.isEmpty {
            return [DataModel]()
        }
        
        let dict = Dictionary(grouping: arrayOfData) {$0.date.month}
        
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
    
    
    /// Updates the label of the current day
    private func updateLabel(){
        let calendar = Calendar.current
        switch segmentedControl.selectedSegmentIndex {
            case 0: // Day
                if calendar.isDateInToday(currentDate){
                    dateLabel.text = "Today"
                } else if calendar.isDateInYesterday(currentDate){
                    dateLabel.text = "Yesterday"
                } else {
                    dateLabel.text = currentDate.toString(withFormat: "dd/MM/yyyy")
                }
                break
            case 1: // Week
                let endOfWeek = currentDate.endOfWeek!
                dateLabel.text = currentDate.startOfWeek!.toString(withFormat: "dd/MM/") + " - " + endOfWeek.toString(withFormat: "dd/MM/yyyy")
                break
            case 2: // Month
                dateLabel.text = currentDate.toString(withFormat: "MM/yyyy")
            case 3: // Year
                dateLabel.text = currentDate.toString(withFormat: "yyyy")
                break
            default:
                break
            }
    }
    
    
    // Chart Methods
    
    private func drawCubicChartDay(){
    }
    
    private func drawCubicChartWeek(){
    }
    
    private func drawCubicChartMonth(){
        cubiChartView.data = nil
        
         let arrayOfData = getDateForMonth()
        
        // checks if there is data to show if not don't do anything
        guard arrayOfData.count > 0 else {
            print("There is no Data on Database for the current selected month")
            return
        }
        
        var lineChartEntry1 = [ChartDataEntry]()
        var lineChartEntry2 = [ChartDataEntry]()
        var lineChartEntry3 = [ChartDataEntry]()
        
        for obj in 0..<arrayOfData.count {
            let value1 = ChartDataEntry(x: Double(obj), y: arrayOfData[obj].temperature)
            let value2 = ChartDataEntry(x: Double(obj), y: arrayOfData[obj].depth)
            let value3 = ChartDataEntry(x: Double(obj), y: arrayOfData[obj].pressure)
            lineChartEntry1.append(value1)
            lineChartEntry2.append(value2)
            lineChartEntry3.append(value3)
        }
        
        
        let line1 = lineChartGenerator(lineChartEntry: lineChartEntry1, label: "temperature", color: [UIColor(red:0.91, green:0.28, blue:0.33, alpha:1.0)])
        
        let line2 = lineChartGenerator(lineChartEntry: lineChartEntry2, label: "depth", color: [UIColor(red:0.02, green:0.59, blue:1.00, alpha:1.0)])
        
        let line3 = lineChartGenerator(lineChartEntry: lineChartEntry3, label: "pressure", color: [UIColor(red:0.95, green:0.91, blue:0.31, alpha:1.0)])
        
        let data = LineChartData(dataSets: [ line1, line2, line3])
        
        //place this before data otherwise might get errors
        cubiChartView.xAxis.valueFormatter = MonthValueFormatter()
        
        cubiChartView.data = data
        
        //always place after adding the data
        cubiChartView.setVisibleXRange(minXRange: Double(arrayOfData.count/4), maxXRange: Double(arrayOfData.count))
        cubiChartView.moveViewToX(Double(arrayOfData.count/2))
    }
    
    
    private func drawCubicChartYear() {
        cubiChartView.data = nil
        
        let arrayOfData = getDateForYear()
        guard arrayOfData.count > 0 else {
            print("There is no Data on Database for the current selected year")
            return
        }
        
        var lineChartEntry1 = [ChartDataEntry]()
        var lineChartEntry2 = [ChartDataEntry]()
        var lineChartEntry3 = [ChartDataEntry]()
        
        for obj in arrayOfData {
            let value1 = ChartDataEntry(x: Double(obj.date.month), y: obj.temperature)
            let value2 = ChartDataEntry(x: Double(obj.date.month), y: obj.depth)
            let value3 = ChartDataEntry(x: Double(obj.date.month), y: obj.pressure)
            lineChartEntry1.append(value1)
            lineChartEntry2.append(value2)
            lineChartEntry3.append(value3)
        }
        
        
        let line1 = lineChartGenerator(lineChartEntry: lineChartEntry1, label: "temperature", color: [UIColor(red:0.91, green:0.28, blue:0.33, alpha:1.0)])
        
        let line2 = lineChartGenerator(lineChartEntry: lineChartEntry2, label: "depth", color: [UIColor(red:0.02, green:0.59, blue:1.00, alpha:1.0)])
        
        let line3 = lineChartGenerator(lineChartEntry: lineChartEntry3, label: "pressure", color: [UIColor(red:0.95, green:0.91, blue:0.31, alpha:1.0)])
        
        
        let data = LineChartData(dataSets: [ line1, line2, line3])
        
        //place this before data otherwise might get errors
        cubiChartView.xAxis.valueFormatter = YearValueFormatter()
        
        cubiChartView.data = data
        
        //always place after adding the data
        cubiChartView.setVisibleXRange(minXRange: Double(arrayOfData.count/4), maxXRange: Double(arrayOfData.count))
        cubiChartView.moveViewToX(Double(arrayOfData.count/2))
    }
    
    ///generates the line to then add to the graph
    private func lineChartGenerator(lineChartEntry: [ChartDataEntry], label: String, color: [UIColor]) -> LineChartDataSet{
        
        let line = LineChartDataSet(values: lineChartEntry, label: label)
        line.colors = color
        
        line.mode = .horizontalBezier
        line.drawCirclesEnabled = false
        line.lineWidth = 1.8
        line.circleRadius = 4
        line.setCircleColor(.white)
        line.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
        
        line.drawFilledEnabled = true
        line.fillColor = color[0]
        
        line.drawHorizontalHighlightIndicatorEnabled = false
        
        // sets an area filled bellow the graph changed to zero to avoid that
        line.fillFormatter = CubicLineSampleFillFormatter()
        
        return line
    }
    
    
    ///sets some standard options to the graph just called once at the start
    private func setChartOptions(){
        cubiChartView.chartDescription?.enabled = false
        
        //disables x grid
        cubiChartView.xAxis.drawGridLinesEnabled = false
        
        //blocks zoom on Y axis
        cubiChartView.scaleYEnabled = false
        
        //animation
        cubiChartView.animate(xAxisDuration: 1)
        
        // xAxis defenitions
        let xAxis = cubiChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.granularity = 1
    }
    
}

private class CubicLineSampleFillFormatter: IFillFormatter {
    func getFillLinePosition(dataSet: ILineChartDataSet, dataProvider: LineChartDataProvider) -> CGFloat {
        return 0
    }
}
