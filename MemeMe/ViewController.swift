//
//  ViewController.swift
//  MemeMe
//
//  Created by Frazer Hogg on 17/08/2015.
//  Copyright (c) 2015 HomeProjects. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    /* View controller properties */
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!   //Button for launching the camera
    @IBOutlet weak var memeImageView: UIImageView!      //View for the Meme image
    @IBOutlet weak var topTextInput: UITextField!       //Top input for Meme text
    @IBOutlet weak var bottomTextInput: UITextField!    //Bottom input for
    
    //Attributes for styling the text in the text fields
    let memeTextAttribues = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : NSNumber(float: -3.0)
        
    ]
    
    
    /* View lifecycle functions */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup the top text input
        topTextInput.text = "TOP"
        topTextInput.delegate = self
        topTextInput.defaultTextAttributes = memeTextAttribues
        topTextInput.textAlignment = NSTextAlignment.Center
        
        //Setup the bottom text input
        bottomTextInput.text = "BOTTOM"
        bottomTextInput.delegate = self
        bottomTextInput.defaultTextAttributes = memeTextAttribues
        bottomTextInput.textAlignment = NSTextAlignment.Center
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Disable the camera button if the device doesn't have a camera
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }


    
    /* User interface functions */
    
    //Function that allows a user to pick an image to use either from their photo library or from their camera
    @IBAction func pickImage(sender: UIBarButtonItem) {
        
        //Creates an new imagePickerController as assigns this viewController to be its delegate
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        //Checks the title of the sender and displays either the PhotoLibrary or Camera accordingly
        if sender.title == "Album" {
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            presentViewController(imagePicker, animated: true, completion: nil)
        } else {
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    /* UIImagePickerControllerDelegate functions */
    
    //Function that passes the image selected by the user to to the memeImageView
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            memeImageView.image = image
        }
        dismissViewControllerAnimated(true, completion: nil)
    }

}

