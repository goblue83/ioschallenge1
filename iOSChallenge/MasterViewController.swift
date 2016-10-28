//
//  MasterViewController.swift
//  iOSChallenge
//
//  Created by Tom Weeks on 10/12/16.
//  Copyright © 2016 PSOne28. All rights reserved.
//

import UIKit
import FirebaseDatabase


class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var sorted = [Entry]()
    var entries = [Entry]()
    var newProfile: NewProfile!
    var filterSort: FilterSort!
    let ref = FIRDatabase.database().reference()
    var filter = 0
    var ageSort = 0
    var nameSort = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(insertNewObject(_:)))
        let editButton = UIBarButtonItem(barButtonSystemItem: .Organize, target: self, action: #selector(editList(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.leftBarButtonItem = editButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        ref.child("Profiles").observeEventType(.Value, withBlock: {snapshot in
            var newentries : [Entry] = []
            for item in snapshot.children {
                let entry = Entry(snapshot: item as! FIRDataSnapshot)
                newentries.append(entry)
            }
            self.entries = newentries.sort({ $0.id < $1.id })
            self.tableView.reloadData()
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
    
    }
    
    func insertNewObject(sender: AnyObject) {
        self.tableView.alpha = 0.5
        newProfile = NewProfile(frame: CGRectMake(20, 50, self.view.frame.size.width-40, 400), master: self)
        self.view.addSubview(newProfile)
        self.tableView.scrollEnabled = false
    }
    
    func editList(sender: AnyObject) {
        filterSort = FilterSort(frame: CGRectMake(20, 50, self.view.frame.size.width-40, 200), master: self)
        self.view.addSubview(filterSort)
        self.tableView.scrollEnabled = false
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = sorted[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.entry = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var sorting : [Entry] = []
        var sorting2 : [Entry] = []
        if (filter == 1) {
            for EntryS in entries {
                if (EntryS.gender == "Male") {
                    sorting.append(EntryS)
                }
            }
        } else if (filter == 2) {
            for EntryS in entries {
                if (EntryS.gender == "Female") {
                    sorting.append(EntryS)
                }
            }
        } else {
            sorting.appendContentsOf(entries)
        }
        if (ageSort != 0) {
            if (ageSort == 1) {
                sorting2 = sorting.sort{ $0.age < $1.age }
            } else if (ageSort == 2) {
                sorting2 = sorting.sort({ $0.age > $1.age })
            }
            sorted = sorting2
        } else if (nameSort != 0) {
            if (nameSort == 1) {
                sorting2 = sorting.sort{ $0.name < $1.name }
            } else if (nameSort == 2) {
                sorting2 = sorting.sort({ $0.name > $1.name })
            }
            sorted = sorting2
        } else {
            sorted = sorting
        }
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sorted.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell:CustomCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let cell:CustomCell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as! CustomCell
        

        let centry = sorted[indexPath.row]
        if centry.gender == "Male" {
            cell.view.backgroundColor = UIColor.blueColor()
            cell.name.textColor = UIColor.whiteColor()
            cell.age.textColor = UIColor.whiteColor()
        } else {
            cell.view.backgroundColor = UIColor.greenColor()
            cell.name.textColor = UIColor.blackColor()
            cell.age.textColor = UIColor.blackColor()
        }
        cell.name!.text = centry.name
        cell.age!.text = String(format: "%d", centry.age)
        cell.view.layer.cornerRadius = 8
        cell.view.layer.masksToBounds = true
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    /*override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let dentry = sorted[indexPath.row]
            sorted.removeAtIndex(indexPath.row)
            ref.child("Profiles").child(dentry.key).removeValue()
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }*/


}

