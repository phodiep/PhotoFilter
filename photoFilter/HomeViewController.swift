//
//  HomeViewController.swift
//  photoFilter
//
//  Created by Pho Diep on 1/12/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

import UIKit
import Social

class HomeViewController: UIViewController, ImageSelectedProtocol, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let alertController = UIAlertController(
        title: NSLocalizedString("Title", comment: "title for aciton sheet"),
        message: NSLocalizedString("Select an option", comment: "message for aciton sheet"),
        preferredStyle: .ActionSheet)

    var imageView = UIImageView()
    let imageViewYFullView = 8 as CGFloat
    let imageViewYSmallerView = 108 as CGFloat
    var imageViewYConstraint: NSLayoutConstraint!
    
    var preFilterImage = UIImageView()
    var filterApplied = false
    
    var collectionView: UICollectionView!
    var collectionViewYConstraint: NSLayoutConstraint!
    let collectionViewYshow = 8 as CGFloat
    let collectionViewYhide = -120 as CGFloat
    
    let rootView = UIView()
    var views = [String : AnyObject]()
    var filterOption: UIAlertAction?
    
    var originalThumbnail: UIImage?
    var filterNames = [ [String] ]()
    let imageQueue = NSOperationQueue()
    var gpuContext: CIContext!
    var thumbnails = [Photo]()
    
    let photoButton = UIButton()
    var doneButton: UIBarButtonItem?
    var shareButton: UIBarButtonItem?
    var cancelFilterButton: UIBarButtonItem?


    //MARK: HomeViewController Lifecycle
    override func loadView() {
        self.rootView.frame = UIScreen.mainScreen().bounds
        self.rootView.backgroundColor = UIColor.blackColor()
        
        self.photoButton.setTitle(
            NSLocalizedString("Photo", comment: "aciton sheet Photo button"),
            forState: .Normal)
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
        
        self.title = NSLocalizedString("Home", comment: "Home View title")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self

        self.collectionView.registerClass(FilterCell.self, forCellWithReuseIdentifier: "FILTER_CELL")

        // fill imageView with image and crop edges if necessary
        self.imageView.contentMode = .ScaleAspectFill
        self.imageView.layer.masksToBounds = true

        // NavigationBar Items
        self.shareButton = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "shareButtonPressed")
        self.navigationItem.rightBarButtonItem = self.shareButton
        
        // NavigationBar Items (filter specific, will be shown when filter is activated)
        self.doneButton = UIBarButtonItem(title: "Done", style: .Done, target: self, action: "doneFilterButtonPressed")
        self.cancelFilterButton = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: "Cancel filter button"),
            style: .Done, target: self, action: "cancelFilterButtonPressed")

        
        self.setupAlertControllerItems()
        self.setupGPU()
        self.setupFilterThumbnails()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // enable Apply Filter button if image is selected
        if self.imageView.image != nil {
            self.filterOption!.enabled = true
        } else {
            self.filterOption!.enabled = false
        }
    }
    
    func setupAlertControllerItems() {
        
        // Gallery
        let galleryOption = UIAlertAction(title: NSLocalizedString("Gallery", comment: "aciton sheet GAllery button"),
            style: .Default) { (action) -> Void in
                let galleryVC = GalleryViewController()
                galleryVC.delegate = self
                self.navigationController?.pushViewController(galleryVC, animated: true)
        }
        
        // Photo
        let photoOption = UIAlertAction(title: "Photo", style: .Default) { (action) -> Void in
            let photoVC = PhotoViewController()
            photoVC.delegate = self
            photoVC.destinationSize = CGSize(width: 100, height: 100)
            self.navigationController?.pushViewController(photoVC, animated: true)
        }
        
        // Apply Filter
        self.filterOption = UIAlertAction(title: NSLocalizedString("Apply Filter", comment: "aciton sheet Apply Filter button"),
            style: .Default) { (action) -> Void in
                //set new margin to show filter collectionView on screen
                self.imageViewYConstraint.constant = self.imageViewYSmallerView
                self.collectionViewYConstraint.constant = self.collectionViewYshow
                
                //save original image to allow undo filtering
                self.preFilterImage.image = self.imageView.image
                
                //animate
                UIView.animateWithDuration(0.4, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                })
                
                //show filter specific navigation bar items
                self.navigationItem.rightBarButtonItem = self.doneButton
                self.navigationItem.leftBarButtonItem = self.cancelFilterButton
        }
        
        // Camera (will be shown if avaiable on device)
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let cameraOption = UIAlertAction(
                title: NSLocalizedString("Camera", comment: "aciton sheet Camera button"),
                style: .Default) { (action) -> Void in
                    let imagePickerController = UIImagePickerController()
                    imagePickerController.sourceType = .Camera
                    imagePickerController.allowsEditing = true
                    imagePickerController.delegate = self
                    self.presentViewController(imagePickerController, animated: true, completion: nil)
            }
            self.alertController.addAction(cameraOption)
        }
        
        // Cancel option
        let cancelOption = UIAlertAction(title: NSLocalizedString("Cancel", comment: "aciton sheet Cancel button"),
            style: .Cancel) { (action) -> Void in
                //close actionsheet
        }
        
        // add all actions to alertController
        self.alertController.addAction(galleryOption)
        self.alertController.addAction(photoOption)
        self.alertController.addAction(filterOption!)
        self.alertController.addAction(cancelOption)
    }
    
    func setupGPU() {
        // setup GPU for use
        let options = [kCIContextOutputColorSpace : NSNull()]
        let eaglContext = EAGLContext(API: EAGLRenderingAPI.OpenGLES2)
        self.gpuContext = CIContext(EAGLContext: eaglContext, options: options)
    }

    func setupFilterThumbnails() {
        self.filterNames = [
            ["CISepiaTone", "Sepia"],
            ["CIPhotoEffectChrome", "Chrome"],
            ["CIPhotoEffectNoir", "Noir"],
            ["CIPhotoEffectInstant", "Instant"],
            ["CIPhotoEffectFade", "Fade"],
            ["CIPhotoEffectTransfer", "Transfer"],
            ["CIPhotoEffectMono", "Mono"],
            ["CIPhotoEffectTonal", "Tonal"],
            ["CIPhotoEffectProcess", "Process"],
            ["CIDotScreen", "DotScreen"],
            ["CIHatchedScreen", "HatchedScreen"],
            ["CICircularScreen", "CircularScreen"]]
        
        for item in self.filterNames {
            let thumbnail = Photo(filterName: item[0], operationQueue: self.imageQueue, context: self.gpuContext)
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
            }
            cell.imageView.image = thumbnail.filteredImage!
            cell.filterLabel.text = self.filterNames[indexPath.row][1]
            }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedFilter = filterNames[indexPath.row][0]
        
        let filteredImage = Photo(filterName: selectedFilter, operationQueue: self.imageQueue, context: self.gpuContext)
        filteredImage.originalImage = self.preFilterImage.image
        filteredImage.generateFilteredImage()
        self.imageView.image = filteredImage.filteredImage

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
        // share imageview on twitter
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            let SLViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            SLViewController.addImage(self.imageView.image)
            self.presentViewController(SLViewController, animated: true, completion: nil)
        } else {
            println("twitter is not available")
        }
        
        //add text/email/save image option???
    }
    
    func doneFilterButtonPressed() {
        // show fill imageView, hide filter collection view, and revert right bar button to share
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = self.shareButton
        self.imageViewYConstraint.constant = self.imageViewYFullView
        self.collectionViewYConstraint.constant = self.collectionViewYhide
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    func cancelFilterButtonPressed() {
        // hide filter collection view and revert right bar button to share
        self.doneFilterButtonPressed()
        
        //revert imageView to original image
        self.imageView.image = self.preFilterImage.image
    }
    
    
    
    //MARK: Autolayout Constraints
    func setupAutolayoutConstraints() {

        //vertical layout of imageView and PhotoButton
        //also center align ImageView and PhotoButton
        //save Y constraint to allow of animation
        let imageViewConstraintVeritcal = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-80-[imageView]-(\(self.imageViewYFullView))-[photoButton]-8-|",
            options: NSLayoutFormatOptions.AlignAllCenterX,
            metrics: nil, views: self.views)
        self.imageViewYConstraint = imageViewConstraintVeritcal[1] as NSLayoutConstraint
        self.rootView.addConstraints(imageViewConstraintVeritcal)

        //horizontal layout
        self.rootView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-16-[imageView]-16-|",
            options: nil, metrics: nil, views: self.views))
        
        //animated collectionView layout
        self.rootView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|[collectionView]|",
            options: nil, metrics: nil, views: self.views))

        //save Y constraint to allow animation
        let collectionViewConstraintVeritcal = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:[collectionView(100)]-(\(self.collectionViewYhide))-|",
            options: nil, metrics: nil, views: self.views)
        self.collectionViewYConstraint = collectionViewConstraintVeritcal[1] as NSLayoutConstraint
        self.rootView.addConstraints(collectionViewConstraintVeritcal)

        

    }
    

}





