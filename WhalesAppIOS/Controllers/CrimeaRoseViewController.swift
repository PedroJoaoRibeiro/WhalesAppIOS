//
//  CrimeaRoseViewController.swift
//  WhalesAppIOS
//
//  Created by Pedro Ribeiro on 29/05/2018.
//  Copyright © 2018 Pedro Ribeiro. All rights reserved.
//


import UIKit

class CrimeaRoseViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(DbConnection().checkIfObjectExists(id: "PhotonTest12018-05-21T13:16:02Z"))
        
        
    }
}
