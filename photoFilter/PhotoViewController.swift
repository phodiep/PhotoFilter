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

    var delegate: ImageSelectedProtocol?

    var collectionView: UICollectionView!
    
    //MARK: ViewController LifeCycle
    
    override func loadView() {
        let rootView = UIView(frame: UIScreen.mainScreen().bounds)
        self.collectionView = UICollectionView(frame: rootView.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        let collectionViewFlowLayout = collectionView.collectionViewLayout as UICollectionViewFlowLayout
        collectionViewFlowLayout.itemSize = CGSize(width: 100, height: 100)
        
        collectionView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        rootView.addSubview(self.collectionView)
        
        self.view = rootView

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Photo"
        self.view.backgroundColor = UIColor.blackColor()

        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        
        self.collectionView.registerClass(GalleryCell.self, forCellWithReuseIdentifier: "PHOTO_CELL")
        

    }
    

    //MARK: UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PHOTO_CELL", forIndexPath: indexPath) as GalleryCell
        
        cell.backgroundColor = UIColor.redColor()
        //set cell image
        
        return cell
    }

}
