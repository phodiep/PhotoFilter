//
//  FilterCell.swift
//  photoFilter
//
//  Created by Pho Diep on 1/13/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

import UIKit

class FilterCell: UICollectionViewCell {
    
    var imageView = UIImageView()
    var filterLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.blackColor()

        self.filterLabel.frame = CGRect(x: 0, y: 100, width: 100, height: 20)
        self.filterLabel.textColor = UIColor.whiteColor()
        self.filterLabel.backgroundColor = UIColor.blackColor()
        self.filterLabel.font = UIFont(name: filterLabel.font.fontName, size: 10)
        
        self.imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.filterLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.addSubview(self.imageView)
        self.addSubview(self.filterLabel)
        
        let views = ["imageView": self.imageView,
            "filterLabel" : self.filterLabel]

        self.addConstraint(NSLayoutConstraint(
            item: views["filterLabel"] as UIView!, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal,
            toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0.0))

        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:[filterLabel]|",
            options: nil, metrics: nil, views: views))
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}