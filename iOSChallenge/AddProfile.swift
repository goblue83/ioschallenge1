//
//  AddProfile.swift
//  iOSChallenge
//
//  Created by Tom Weeks on 10/12/16.
//  Copyright © 2016 PSOne28. All rights reserved.
//

import UIKit

class AddProfile: UIView, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var gender: UIPickerView!
    @IBOutlet weak var age: UIPickerView!
    @IBOutlet weak var hobbies: UITextView!
    @IBOutlet weak var done: UIButton!
    @IBOutlet weak var cancel: UIButton!
    
    var ageKeep = 0
    var genKeep = ""
    var genArray = ["Female", "Male"]
    var ageArray = [String]()
    @IBOutlet var view: UIView!
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func loadViewFromXibFile() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "AddProfile", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        gender.dataSource = self
        gender.delegate = self
        
        age.dataSource = self
        age.delegate = self
        return view
    }

    func setupView() {
        view = loadViewFromXibFile()
        view.frame = bounds
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        //titleLabel.text = NSLocalizedString("Saved_to_garage", comment: "")
        
        /// Adds a shadow to our view
        view.layer.cornerRadius = 4.0
        view.layer.shadowColor = UIColor.blackColor().CGColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 4.0
        view.layer.shadowOffset = CGSizeMake(0.0, 8.0)
        
        //visualEffectView.layer.cornerRadius = 4.0
        
        for i in 1...100 {
            let inc = String(format: "%d", i)
            ageArray.append(inc)
        }
    }
    
    func displayView(onView: UIView) {
        //self.alpha = 0.0
        onView.addSubview(self)
        
        //onView.addConstraint(NSLayoutConstraint(item: self, attribute: .CenterY, relatedBy: .Equal, toItem: onView, attribute: .CenterY, multiplier: 1.0, constant: 0.0)) // move it a bit upwards
        //onView.addConstraint(NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: onView, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
       // onView.needsUpdateConstraints()
        
        // display the view
        transform = CGAffineTransformMakeScale(0.1, 0.1)
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.alpha = 1.0
            self.transform = CGAffineTransformIdentity
        }) { (finished) -> Void in
            // When finished wait 1.5 seconds, than hide it
            //let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Double(NSEC_PER_SEC)))
            //dispatch_after(delayTime, dispatch_get_main_queue()) {
            //    self.hideView()
            //}
        }
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
    
    @IBAction func cancelButton() {
        self.hideView()
    }
    
    @IBAction func doneButton() {
        
        
        
    }
    
    private func hideView() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.transform = CGAffineTransformMakeScale(0.1, 0.1)
        }) { (finished) -> Void in
            self.removeFromSuperview()
        }
    }
    
}
