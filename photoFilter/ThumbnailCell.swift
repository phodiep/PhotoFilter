//
//  ThumbnailCell.swift
//  photoFilter
//
//  Created by Pho Diep on 1/12/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

import UIKit

class ThumbnailCell: UICollectionViewCell {
    
    var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.imageView)
        
        self.backgroundColor = UIColor.blueColor()
        self.imageView.frame = self.bounds
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
