//
//  ExploreDataViewController.swift
//  WhalesAppIOS
//
//  Created by Pedro Ribeiro on 05/05/2018.
//  Copyright © 2018 Pedro Ribeiro. All rights reserved.
//

import Foundation
import UIKit
import Charts
import SwiftyJSON



class ExploreDataViewController: UIViewController {
    

    
    @IBOutlet weak var chartView: RadarChartView!
    
    let activities = ["Temperature", "Depth", "Pressure", "Turbidity", "Ph", "Oxygen"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //chartView.delegate = self
        drawRadarChart()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func drawRadarChart(){
        //connects to the database to get the data
        let db = DbConnection()
        let arrayOfData = db.getDataFromDb()
        //print(arrayOfData)
        
        setChartOptions();
        
        // checks if there is data to show if not don't do anything
        guard arrayOfData.count > 0 else {
            print("There is no Data on Database")
            return
        }
        
        var radarChartDataEntry1 = [RadarChartDataEntry]()
        
        let obj = arrayOfData[0]
            let temp = RadarChartDataEntry(value: obj.temperature)
            let depth = RadarChartDataEntry(value: obj.depth)
            let pressure = RadarChartDataEntry(value: obj.pressure)
            let turbidity = RadarChartDataEntry(value: obj.turbidity)
            let ph = RadarChartDataEntry(value: obj.ph)
            let oxygen = RadarChartDataEntry(value: obj.oxygen)
            radarChartDataEntry1.append(temp)
            radarChartDataEntry1.append(depth)
            radarChartDataEntry1.append(pressure)
            radarChartDataEntry1.append(turbidity)
            radarChartDataEntry1.append(ph)
            radarChartDataEntry1.append(oxygen)
        
        
        
        let line1 = radarChartLineGenerator(line: radarChartDataEntry1, label: "ups", color: [UIColor(red:0.91, green:0.28, blue:0.33, alpha:1.0)])
        
        
        let data = RadarChartData(dataSets: [line1])
        data.setValueFont(.systemFont(ofSize: 8, weight: .light))
        data.setDrawValues(false)
        data.setValueTextColor(.black)
        
        
        chartView.data = data
        
        // calls the dateFormater to convert from interval to (dd MMM)
        
        //chartView.xAxis.labelCount = 10
        //chtChart.setVisibleXRange(minXRange: 5, maxXRange: 20)
        //chartView.moveViewToX(5)
        
       //chtChart.xAxis.valueFormatter = YearValueFormatter()
    }
    
    private func setChartOptions(){
        //blocks zoom on Y axis
        //chartView.scaleYEnabled = false
        
        chartView.chartDescription?.enabled = false

        chartView.webLineWidth = 1
        chartView.innerWebLineWidth = 1
        chartView.webColor = .lightGray
        chartView.innerWebColor = .lightGray
        chartView.webAlpha = 1
        
        let xAxis = chartView.xAxis
        xAxis.labelFont = .systemFont(ofSize: 9, weight: .light)
        xAxis.xOffset = 0
        xAxis.yOffset = 0
        xAxis.valueFormatter = self
        xAxis.labelTextColor = .black
        
        let yAxis = chartView.yAxis
        yAxis.labelFont = .systemFont(ofSize: 9, weight: .light)
        yAxis.drawLabelsEnabled = false
        yAxis.axisMinimum = -100
        yAxis.axisMaximum = 100
        
        
    }
    
    ///generates the line to then add to the graph
    private func radarChartLineGenerator(line: [RadarChartDataEntry], label: String, color: [UIColor]) -> RadarChartDataSet{
        
        let line = RadarChartDataSet(values: line, label: label)
        line.colors = color
        
        //line.setColor(UIColor(red: 103/255, green: 110/255, blue: 129/255, alpha: 1))
        //line.fillColor = UIColor(red: 103/255, green: 110/255, blue: 129/255, alpha: 1)
        line.drawFilledEnabled = true
        line.fillAlpha = 0.7
        line.lineWidth = 2
        line.drawHighlightCircleEnabled = true
        line.setDrawHighlightIndicators(false)
        
        return line
    }
    
}

extension ExploreDataViewController: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return activities[Int(value) % activities.count]
    }
}

