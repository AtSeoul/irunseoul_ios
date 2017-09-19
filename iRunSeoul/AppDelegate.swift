//
//  AppDelegate.swift
//  iRunSeoul
//
//  Created by Hassan Abid on 9/16/16.
//
//

import UIKit
import Firebase
import GoogleMaps
import StravaKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        
        GMSServices.provideAPIKey("AIzaSyBPXuCBvM6sBNusdIMwSYAyLdCa4fyW1vI")
        
         if Auth.auth().currentUser != nil {
            
            let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let homeViewController = mainStoryBoard.instantiateViewController(withIdentifier: "maintabbarvc") as! MainTabBarViewController
        
            window!.rootViewController = homeViewController
            window!.makeKeyAndVisible()
            
        }
        
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        
        /*
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: Constants.tintColor], for:.normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.black], for:.selected)
        UITabBar.appearance().tintColor = Constants.tintColor
 
         */
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return Strava.openURL(url, sourceApplication: sourceApplication)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

