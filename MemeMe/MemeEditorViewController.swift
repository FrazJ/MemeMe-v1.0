//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Frazer Hogg on 17/08/2015.
//  Copyright (c) 2015 HomeProjects. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    /* View controller properties */
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!   //Button for launching the camera
    @IBOutlet weak var memeImageView: UIImageView!      //View for the Meme image
    @IBOutlet weak var topTextInput: UITextField!       //Top input for Meme text
    @IBOutlet weak var bottomTextInput: UITextField!    //Bottom input for Meme text
    @IBOutlet weak var topToolbar: UIToolbar!           //Top toolbar with share options
    @IBOutlet weak var bottomToolbar: UIToolbar!        //Bottom toolbar with image picker options
    @IBOutlet weak var shareButton: UIBarButtonItem!    //Button for sharing a Meme
    
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
        setupTextField(topTextInput, text: "TOP", delegate: self, attributes: memeTextAttribues, alignment: NSTextAlignment.Center)
        
        //Setup the bottom text input
        setupTextField(bottomTextInput, text: "BOTTOM", delegate: self, attributes: memeTextAttribues, alignment: NSTextAlignment.Center)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Disable the camera button if the device doesn't have a camera
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        //Disable the share button if the user hasn't chosen an image
        shareButton.enabled = memeImageView.image != nil
        
        //Subscribe to keyboard notifications
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        //Unsubscribe from keyboard notifications
        unsubscribeFromKeyboardNotifications()
    }
    
    //Fucntion to setup the textFields in the memeEditor
    func setupTextField (textField: UITextField, text: String, delegate: UITextFieldDelegate, attributes: [String : NSObject], alignment: NSTextAlignment) {
        textField.text = text
        textField.delegate = delegate
        textField.defaultTextAttributes = attributes
        textField.textAlignment = alignment
    }


    /* Observer subscription functions */
    
    //Function that adds this ViewController as an observer for keyboardNotifications 
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
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
    
    //Function that passes the image selected by the user to to the memeImageView
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            memeImageView.image = image
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Function that shares and saves a MemedImage
    @IBAction func shareMemedImage(sender: UIBarButtonItem) {
        
        //Generated a memed image
        let memedImage = generateMemedImage()
        
        //Creates a new ActivityViewController
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
       
        //Closure for handling the users action with the ActivityViewController
        activityViewController.completionWithItemsHandler = { activity, completed, items, error in
            if completed {
                
                //Save the image
                self.save()
                
                //Dismiss the view controller
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    
    /* Keyboard fucntions */
    
    //Function that raises the view up out the way of the keyboard
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextInput.isFirstResponder() {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    //Function that lowers the view when the keyboard is hidden
    func keyboardWillHide(notification: NSNotification) {
        if bottomTextInput.isFirstResponder() {
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    //Fucntion that retrives the height of a keyboard
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo! [UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    //Function that allows the user to use the return key to escape from the text input
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    /* Meme functions */
    
    //Function that saves the memedImage
    func save() {
        //Create the memedImage
        let memedImage = generateMemedImage()
        
        //Create a meme object to store the memed image
        var meme = Meme(topText: topTextInput.text!, bottomText: bottomTextInput.text!, originalImage: memeImageView.image!, memedImage: memedImage)
    }
    
    
    //Function that generates a memeImage from the image and text in the memedEditor
    func generateMemedImage() -> UIImage {
        
        //Hide the toolbars
        topToolbar.hidden = true
        bottomToolbar.hidden = true
        
        //Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Show the toolbars
        topToolbar.hidden = false
        bottomToolbar.hidden = false
        
        return memedImage
    }

}

