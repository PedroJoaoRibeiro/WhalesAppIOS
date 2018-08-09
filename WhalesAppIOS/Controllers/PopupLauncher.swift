//
//  PopupLauncher.swift
//  WhalesAppIOS
//
//  Created by Pedro Ribeiro on 06/08/2018.
//  Copyright © 2018 Pedro Ribeiro. All rights reserved.
//

import UIKit

class PopupLauncher: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let blackView = UIView()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        cv.backgroundColor = UIColor(red: 239, green: 239, blue: 244, alpha: 1)
        return cv
    }()
    
    let cellId = "cellId"
    
    var arrayCells: [CellInfo] = {
        return [CellInfo(iconName: "play_button", text: "ja foi")]
    }()
    
    override init(){
        super.init()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(PopupCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    
    /// launches all the popup and background
    func handleBottomPopup(model: DataModel){
        if let window = UIApplication.shared.keyWindow {
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            window.addSubview(blackView)
            window.addSubview(collectionView)
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            let height: CGFloat = 200
            let y = window.frame.height - height
            
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.blackView.alpha = 1
                    self.collectionView.frame = CGRect(x: 0, y: y, width: window.frame.width, height: height)
                    }, completion: nil)
            
            
            arrayCells.removeAll()
            arrayCells.append(CellInfo(iconName: "date", text: model.date.toString(withFormat: "yyyy-MM-dd HH:mm")))
            
            arrayCells.append(CellInfo(iconName: "gps", text: String(format: "Lat: %.04f, Long: %.04f", model.latitude, model.longitude)))
            
            arrayCells.append(CellInfo(iconName: "play_button", text: String(model.temperature)))
        }
        
    }
    
    ///handles the dismiss of the popup
    @objc func handleDismiss(){
        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
        })
    }
    
    
    //Collection View methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayCells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PopupCell
        
        cell.cellInfo = arrayCells[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width , height: 50)
    }
}

class CellInfo {
    let iconName: String
    let text: String
    
    init(iconName: String, text: String) {
        self.iconName = iconName
        self.text = text
    }
}
