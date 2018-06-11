//
//  DataDetailCustomCell.swift
//  WhalesAppIOS
//
//  Created by Pedro Ribeiro on 11/06/2018.
//  Copyright © 2018 Pedro Ribeiro. All rights reserved.
//

import UIKit

class DataDetailCustomCell: UITableViewCell {
    // outlets
    
    @IBOutlet weak var itemLabel: UILabel!
    // data
    var itemName: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureWithItem(item: String) {
        self.itemName = item
        self.itemLabel?.text = item
    }
}
