//
//  PhotoViewController.swift
//  photoFilter
//
//  Created by Pho Diep on 1/14/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

import UIKit
import Photos

class PhotoViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var assetFetchResults: PHFetchResult!
    var assetCollection: PHAssetCollection!
    let imageManager = PHCachingImageManager()
    
    var destinationSize: CGSize!
    
    var delegate: ImageSelectedProtocol?

    var collectionView: UICollectionView!
    var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    //MARK: ViewController LifeCycle
    
    override func loadView() {
        let rootView = UIView(frame: UIScreen.mainScreen().bounds)
        self.collectionView = UICollectionView(frame: rootView.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        self.collectionViewFlowLayout = self.collectionView.collectionViewLayout as UICollectionViewFlowLayout
        self.collectionViewFlowLayout.itemSize = CGSize(width: 100, height: 100)
        
        self.collectionView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        rootView.addSubview(self.collectionView)
        
        self.view = rootView

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("Photo", comment: "Photo View title")
        self.view.backgroundColor = UIColor.blackColor()

        self.assetFetchResults = PHAsset.fetchAssetsWithOptions(nil)
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.collectionView.registerClass(GalleryCell.self, forCellWithReuseIdentifier: "PHOTO_CELL")
        
        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: "collectionViewPinched:")
        self.collectionView.addGestureRecognizer(pinchRecognizer)


    }
    
    //MARK: Gesture Recognizer Actions
    func collectionViewPinched(sender: UIPinchGestureRecognizer) {
        switch sender.state {
        case .Began:
            println("")
        case .Changed:
            println("")
        case .Ended:
            self.collectionView.performBatchUpdates({ () -> Void in
                let oldWidth = self.collectionViewFlowLayout.itemSize.width
                let oldHeight = self.collectionViewFlowLayout.itemSize.height
                if sender.velocity > 0 {
                    //zoom in
                    let newSize = CGSize(width: oldWidth * 1.5 , height: oldHeight * 1.5)
                    self.collectionViewFlowLayout.itemSize = newSize
                } else if sender.velocity < 0 {
                    //zoom out
                    let newSize = CGSize(width: oldWidth / 1.5 , height: oldHeight / 1.5)
                    self.collectionViewFlowLayout.itemSize = newSize
                }
                }, completion: { (completed) -> Void in
            })
            
        default:
            println("default")
        }
    }
    

    //MARK: UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.assetFetchResults.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PHOTO_CELL", forIndexPath: indexPath) as GalleryCell
        
        let asset = assetFetchResults[indexPath.row] as PHAsset
        self.imageManager.requestImageForAsset(asset, targetSize: CGSize(width: 100, height: 100), contentMode: .AspectFill, options: nil) { (image, info) -> Void in
            cell.imageView.image = image
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedAsset = assetFetchResults[indexPath.row] as PHAsset
        self.imageManager.requestImageForAsset(selectedAsset, targetSize: self.destinationSize, contentMode: .AspectFill, options: nil) { (image, info) -> Void in
            
            self.delegate?.controllerDidSelectImage(image)
            
            self.navigationController?.popViewControllerAnimated(true)
            
        }
    }

}
