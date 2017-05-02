//
//  LandingViewController.swift
//  iRunSeoul
//
//  Created by Hassan Abid on 14/04/2017.
//
//

import UIKit
import Firebase

class LandingViewController: UIViewController {
    
    var handle: FIRAuthStateDidChangeListenerHandle?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUI()

        handle = FIRAuth.auth()?.addStateDidChangeListener() { (auth, user) in
            
            print("FIRAuth | changelistener")
            if let user = user {
                print("user : \(user)")
                self.startHomeController()
                
            }
        }
        
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        FIRAuth.auth()?.removeStateDidChangeListener(handle!)
    }
    
    func setUI() {
    
        self.navigationController?.navigationBar.isHidden = true

    }
    
    // MARK: - Helpers
    
    func startHomeController() {
        
        let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "maintabbarvc") as! MainTabBarViewController
        
        self.present(mainViewController, animated: true, completion: nil)
        
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
