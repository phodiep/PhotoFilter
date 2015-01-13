//
//  HomeViewController.swift
//  photoFilter
//
//  Created by Pho Diep on 1/12/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIImagePickerControllerDelegate {
    
    let alertController = UIAlertController(title: "Photo selector", message: "Select source", preferredStyle: UIAlertControllerStyle.ActionSheet)

    var imageView = UIImageView()
    
    override func loadView() {
        let rootView = UIView(frame: UIScreen.mainScreen().bounds)
        rootView.backgroundColor = UIColor.whiteColor()
        
        let photoButton = UIButton()
        photoButton.setTitle("Photo", forState: .Normal)
        photoButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        photoButton.addTarget(self, action: "photoButtonPressed:", forControlEvents: .TouchUpInside)
        
        photoButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        imageView.setTranslatesAutoresizingMaskIntoConstraints(false)

        rootView.addSubview(photoButton)
        rootView.addSubview(imageView)
        
        let views = [
            "photoButton" : photoButton,
            "imageView" : imageView]
        
        setupAutolayoutConstraints(rootView, views: views)
        
        
        self.view = rootView

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Home"
        
        let galleryOption = UIAlertAction(title: "Gallery", style: .Default) { (action) -> Void in
            let galleryVC = GalleryViewController()
            
            self.navigationController?.pushViewController(galleryVC, animated: true)
            
        }

        let cameraOption = UIAlertAction(title: "Camera", style: .Default) { (action) -> Void in
            
            println("Camera not yet installed")
            
        }
        
        alertController.addAction(galleryOption)
        alertController.addAction(cameraOption)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Button actions
    func photoButtonPressed(sender: UIButton) {
        self.presentViewController(self.alertController, animated: true, completion: nil)
    }
    
    
    //MARK: Autolayout Constraints
    func setupAutolayoutConstraints(rootView: UIView, views: [String:UIView]) {
        rootView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-80-[imageView]-8-[photoButton]-8-|", options: nil, metrics: nil, views: views))
        rootView.addConstraint(NSLayoutConstraint(item: views["photoButton"] as UIView!, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: rootView, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        
        rootView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-16-[imageView]-16-|", options: nil, metrics: nil, views: views))

    }
    

}
