//
//  ViewController.swift
//  WhalesAppIOS
//
//  Created by Pedro Ribeiro on 04/05/2018.
//  Copyright © 2018 Pedro Ribeiro. All rights reserved.
//

import UIKit
import RealmSwift

class MainScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        ConnectionToServer().sendDataToServer()
        ConnectionToServer().getDataFromServer()
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func connectToDevice(_ sender: UIButton) {
        print("button touched")
        ConnectionToDevice().getData(i: 0)
        //ConnectionToDevice().getWavFile(fileName: "")
    }
}

