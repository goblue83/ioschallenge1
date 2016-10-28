//
//  NewProfile.swift
//  iOSChallenge
//
//  Created by Tom Weeks on 10/12/16.
//  Copyright © 2016 PSOne28. All rights reserved.
//

import UIKit
import FirebaseDatabase

class NewProfile: UIView, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    var name: UITextField!
    var gender: UIPickerView!
    var age: UIPickerView!
    var hobbies: UITextView!
    var done: UIButton!
    var cancel: UIButton!
    var animatedDistance = Float(0.0)
    var ageKeep = 1
    var genKeep = "Female"
    var genArray = ["Female", "Male"]
    var ageArray = [String]()
    let ref1 = FIRDatabase.database().reference().child("Profiles")
    var mast: MasterViewController!
    var active: UITextField!
    
    //override init(frame: CGRect, master: MasterViewController) {
    init(frame: CGRect, master: MasterViewController) {
        super.init(frame: frame)
        setupView(frame)
        mast = master
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //setupView()
    }
    
    func setupView(frame: CGRect) {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NewProfile.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NewProfile.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil)
        
        translatesAutoresizingMaskIntoConstraints = false

        /// Adds a shadow to our view
        self.layer.cornerRadius = 8.0
        //self.layer.shadowColor = UIColor.blackColor().CGColor
        //self.layer.shadowOpacity = 0.2
        //self.layer.shadowRadius = 4.0
        //self.layer.shadowOffset = CGSizeMake(0.0, 8.0)
        self.backgroundColor = UIColor.lightGrayColor()

        self.alpha = 1.0
        for i in 1...100 {
            let inc = String(format: "%d", i)
            ageArray.append(inc)
        }
        let x = frame.origin.x
        let y = frame.origin.y
        let width = frame.width
        let namel = UILabel(frame: CGRectMake(x + 10,  20, 60, 20))
        namel.text = "Name"
        self.addSubview(namel)
        self.name = UITextField(frame: CGRectMake(width/2, 20, (width/2) - 10, 24))
        name.backgroundColor = UIColor.whiteColor()
        name.layer.cornerRadius = 8
        self.name.delegate = self
        self.addSubview(name)
        let genl = UILabel(frame: CGRectMake(x + 10, y + 45, 60, 20))
        genl.text = "Gender"
        self.addSubview(genl)
        gender = UIPickerView(frame: CGRectMake(width/2, y + 30, (width/2) - 10, 50))
        gender.dataSource = self
        gender.delegate = self
        self.addSubview(gender)
        let agel = UILabel(frame: CGRectMake(x + 10, y + 125, 60, 20))
        agel.text = "Age"
        self.addSubview(agel)
        age = UIPickerView(frame: CGRectMake(width / 2, y + 95, (width/2) - 10, 80))
        age.dataSource = self
        age.delegate = self
        self.addSubview(age)
        let hobbyl = UILabel(frame: CGRectMake((width - 60) / 2, y + 190, 80, 20))
        hobbyl.text = "Hobbies"
        self.addSubview(hobbyl)
        hobbies = UITextView(frame: CGRectMake(x + 10, y + 215, width - ((x+10)*2) ,100))
        hobbies.layer.cornerRadius = 8
        hobbies.delegate = self;
        self.addSubview(hobbies)
        cancel = UIButton(frame: CGRectMake(x + 30,y + 325, 60,24))
        cancel.setTitle("Cancel", forState: UIControlState.Normal)
        cancel.addTarget(self, action: #selector(cancelButton(_:)), forControlEvents: .TouchUpInside)
        self.addSubview(cancel)
        done = UIButton(frame: CGRectMake(width - 30 - 60,y + 325, 60,24))
        done.setTitle("Done", forState: UIControlState.Normal)
        done.addTarget(self, action: #selector(doneButton(_:)), forControlEvents: .TouchUpInside)
        self.addSubview(done)
    }
    
    func keyboardWillShow(aN: NSNotification) {
        if (active != name) {
            if (animatedDistance == 0) {
                if let userInfo = aN.userInfo {
                    print(userInfo)
                    let endFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as?     NSValue)?.CGRectValue()
                    animatedDistance = Float((endFrame?.size.height)!)
                    UIView.beginAnimations(nil, context: nil)
                    UIView.setAnimationBeginsFromCurrentState(true)
                    UIView.setAnimationDuration(0.3)
                    self.frame = CGRectOffset(self.frame, 0 , -CGFloat(animatedDistance))
                    UIView.commitAnimations()
                }
            }
        }
        
    }
    
    func keyboardWillHide(aN: NSNotification) {
        if (animatedDistance != 0) {
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationBeginsFromCurrentState(true)
            UIView.setAnimationDuration(0.3)
            self.frame = CGRectOffset(self.frame, 0, CGFloat(animatedDistance))
            UIView.commitAnimations()
            animatedDistance = 0
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        active = textField
    }
    
    func cancelButton(send: AnyObject) {
        mast.tableView.scrollEnabled = true
        self.removeFromSuperview()
    }
    
    func doneButton(send: AnyObject) {
        // save information and send to server
        let nameText = name.text
        let hobbiesText = hobbies.text
        
        //do not save without name
        if (name.text == nil || name.text == "") {
            return
        }
        //create unique id based on date and time
        var d = NSDateComponents()
        d.day = 1
        d.month = 1
        d.year = 2016
        d.hour = 12
        d.minute = 0
        d.second = 0
        d.calendar = NSCalendar.currentCalendar()
        let date = NSCalendar(identifier: NSCalendarIdentifierGregorian)?.dateFromComponents(d)
        let ddd = date!.timeIntervalSinceNow
        let id = (ddd*100) * -1
        let lm = String(format: "%.0f", id)
        let entry = Entry(n: nameText!, g: genKeep, a: ageKeep, h: hobbiesText!, i: lm)
        
        let entryRef = self.ref1.child(lm)
        entryRef.setValue(entry.toAnyObject())
        mast.tableView.scrollEnabled = true
        self.removeFromSuperview()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == age {
            return ageArray.count
        } else if pickerView == gender {
           return genArray.count
        }
        return 0
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        [textField .resignFirstResponder()]
        active = nil
        return true
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == age {
            return ageArray[row]
        } else if pickerView == gender {
          return genArray[row]
        }
        return "blank"
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == age {
           let temp = ageArray[row]
           ageKeep = Int(temp)!
        } else if pickerView == gender {
            genKeep = genArray[row]
        }
    }
}
