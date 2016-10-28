//
//  Entry.swift
//  iOSChallenge
//
//  Created by Tom Weeks on 10/12/16.
//  Copyright © 2016 PSOne28. All rights reserved.
//

import Foundation
import UIKit
import Firebase
class Entry: NSObject {
    var key = ""
    var id = ""
    var gender = ""
    var name = ""
    var age: Int = 0
    var p_Image = ""
    var hobbies = ""
    var background = ""
    
    init(n: String, g: String, a: Int, h: String, i: String) {
        self.name = n
        self.gender = g
        self.age = a
        self.hobbies = h
        self.id = i        
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        gender = snapshotValue["gender"] as! String
        age = snapshotValue["age"] as! Int
        hobbies = snapshotValue["hobbies"] as! String
        id = snapshotValue["id"] as! String
        background = snapshotValue["background"] as! String
        p_Image = snapshotValue["p_Image"] as! String
        print("%ld", id)
    }
    
    func toAnyObject() -> AnyObject {
        return [
            "id": id,
            "gender": gender,
            "name": name,
            "age": age,
            "hobbies": hobbies,
            "background": background,
            "p_Image": p_Image
        ]
    }
}