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
    @IBOutlet weak var valueSelectedLabel: UILabel!
    @IBOutlet var switches: [UISwitch]!
    
    
    private var currentDate = Date()
    private var arrayOfData = [DataModel]()
    private var arrayOfColors = [[UIColor(red:0.91, green:0.28, blue:0.33, alpha:1.0)], [UIColor(red:0.02, green:0.59, blue:1.00, alpha:1.0)], [UIColor(red:0.95, green:0.91, blue:0.31, alpha:1.0)]]
    
    
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
        
        cubiChartView.delegate = self
        
        updateLabel()
        setChartOptions()
        drawCubicChartYear()
        
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
    
    ///handels the change of the switches -> calls the method to update the data
    @IBAction func switchChanged(_ sender: UISwitch) {
        var count = 0
        var lastSwitch: UISwitch?
        for swit in switches {
            if swit.isOn && swit != sender{
                count += 1
                lastSwitch = swit
            }
        }
        if count == 0 {
            sender.setOn(true, animated: false)
        }
        if count >= 3 {
            lastSwitch!.setOn(false, animated: true)
        }
        segmentedControllChanged(segmentedControl);
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
        cubiChartView.data = nil
        
        arrayOfData = DbConnection().getDateForDay(currentDate: currentDate)
        
        //prevent from drawing if there is no data
        guard arrayOfData.count > 0 else {
            cubiChartView.noDataText = "There is no data for the current selected day"
            return
        }
        
        let data = selectDataToDisplay(arrayOfData: arrayOfData)
        
        //place this before data otherwise might get errors
        cubiChartView.xAxis.valueFormatter = DayValueFormatter()
        
        cubiChartView.data = data
        
        //always place after adding the data
        cubiChartView.xAxis.axisMaximum = 23
        cubiChartView.xAxis.axisMinimum = 0
        cubiChartView.setVisibleXRange(minXRange: 0, maxXRange: 23)
    }
    
    private func drawCubicChartWeek(){
        cubiChartView.data = nil
        
        arrayOfData = DbConnection().getDateForWeek(currentDate: currentDate)
        
        //prevent from drawing if there is no data
        guard arrayOfData.count > 0 else {
            cubiChartView.noDataText = "There is no data for the current selected week"
            return
        }
        
        let data = selectDataToDisplay(arrayOfData: arrayOfData)
        
        //place this before data otherwise might get errors
        cubiChartView.xAxis.valueFormatter = WeekValueFormatter(initialWeekDate: currentDate.startOfWeek!)
        
        cubiChartView.data = data
        
        //always place after adding the data
        cubiChartView.xAxis.axisMaximum = 6
        cubiChartView.xAxis.axisMinimum = 0
        cubiChartView.setVisibleXRange(minXRange: 6, maxXRange: 7)
        
    }
    
    private func drawCubicChartMonth(){
        cubiChartView.data = nil
        
         arrayOfData = DbConnection().getDateForMonth(currentDate: currentDate)
        
        //prevent from drawing if there is no data
        guard arrayOfData.count > 0 else {
            cubiChartView.noDataText = "There is no data for the current selected month"
            return
        }
        
        let data = selectDataToDisplay(arrayOfData: arrayOfData)
        
        //place this before data otherwise might get errors
        cubiChartView.xAxis.valueFormatter = MonthValueFormatter()
        
        cubiChartView.data = data
        
        //always place after adding the data
        cubiChartView.xAxis.axisMinimum = 0
        cubiChartView.xAxis.axisMaximum = Double(currentDate.endOfMonth().day - 1)
        cubiChartView.setVisibleXRange(minXRange: 0, maxXRange: Double(currentDate.endOfMonth().day) - 1)
        
    }
    
    
    private func drawCubicChartYear() {
        cubiChartView.data = nil
        
        arrayOfData = DbConnection().getDateForYear(currentDate: currentDate)
        
        // prevent from drawing if there is no data
        guard arrayOfData.count > 0 else {
            cubiChartView.noDataText = "There is no data for the current selected year"
            return
        }
 
        let data = selectDataToDisplay(arrayOfData: arrayOfData)
        
        //place this before data otherwise might get errors
        cubiChartView.xAxis.valueFormatter = YearValueFormatter()
        
        cubiChartView.data = data
        
        //always place after adding the data
        cubiChartView.xAxis.axisMaximum = 11
        cubiChartView.xAxis.axisMinimum = 0
        
       
    }
    
    private func selectDataToDisplay(arrayOfData: [DataModel]) -> LineChartData{
        var count = 0
        let data = LineChartData()
        for swit in switches {
            if(swit.accessibilityIdentifier! == "temperature"){
                if(swit.isOn){
                    var lineChartEntry = [ChartDataEntry]()
                    for obj in arrayOfData {
                        let value1 = ChartDataEntry(x: convertDateToXBasedOnType(date: obj.date), y: obj.temperature)
                        lineChartEntry.append(value1)
                    }
                    let line = lineChartGenerator(lineChartEntry: lineChartEntry, label: "temperature", color: arrayOfColors[count])
                    count += 1
                    data.addDataSet(line)
                }
            }
            if(swit.accessibilityIdentifier! == "depth"){
                if(swit.isOn){
                    var lineChartEntry = [ChartDataEntry]()
                    for obj in arrayOfData {
                        let value1 = ChartDataEntry(x: convertDateToXBasedOnType(date: obj.date), y: obj.depth)
                        lineChartEntry.append(value1)
                    }
                    let line = lineChartGenerator(lineChartEntry: lineChartEntry, label: "depth", color: arrayOfColors[count])
                    count += 1
                    data.addDataSet(line)
                }
            }
            if(swit.accessibilityIdentifier! == "pressure"){
                if(swit.isOn){
                    var lineChartEntry = [ChartDataEntry]()
                    for obj in arrayOfData {
                        let value1 = ChartDataEntry(x: convertDateToXBasedOnType(date: obj.date), y: obj.pressure)
                        lineChartEntry.append(value1)
                    }
                    let line = lineChartGenerator(lineChartEntry: lineChartEntry, label: "pressure", color: arrayOfColors[count])
                    count += 1
                    data.addDataSet(line)
                }
            }
            if(swit.accessibilityIdentifier! == "turbidity"){
                if(swit.isOn){
                    var lineChartEntry = [ChartDataEntry]()
                    for obj in arrayOfData {
                        let value1 = ChartDataEntry(x: convertDateToXBasedOnType(date: obj.date), y: obj.turbidity)
                        lineChartEntry.append(value1)
                    }
                    let line = lineChartGenerator(lineChartEntry: lineChartEntry, label: "turbidity", color: arrayOfColors[count])
                    count += 1
                    data.addDataSet(line)
                }
            }
            if(swit.accessibilityIdentifier! == "ph"){
                if(swit.isOn){
                    var lineChartEntry = [ChartDataEntry]()
                    for obj in arrayOfData {
                        let value1 = ChartDataEntry(x: convertDateToXBasedOnType(date: obj.date), y: obj.ph)
                        lineChartEntry.append(value1)
                    }
                    let line = lineChartGenerator(lineChartEntry: lineChartEntry, label: "ph", color: arrayOfColors[count])
                    count += 1
                    data.addDataSet(line)
                }
            }
            if(swit.accessibilityIdentifier! == "oxygen"){
                if(swit.isOn){
                    var lineChartEntry = [ChartDataEntry]()
                    for obj in arrayOfData {
                        let value1 = ChartDataEntry(x: convertDateToXBasedOnType(date: obj.date), y: obj.oxygen)
                        lineChartEntry.append(value1)
                    }
                    let line = lineChartGenerator(lineChartEntry: lineChartEntry, label: "oxygen", color: arrayOfColors[count])
                    count += 1
                    data.addDataSet(line)
                }
            }
        }
        
        return data;
    }
    
    private func convertDateToXBasedOnType(date: Date) -> Double{
        switch segmentedControl.selectedSegmentIndex {
        case 0: // Day
            return Double(date.hour)
        case 1: // Week
            return Double(date.weekDay - 1)
        case 2: // Month
            return Double(date.day - 1)
        case 3: // Year
            return Double(date.month - 1)
        default:
            return 0
        }
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
        
        let leftAxis = cubiChartView.leftAxis
        leftAxis.xOffset = 10
        
        let rightAxis = cubiChartView.rightAxis
        rightAxis.enabled = false
        
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


extension CubijsmViewController: ChartViewDelegate {
    
    /// shows the information for the selected item on the chart
    public func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            for obj in arrayOfData {
                if obj.date.hour == Int(entry.x) {
                    if obj.temperature == 0 && obj.pressure == 0 && obj.temperature == 0 {
                        valueSelectedLabel.text = ""
                    } else {
                    valueSelectedLabel.text = String(format: "Temperature: %.02f °C", obj.temperature) + "\n" + String(format: "Depth: %.02f m", obj.depth) + String(format: "\nPressure: %.02f bar", obj.pressure)
                    }
                }
            }
        } else {
            let obj = arrayOfData[Int(entry.x)]
            if obj.temperature == 0 && obj.pressure == 0 && obj.temperature == 0 {
                valueSelectedLabel.text = ""
            } else {
                valueSelectedLabel.text = String(format: "Average Temperature: %.02f °C", obj.temperature) + String(format: "\nAverage Depth: %.02f m", obj.depth) + String(format: "\nAverage Pressure: %.02f bar", obj.pressure)
            }
        }
    }
    
}
