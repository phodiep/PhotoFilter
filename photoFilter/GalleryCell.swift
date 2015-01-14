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
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
