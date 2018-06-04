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
    

    
    @IBOutlet weak var chtChart: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        drawLineChart(propertyToDraw: "temperature")
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func drawLineChart(propertyToDraw: String){
        //connects to the database to get the data
        let db = DbConnection()
        let arrayOfData = db.getDataFromDb()
        print(arrayOfData)
        
        setChartOptions();
        
        // checks if there is data to show if not don't do anything
        guard arrayOfData.count > 0 else {
            print("There is no Data on Database")
            return
        }
        
        var lineChartEntry = [ChartDataEntry]()
        
        for json in arrayOfData {
            let date = json.date
            let value = ChartDataEntry(x: Double(date.timeIntervalSince1970), y: json.temperature)
            lineChartEntry.append(value)
        }
        
        let line1 = LineChartDataSet(values: lineChartEntry, label: propertyToDraw)
        line1.colors = [NSUIColor.blue]
        
        let data = LineChartData()
        data.addDataSet(line1)
        
        chtChart.data = data
    }
    
    private func setChartOptions(){
        //blocks zoom on Y axis
        chtChart.scaleYEnabled = false
        
        // calls the dateFormater to convert from interval to (dd MMM)
        chtChart.xAxis.valueFormatter = DateValueFormatter()
    }
    
}

