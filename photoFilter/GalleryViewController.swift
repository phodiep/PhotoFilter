//
//  GalleryViewController.swift
//  photoFilter
//
//  Created by Pho Diep on 1/12/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var delegate: ImageSelectedProtocol?
    
    var collectionView: UICollectionView!
    var imageGallery = [UIImage]()
    let collectionViewFlowLayout = UICollectionViewFlowLayout()
    let rootView = UIView()
    var views = [String : AnyObject]()
    
    override func loadView() {

        self.rootView.frame = UIScreen.mainScreen().bounds
        self.collectionView = UICollectionView(frame: UIScreen.mainScreen().bounds, collectionViewLayout: collectionViewFlowLayout)
        self.collectionViewFlowLayout.itemSize = CGSize(width: 100, height: 100)

        self.collectionView.setTranslatesAutoresizingMaskIntoConstraints(false)

        self.rootView.addSubview(self.collectionView)

        self.views = ["collectionView" : collectionView]
        
        self.view = rootView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupAutolayoutConstraints()
        
        self.title = "Gallery"
        self.view.backgroundColor = UIColor.blackColor()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self

        self.collectionView.registerClass(GalleryCell.self, forCellWithReuseIdentifier: "GALLERY_CELL")
        
        self.imageGallery = loadGalleryImages()
    }
        
    
    //MARK: UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageGallery.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("GALLERY_CELL", forIndexPath: indexPath) as GalleryCell
        let image = self.imageGallery[indexPath.row] as UIImage
        
        // fill cell with image and crop edges if necessary
        cell.imageView.contentMode = .ScaleAspectFill
        cell.imageView.layer.masksToBounds = true

        cell.imageView.image = image
        
        return cell
    }
    
    
    //MARK: UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.delegate?.controllerDidSelectImage(self.imageGallery[indexPath.row])
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK: Autolayout Constraints
    func setupAutolayoutConstraints() {
        self.rootView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-8-[collectionView]-8-|",
            options: nil, metrics: nil, views: views))
        self.rootView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-8-[collectionView]-8-|",
            options: nil, metrics: nil, views: views))

    }

}
