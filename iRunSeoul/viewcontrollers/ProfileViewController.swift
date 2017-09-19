//
//  ProfileViewController.swift
//  iRunSeoul
//
//  Created by Hassan Abid on 17/04/2017.
//
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setupUI() {
        
        
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0/255.0, green: 188.0/255.0, blue: 212.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        self.navigationController?.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

        
        if let user = Auth.auth().currentUser {
        
            self.nameLabel.text = user.displayName!
            
        }
    
    }

    
    @IBAction func didClickLogout(_ sender: UIButton) {
        
        signout()
    }
    

    func signout() {
    
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
