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

        self.filterLabel.textColor = UIColor.whiteColor()
        self.filterLabel.font = UIFont(name: filterLabel.font.fontName, size: 13)
        
        self.imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.filterLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.addSubview(self.imageView)
        self.addSubview(self.filterLabel)
        
        let views = ["imageView": self.imageView,
            "filterLabel" : self.filterLabel]

        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|[imageView]|",
            options: nil, metrics: nil, views: views))
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:[imageView][filterLabel]|",
            options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: views))
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}