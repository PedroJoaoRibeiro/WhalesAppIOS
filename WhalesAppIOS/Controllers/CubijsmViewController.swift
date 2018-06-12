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
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        drawCubicChart()
    }
    
    private func drawCubicChart(){
        //connects to the database to get the data
        let db = DbConnection()
        let arrayOfData = db.getDataFromDb()
        
        setChartOptions();
        
        // checks if there is data to show if not don't do anything
        guard arrayOfData.count > 0 else {
            print("There is no Data on Database")
            return
        }
        
        var lineChartEntry1 = [ChartDataEntry]()
        var lineChartEntry2 = [ChartDataEntry]()
        var lineChartEntry3 = [ChartDataEntry]()
        
        for obj in arrayOfData {
            let value1 = ChartDataEntry(x: Double(obj.date.timeIntervalSince1970), y: obj.temperature)
            let value2 = ChartDataEntry(x: Double(obj.date.timeIntervalSince1970), y: obj.depth)
            let value3 = ChartDataEntry(x: Double(obj.date.timeIntervalSince1970), y: obj.pressure)
            lineChartEntry1.append(value1)
            lineChartEntry2.append(value2)
            lineChartEntry3.append(value3)
        }
        
        
        let line1 = lineChartGenerator(lineChartEntry: lineChartEntry1, label: "temperature", color: [UIColor(red:0.91, green:0.28, blue:0.33, alpha:1.0)])
        
        let line2 = lineChartGenerator(lineChartEntry: lineChartEntry2, label: "depth", color: [UIColor(red:0.02, green:0.59, blue:1.00, alpha:1.0)])
        
        let line3 = lineChartGenerator(lineChartEntry: lineChartEntry3, label: "pressure", color: [UIColor(red:0.95, green:0.91, blue:0.31, alpha:1.0)])
        
        
        let data = LineChartData(dataSets: [ line1, line2, line3])
        
        cubiChartView.data = data
        
        cubiChartView.setVisibleXRange(minXRange: 20, maxXRange: 150)
    }
    
    private func lineChartGenerator(lineChartEntry: [ChartDataEntry], label: String, color: [UIColor]) -> LineChartDataSet{
        
        let line = LineChartDataSet(values: lineChartEntry, label: label)
        line.colors = color
        
        line.mode = .cubicBezier
        line.drawCirclesEnabled = false
        line.lineWidth = 1.8
        line.circleRadius = 4
        line.setCircleColor(.white)
        line.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
        
        line.drawFilledEnabled = true
        line.fillColor = color[0]
        
        line.drawHorizontalHighlightIndicatorEnabled = false
        
        line.fillFormatter = CubicLineSampleFillFormatter()
        
        return line
    }
    
    private func setChartOptions(){
        cubiChartView.chartDescription?.enabled = false
        
        //disables x grid
        cubiChartView.xAxis.drawGridLinesEnabled = false
        
        //blocks zoom on Y axis
        cubiChartView.scaleYEnabled = false
        
        // calls the dateFormater to convert from interval to (dd MMM)
        cubiChartView.xAxis.valueFormatter = DateValueFormatter()
        
        
        cubiChartView.animate(xAxisDuration: 1)
    }
}

private class CubicLineSampleFillFormatter: IFillFormatter {
    func getFillLinePosition(dataSet: ILineChartDataSet, dataProvider: LineChartDataProvider) -> CGFloat {
        return -10
    }
}
