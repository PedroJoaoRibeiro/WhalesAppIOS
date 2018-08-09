//
//  PopupCell.swift
//  WhalesAppIOS
//
//  Created by Pedro Ribeiro on 07/08/2018.
//  Copyright © 2018 Pedro Ribeiro. All rights reserved.
//

import UIKit

class PopupCell: UICollectionViewCell {
    
    var cellInfo: CellInfo? {
        didSet {
            textLabel.text = cellInfo?.text
            iconImageView.image = UIImage(named: (cellInfo?.iconName)!) 
        }
    }
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.text = "ups"
        return label
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "play_button")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        addSubview(textLabel)
        addSubview(iconImageView)
        
        addConstraintsWithFormat(format: "H:|-10-[v0(30)]-10-[v1]|", views: iconImageView, textLabel)
        addConstraintsWithFormat(format: "V:|[v0]|", views: textLabel)
        addConstraintsWithFormat(format: "V:|[v0(30)]", views: iconImageView)
        
        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .centerY , relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
}
