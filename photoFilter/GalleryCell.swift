//
//  GalleryCell.swift
//  photoFilter
//
//  Created by Pho Diep on 1/13/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

import UIKit

class GalleryCell: UICollectionViewCell {
    
    var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.imageView)
        
        self.backgroundColor = UIColor.blackColor()
        self.imageView.frame = self.bounds
        
        self.imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        let views = ["imageView" : self.imageView]
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|[imageView]|",
            options: nil, metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[imageView]|",
            options: nil, metrics: nil, views: views))

        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
