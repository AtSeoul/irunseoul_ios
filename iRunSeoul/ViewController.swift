//
//  ViewController.swift
//  iRunSeoul
//
//  Created by Hassan Abid on 9/16/16.
//
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    let MARATHON_EVENT_DATABASE = "event"
    var firebaseRef:DatabaseReference!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFirebase()
    }

    func setupFirebase() {
        
        Database.database().isPersistenceEnabled = true
        firebaseRef = Database.database().reference(withPath: MARATHON_EVENT_DATABASE)
        
        let query = firebaseRef.child("2017").queryOrdered(byChild: "date").queryLimited(toLast: 20).queryStarting(atValue: "2017/03/15 08:00")

        
        query.observeSingleEvent(of: .value, with: {(snapshot) in
            let eventArray = snapshot.value as! [NSDictionary]
            print("result : \(eventArray)")
            }, withCancel: {(error) in
            print(error.localizedDescription)})
        
        
    }


}

