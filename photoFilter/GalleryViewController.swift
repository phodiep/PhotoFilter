//
//  GalleryViewController.swift
//  photoFilter
//
//  Created by Pho Diep on 1/12/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var collectionView: UICollectionView!
    var imageGallery = [UIImage]()
    let mainScreenFrame = UIScreen.mainScreen().bounds
    
    override func loadView() {
        let rootView = UIView(frame: mainScreenFrame)
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        
        self.collectionView = UICollectionView(frame: mainScreenFrame, collectionViewLayout: collectionViewFlowLayout)
        collectionViewFlowLayout.itemSize = CGSize(width: 100, height: 100)
        
        rootView.addSubview(self.collectionView)

        self.view = rootView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Gallery"
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.collectionView.registerClass(ThumbnailCell.self, forCellWithReuseIdentifier: "GALLERY_CELL")
        
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
        
        self.imageGallery.append(image1!)
        self.imageGallery.append(image2!)
        self.imageGallery.append(image3!)
        self.imageGallery.append(image4!)
        self.imageGallery.append(image5!)
        self.imageGallery.append(image6!)
        self.imageGallery.append(image7!)
        self.imageGallery.append(image8!)
        self.imageGallery.append(image9!)
        self.imageGallery.append(image10!)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageGallery.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("GALLERY_CELL", forIndexPath: indexPath) as ThumbnailCell
        
        let image = self.imageGallery[indexPath.row] as UIImage
        cell.imageView.image = image
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let homeVC = HomeViewController()

        let image = self.imageGallery[indexPath.row] as UIImage

        homeVC.imageView.image = image
        
        self.navigationController?.pushViewController(homeVC, animated: true)

    }
    

}
