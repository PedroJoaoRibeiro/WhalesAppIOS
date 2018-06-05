//
//  PopUpView.swift
//  WhalesAppIOS
//
//  Created by Pedro Ribeiro on 05/06/2018.
//  Copyright © 2018 Pedro Ribeiro. All rights reserved.
//

import Foundation
import UIKit

class PopUpView: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("cheguei")
    }
    
    
    public func hideView(){
        self.isHidden = true
    }
    
    public func showView(){
        self.isHidden = false
    }
}
