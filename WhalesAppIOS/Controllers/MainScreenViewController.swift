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

    @IBOutlet weak var mainLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    private let refreshControl : UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        
        refreshControl.addTarget(self, action: #selector(refreshingScreen(_:)), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        scrollView.refreshControl = refreshControl
        
        ConnectionToServer().sendDataToServer()
        ConnectionToServer().getDataFromServer(completion: {
            self.setupLabel()
        })
        
        setupLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func connectToDevice(_ sender: UIButton) {
        print("button touched")
        ConnectionToDevice().getData(i: 0)
    }
    
    func setupLabel(){
        let data = DbConnection().getDataFromDb()
        
        mainLabel.numberOfLines = 0
        if data.count > 0 {
            mainLabel.text = "Start swiping to explore!"
        } else {
            mainLabel.text = "Currently there is no data to view\n\nPull to refresh"
        }
    }
    
    @objc func refreshingScreen(_ refreshControl: UIRefreshControl){
        print("here")
        
        ConnectionToServer().sendDataToServer()
        
        ConnectionToServer().getDataFromServer(completion: {
            self.setupLabel()
            self.refreshControl.endRefreshing()
        })
    }
}

