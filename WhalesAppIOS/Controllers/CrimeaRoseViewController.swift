//
//  CrimeaRoseViewController.swift
//  WhalesAppIOS
//
//  Created by Pedro Ribeiro on 29/05/2018.
//  Copyright © 2018 Pedro Ribeiro. All rights reserved.
//


import UIKit

class CrimeaRoseViewController: UIViewController {

    @IBOutlet weak var crimeaRoseView: CrimeaRoseView!
    
    private var currentDate = Date()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let array = getDateForYear()
        
        var arrayOfData = [Double]()
        var arrayOfLabels = [String]()
        
        var incre = -26.0
        for i in 0..<array.count {
            arrayOfData.append(incre)
            arrayOfLabels.append(Calendar.current.shortMonthSymbols[i])
            incre += 10
        }
        
        var arrayOfCrimeaRoseData = [CrimeaRoseData]()
        arrayOfCrimeaRoseData.append(CrimeaRoseData(arrayOfData: arrayOfData, color: UIColor(red:0.91, green:0.28, blue:0.33, alpha:1.0)))
        
        incre = -26.0
        arrayOfData = [Double]()
        for _ in 0..<array.count {
            arrayOfData.append(incre)
            incre += 5
        }
        arrayOfCrimeaRoseData.append(CrimeaRoseData(arrayOfData: arrayOfData, color: UIColor(red:0.02, green:0.59, blue:1.00, alpha:1.0)))
        
        
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
    
    
}
