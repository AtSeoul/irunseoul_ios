//
//  MainTabBarViewController.swift
//  iRunSeoul
//
//  Created by Hassan Abid on 17/04/2017.
//
//

import UIKit

class MainTabBarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        print("MainTabBarViewController - viewDidLoad")
        self.delegate = self
        self.selectedIndex = 0
        
        self.tabBar.barTintColor = UIColor.white
        self.tabBar.tintColor = UIColor(red: 0/255.0, green: 188.0/255.0, blue: 212.0/255.0, alpha: 1.0)
        
        tabBarController(self, didSelect: self.selectedViewController!)
        
        UIApplication.shared.statusBarView?.backgroundColor = UIColor(red: 0/255.0, green: 151.0/255.0, blue: 167.0/255.0, alpha: 1.0)
        
    }
    

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        print("tabBarController | didSelect : \(viewController)")
        
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        
        if parent == nil {
            //TODO:
        }
    }
    
    
    
    

}
