//
//  Images.swift
//  photoFilter
//
//  Created by Pho Diep on 1/13/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

import UIKit


func loadGalleryImages() -> [UIImage] {
    
    var imageGallery = [UIImage]()
    
    let image1 = UIImage(named: "image1.jpg")
    let image2 = UIImage(named: "image2.jpg")
    let image3 = UIImage(named: "image3.jpg")
    let image4 = UIImage(named: "image4.jpg")
    let image5 = UIImage(named: "image5.jpg")
    let image6 = UIImage(named: "image6.jpg")
    let image7 = UIImage(named: "image7.jpg")
    let image8 = UIImage(named: "image8.jpg")
    let image9 = UIImage(named: "image9.jpg")
    let image10 = UIImage(named: "image10.jpg")
    
    imageGallery.append(image1!)
    imageGallery.append(image2!)
    imageGallery.append(image3!)
    imageGallery.append(image4!)
    imageGallery.append(image5!)
    imageGallery.append(image6!)
    imageGallery.append(image7!)
    imageGallery.append(image8!)
    imageGallery.append(image9!)
    imageGallery.append(image10!)


    return imageGallery
}
