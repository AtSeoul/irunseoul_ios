//
//  User.swift
//  iRunSeoul
//
//  Created by Hassan Abid on 17/04/2017.
//
//

import UIKit

class User: NSObject {
    var username: String
    var email: String
    
    init(username: String, email: String) {
        self.username = username
        self.email = email
    }
    
    convenience override init() {
        self.init(username:  "", email: "")
    }
}


