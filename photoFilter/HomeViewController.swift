//
//  HomeViewController.swift
//  photoFilter
//
//  Created by Pho Diep on 1/12/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, ImageSelectedProtocol, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let alertController = UIAlertController(title: "<Title>", message: "<message>", preferredStyle: .ActionSheet)

    var imageView = UIImageView()
    let photoButton = UIButton()
    var collectionView: UICollectionView!
    var collectionViewYConstraint: NSLayoutConstraint!
    
    let rootView = UIView()
    var views = [String : AnyObject]()
    
    var originalThumbnail: UIImage?
    var filterNames = [String]()
    let imageQueue = NSOperationQueue()
    var gpuContext: CIContext!
    var thumbnails = [Thumbnail]()
    
    var doneButton: UIBarButtonItem?
    var shareButton: UIBarButtonItem?

    //MARK: HomeViewController Lifecycle
    override func loadView() {
        self.rootView.frame = UIScreen.mainScreen().bounds
        self.rootView.backgroundColor = UIColor.blackColor()
        
        self.photoButton.setTitle("Photo", forState: .Normal)
        self.photoButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.photoButton.addTarget(self, action: "photoButtonPressed:", forControlEvents: .TouchUpInside)

        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        self.collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: collectionViewFlowLayout)
        collectionViewFlowLayout.itemSize = CGSize(width: 100, height: 100)
        collectionViewFlowLayout.minimumInteritemSpacing = 0.0
        collectionViewFlowLayout.scrollDirection = .Horizontal
        self.collectionView.backgroundColor = UIColor.blackColor()
        
        self.photoButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.collectionView.setTranslatesAutoresizingMaskIntoConstraints(false)

        self.rootView.addSubview(photoButton)
        self.rootView.addSubview(imageView)
        self.rootView.addSubview(collectionView)
        
        self.views = [
            "photoButton" : photoButton,
            "imageView" : imageView,
            "collectionView" : collectionView]
        
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupAutolayoutConstraints()
        
        self.title = "Home"
        
        self.doneButton = UIBarButtonItem(title: "Done", style: .Done, target: self, action: "doneButtonPressed")
        self.shareButton = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "shareButtonPressed")
        self.navigationItem.rightBarButtonItem = self.shareButton
        
        self.collectionView.dataSource = self
        self.collectionView.registerClass(FilterCell.self, forCellWithReuseIdentifier: "FILTER_CELL")
        
        let galleryOption = UIAlertAction(title: "Gallery", style: .Default) { (action) -> Void in
            let galleryVC = GalleryViewController()
            galleryVC.delegate = self
            self.navigationController?.pushViewController(galleryVC, animated: true)
        }

        let photoOption = UIAlertAction(title: "Photo", style: .Default) { (action) -> Void in
            let photoVC = PhotoViewController()
            photoVC.delegate = self
            photoVC.destinationSize = CGSize(width: 100, height: 100)
            self.navigationController?.pushViewController(photoVC, animated: true)
        }
        
        
        let filterOption = UIAlertAction(title: "Apply Filter", style: .Default) { (action) -> Void in
            //set new margin to show filter collectionView
            self.collectionViewYConstraint.constant = 8
                
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
            self.navigationItem.rightBarButtonItem = self.doneButton
        }
        
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let cameraOption = UIAlertAction(title: "Camera", style: .Default) { (action) -> Void in
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .Camera
                imagePickerController.allowsEditing = true
                imagePickerController.delegate = self
                self.presentViewController(imagePickerController, animated: true, completion: nil)
            }
            self.alertController.addAction(cameraOption)
        }
        
        self.alertController.addAction(galleryOption)
        self.alertController.addAction(photoOption)
        self.alertController.addAction(filterOption)
        
        setupGPU()
        setupThumbnails()
    }
    
    
    func setupGPU() {
        // setup GPU for use
        let options = [kCIContextOutputColorSpace : NSNull()]
        let eaglContext = EAGLContext(API: EAGLRenderingAPI.OpenGLES2)
        self.gpuContext = CIContext(EAGLContext: eaglContext, options: options)
    }

    func setupThumbnails() {
        self.filterNames = [
            "CISepiaTone",
            "CIPhotoEffectChrome",
            "CIPhotoEffectNoir",
            "CIVignette"]
        
        for name in self.filterNames {
            let thumbnail = Thumbnail(filterName: name, operationQueue: self.imageQueue, context: self.gpuContext)
            self.thumbnails.append(thumbnail)
        }
    }

    //MARK: UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.thumbnails.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("FILTER_CELL", forIndexPath: indexPath) as FilterCell
        let thumbnail = self.thumbnails[indexPath.row]
        if thumbnail.originalImage != nil {
            if thumbnail.filteredImage == nil {
                thumbnail.generateFilteredImage()
                cell.imageView.image = thumbnail.filteredImage!
                cell.filterLabel.text = self.filterNames[indexPath.row]
            }
        }

        return cell
    }
    
    //MARK: UIPickerControllerDelegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let image = info[UIImagePickerControllerEditedImage] as UIImage
        self.controllerDidSelectImage(image)
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //MARK: ImageSelectedDelegate
    func controllerDidSelectImage(image: UIImage) {
        self.imageView.image = image
        self.generateThumbnail(image)
        
        for thumbnail in self.thumbnails {
            thumbnail.originalImage = self.originalThumbnail    // reset original image
            thumbnail.filteredImage = nil                       //clear any cached thumbnail images
        }
        
        self.collectionView.reloadData()

    }
    
    func generateThumbnail(originalImage: UIImage) {
        //resize original image for thumbnail
        let imageWidth = 100
        let imageHeight = 100
        
        let size = CGSize(width: imageWidth, height: imageHeight)
        
        UIGraphicsBeginImageContext(size) //open
        originalImage.drawInRect(CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight))
        self.originalThumbnail = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()  //close to prevent memory leak
        
    }
    
    //MARK: Button actions
    func photoButtonPressed(sender: UIButton) {
        self.presentViewController(self.alertController, animated: true, completion: nil)
    }
    
    func shareButtonPressed() {
        println("share button pressed")
        
    }
    
    func doneButtonPressed() {
        println("done button pressed")
        
    }
    
    //MARK: Autolayout Constraints
    func setupAutolayoutConstraints() {

        self.rootView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-80-[imageView]-8-[photoButton]-8-|",
            options: nil, metrics: nil, views: self.views))
        self.rootView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-16-[imageView]-16-|",
            options: nil, metrics: nil, views: self.views))
        
        //center photoButton horizontally
        self.rootView.addConstraint(NSLayoutConstraint(
            item: views["photoButton"] as UIView!, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal,
            toItem: rootView, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        
        //animated collectionView layout
        self.rootView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|[collectionView]|",
            options: nil, metrics: nil, views: self.views))

        //save Y constraint to allow animation
        let collectionViewConstraintVeritcal = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:[collectionView(100)]-(-120)-|",
            options: nil, metrics: nil, views: self.views)
        self.collectionViewYConstraint = collectionViewConstraintVeritcal[1] as NSLayoutConstraint
        self.rootView.addConstraints(collectionViewConstraintVeritcal)

        

    }
    

}





