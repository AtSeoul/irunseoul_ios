//
//  MyRunListViewController.swift
//  iRunSeoul
//
//  Created by Hassan Abid on 18/04/2017.
//
//

import UIKit
import Firebase

class MyRunListViewController: MyRunBaseViewController {

    override func getQuery() -> DatabaseQuery {
        
        let myRunsQuery = (ref?.child("user-runs").child(getUid()).queryLimited(toFirst: 100))!
        return myRunsQuery
    }

}
