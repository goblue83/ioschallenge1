//
//  FilterSort.swift
//  iOSChallenge
//
//  Created by Tom Weeks on 10/12/16.
//  Copyright © 2016 PSOne28. All rights reserved.
//

import UIKit

class FilterSort: UIView {
    
    var filter: UISegmentedControl!
    var ageSort: UISegmentedControl!
    var nameSort: UISegmentedControl!
    var kill: UIButton!
    var done: UIButton!
    var mast: MasterViewController!
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    init(frame: CGRect, master: MasterViewController) {
        super.init(frame: frame)
        mast = master
        setupView(frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //setupView()
    }
    
    func setupView(frame: CGRect) {
        translatesAutoresizingMaskIntoConstraints = false

        self.layer.cornerRadius = 4.0
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 4.0
        self.layer.shadowOffset = CGSizeMake(0.0, 8.0)
        self.backgroundColor = UIColor.lightGrayColor()
        self.alpha = 1.0
        
        let x = frame.origin.x
        let y = frame.origin.y
        let width = frame.width
        let filterItems = ["-", "Male", "Female"]
        let filterl = UILabel(frame: CGRectMake( 10,  20, 60, 20))
        filterl.text = "Filter"
        self.addSubview(filterl)
        filter = UISegmentedControl(items: filterItems)
        filter.frame = CGRectMake((width/2)-20, 20, (width/2) + 10, 20)
        filter.selectedSegmentIndex = 0
        self.addSubview(filter)
        
        let agel = UILabel(frame: CGRectMake( 10, y + 20, 100, 30))
        agel.text = "Sort By Age"
        self.addSubview(agel)
        let asc = UIImage(named: "Asc.png")
        let dsc = UIImage(named: "Dsc.png")
        var ageitems = [AnyObject]()
        ageitems.append("-")
        ageitems.append(asc!)
        ageitems.append(dsc!)
        
        
        ageSort = UISegmentedControl(items: ageitems)
        ageSort.frame = CGRectMake((width/2)-20, y + 20, (width/2) + 10 , 30)
        ageSort.selectedSegmentIndex = 0
        ageSort.addTarget(self, action: #selector(agesortcheck(_:)), forControlEvents: .ValueChanged)
        self.addSubview(ageSort)
        
        let namel = UILabel(frame: CGRectMake( 10, y + 60, 110, 30))
        namel.text = "Sort By Name"
        self.addSubview(namel)
        nameSort = UISegmentedControl(items: ageitems)
        nameSort.frame = CGRectMake((width/2)-20, y + 60, (width/2) + 10 , 30)
        nameSort.selectedSegmentIndex = 0
        nameSort.addTarget(self, action: #selector(namesortcheck(_:)), forControlEvents: .ValueChanged)
        self.addSubview(nameSort)
        
        kill = UIButton(frame: CGRectMake(20,y + 110, 100,24))
        kill.setTitle("Remove All", forState: UIControlState.Normal)
        kill.addTarget(self, action: #selector(removeButton(_:)), forControlEvents: .TouchUpInside)
        self.addSubview(kill)
        done = UIButton(frame: CGRectMake(width - 20 - 60,y + 110, 60,24))
        done.setTitle("Done", forState: UIControlState.Normal)
        done.addTarget(self, action: #selector(doneButton(_:)), forControlEvents: .TouchUpInside)
        self.addSubview(done)
        
        filter.selectedSegmentIndex = mast.filter
        ageSort.selectedSegmentIndex = mast.ageSort
        nameSort.selectedSegmentIndex = mast.nameSort
    }
    
    func namesortcheck(sender: AnyObject) {
        if (ageSort.selectedSegmentIndex != 0) {
            ageSort.selectedSegmentIndex = 0
        }
    }
    
    func agesortcheck(sender: AnyObject) {
        if (nameSort.selectedSegmentIndex != 0) {
            nameSort.selectedSegmentIndex = 0
        }
    }

    func removeButton(sender: AnyObject) {
        filter.selectedSegmentIndex = 0
        ageSort.selectedSegmentIndex = 0
        nameSort.selectedSegmentIndex = 0
        mast.filter = 0
        mast.ageSort = 0
        mast.nameSort = 0
        mast.tableView.reloadData()
        mast.tableView.scrollEnabled = true
        self.removeFromSuperview()
    }
    
    func doneButton(sender: AnyObject) {
        //only one sort at a time
        if (ageSort.selectedSegmentIndex != 0 && nameSort.selectedSegmentIndex != 0) {
            
        } else {
            mast.filter = filter.selectedSegmentIndex
            mast.nameSort =  nameSort.selectedSegmentIndex
            mast.ageSort =  ageSort.selectedSegmentIndex
            mast.tableView.reloadData()
            mast.tableView.scrollEnabled = true
            self.removeFromSuperview()
        }
        
    }
}
