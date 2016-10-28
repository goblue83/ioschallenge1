//
//  DetailViewController.swift
//  iOSChallenge
//
//  Created by Tom Weeks on 10/12/16.
//  Copyright © 2016 PSOne28. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class DetailViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var hobbies: UITextView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var bColorButton: UIButton!
    var entry: Entry!
    var animatedDistance = Float(0.0)
    var pImage: UIImage!
    var newcolor: String!
    @IBOutlet weak var saveButton: UIButton!
    

    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let delButton = UIBarButtonItem(barButtonSystemItem: .Trash, target: self, action: #selector(deleteProfile(_:)))
        self.navigationItem.rightBarButtonItem = delButton
        self.navigationItem.title = entry.id
        self.configureView()
        let imageView = profilePic
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(DetailViewController.imageTapped(_:)))
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        hobbies.layer.cornerRadius = 8
        profilePic.layer.cornerRadius = 8
        bColorButton.layer.cornerRadius = 8
        bColorButton.backgroundColor = UIColor.lightGrayColor()
        saveButton.layer.cornerRadius = 8
        saveButton.backgroundColor = UIColor.lightGrayColor()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DetailViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DetailViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(aN: NSNotification) {
        if (animatedDistance == 0) {
            if let userInfo = aN.userInfo {
                let endFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as?     NSValue)?.CGRectValue()
                animatedDistance = Float((endFrame?.size.height)!/2)
                UIView.beginAnimations(nil, context: nil)
                UIView.setAnimationBeginsFromCurrentState(true)
                UIView.setAnimationDuration(0.3)
                self.view.frame = CGRectOffset(self.view.frame, 0 , -CGFloat(animatedDistance))
                UIView.commitAnimations()
            }
        }
    }
    
    func keyboardWillHide(aN: NSNotification) {
        if (animatedDistance != 0) {
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationBeginsFromCurrentState(true)
            UIView.setAnimationDuration(0.3)
            self.view.frame = CGRectOffset(self.view.frame, 0, CGFloat(animatedDistance))
            UIView.commitAnimations()
            animatedDistance = 0
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func configureView() {
        // Update the user interface for the detail item.

        self.name.text = entry.name
        self.gender.text = entry.gender
        self.age.text = String(format: "%d", entry.age)
        self.hobbies.text = entry.hobbies
        if (entry.p_Image == "") {
            profilePic.image = UIImage(named: "generic.jpg")
        } else {
            let url = NSURL(string: entry.p_Image)
            if let data = NSData(contentsOfURL: url!) {
                profilePic.image = UIImage(data: data)
            }
        }
        if (self.entry.background != "") {
            let cValues = entry.background.componentsSeparatedByString(" ")
            let temp1 = Float(Double(cValues[1])!)
            let temp2 = Float(Double(cValues[2])!)
            let temp3 = Float(Double(cValues[3])!)
            
            let returnedColor = UIColor(colorLiteralRed: temp1, green: temp2, blue: temp3, alpha: 1.0)
            self.view.backgroundColor = returnedColor
        }
        
    }
    
    @IBAction func saveButtonAction(sender: AnyObject?) {
        let ref = FIRDatabase.database().reference().child("Profiles")
        let key = self.entry.id
        let userRef = ref.child(key)
        if (pImage != nil) {
            let picdata: NSData = UIImagePNGRepresentation(profilePic.image!)!
            
            let storageRef = FIRStorage.storage().reference().child("profile_images").child(String(format: "%@.png", entry.id))
            
            storageRef.putData(picdata, metadata: nil) { metadata, error in
                if (error != nil) {
                    
                } else {
                    let downloadURL = metadata!.downloadURL()!.absoluteString
                    if (self.entry.background != self.newcolor && self.newcolor != nil) {
                        self.entry.background = self.newcolor
                    }
                    if (self.entry.hobbies != self.hobbies.text) {
                        self.entry.hobbies = self.hobbies.text
                    }
                    
                    
                    self.entry.p_Image = downloadURL
                    // store downloadURL in db
                    userRef.setValue(self.entry.toAnyObject())
                    self.performSegueWithIdentifier("GotoMaster", sender: self)
                }
            }
        } else if (self.entry.background != self.newcolor && self.newcolor != nil) {
            self.entry.background = self.newcolor
            if (self.entry.hobbies != self.hobbies.text) {
                self.entry.hobbies = self.hobbies.text
                
            }
            userRef.setValue(self.entry.toAnyObject())
            self.performSegueWithIdentifier("GotoMaster", sender: self)
        } else if (self.entry.hobbies != self.hobbies.text) {
            self.entry.hobbies = self.hobbies.text
            userRef.setValue(self.entry.toAnyObject())
            self.performSegueWithIdentifier("GotoMaster", sender: self)
        } else {
            self.performSegueWithIdentifier("GotoMaster", sender: self)
        }
    
        
    }
    

    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        let scale = 200 / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(200, newHeight))
        image.drawInRect(CGRectMake(0, 0, 200, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = UIImageJPEGRepresentation(newImage, 0.5)
        UIGraphicsEndImageContext()
        profilePic.image = UIImage(data: imageData!)
        pImage = UIImage(data: imageData!)
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    
    func imageTapped(img: AnyObject) {
        let alertController = UIAlertController(title: "Change Profil Picture", message: "Select Source", preferredStyle: .Alert)
        
        let action1 = UIAlertAction(title: "Camera", style: .Default) {( action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
                imagePicker.allowsEditing = false
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
        }
        let action2 = UIAlertAction(title: "Photo Library", style: .Default) {( action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
                imagePicker.allowsEditing = true
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
        }
        alertController.addAction(action1)
        alertController.addAction(action2)
        
        presentViewController(alertController, animated: true, completion:nil)
    }

    func deleteProfile(sender: AnyObject?) {
        let ref = FIRDatabase.database().reference()
        ref.child("Profiles").child(entry.key).removeValue()
        self.performSegueWithIdentifier("GotoMaster", sender: self)
    }
    
    @IBAction func bColorAction(sender: AnyObject?) {
        //create the Alert message with extra return spaces
        let sliderAlert = UIAlertController(title: "Update background color", message: "\n\n\n\n\n\n", preferredStyle: .Alert)
        
        //create a Slider and fit within the extra message spaces
        //add the Slider to a Subview of the sliderAlert
        let slider = UISlider(frame:CGRect(x: 10, y: 100, width: 250, height: 80))
        slider.minimumValue = 0.0
        slider.maximumValue = 1.0
        slider.value = 0.0
        slider.tintColor = UIColor.redColor()
        slider.addTarget(self, action: #selector(DetailViewController.sliderValueDidChange(_:)), forControlEvents: .ValueChanged)
        sliderAlert.view.addSubview(slider)
        
        //OK button action
        let sliderAction = UIAlertAction(title: "OK", style: .Default, handler: { (result : UIAlertAction) -> Void in
            self.newcolor = String(self.view.backgroundColor)
        })
        
        //Cancel button action
        let cancelAction = UIAlertAction(title: "Cancel", style: .Destructive, handler:{ (result : UIAlertAction) -> Void in
            let cValues = self.entry.background.componentsSeparatedByString(" ")
            let temp1 = Float(Double(cValues[1])!)
            let temp2 = Float(Double(cValues[2])!)
            let temp3 = Float(Double(cValues[3])!)
            let returnedColor = UIColor(colorLiteralRed: temp1, green: temp2, blue: temp3, alpha: 1)
            self.view.backgroundColor = returnedColor
        })
        
        //Add buttons to sliderAlert
        sliderAlert.addAction(sliderAction)
        sliderAlert.addAction(cancelAction)
        
        //present the sliderAlert message
        presentViewController(sliderAlert, animated: true, completion: nil)
    }
    
    func sliderValueDidChange(sender: UISlider!) {
        let colorValue = CGFloat(sender.value)
        let color = UIColor(hue: colorValue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        self.view.backgroundColor = color
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

