//
//  MyRunBaseViewController.swift
//  iRunSeoul
//
//  Created by Hassan Abid on 18/04/2017.
//
//

import UIKit
import Firebase
import FirebaseDatabaseUI
import Kingfisher
import PKHUD

class MyRunBaseViewController: UIViewController, UITableViewDelegate {
    
    var ref: FIRDatabaseReference!
    var dataSource: FUITableViewDataSource?
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("MyRunBaseViewController | viewDidLoad")
        
        setUI()
        
        tableView.delegate = self
        
        ref = FIRDatabase.database().reference()
        
        fetchMyRuns()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
        
        self.tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("didSelectRowAt : ")
        //        performSegue(withIdentifier: "detail", sender: indexPath)
    }

    func fetchMyRuns() {
    
    
        let identifier = "myruncell"
        
        HUD.show(.progress)
        
        dataSource = FUITableViewDataSource.init(query: getQuery()) { (tableView, indexPath, snap) -> UITableViewCell in
            
            self.tableView.backgroundView?.isHidden = true
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MyRunTableViewCell
            
            guard let myrun = MyRun.init(snapshot: snap) else { return cell }
            
            cell.backgroundColor = UIColor(red: 33.0/255.0, green: 33.0/255.0, blue: 33.0/255.0, alpha: 0.8)
            
            cell.typeImageView.image = cell.typeImageView.image!.withRenderingMode(.alwaysTemplate)
            cell.typeImageView.tintColor = UIColor.white
            
            cell.timeImageView.image = cell.timeImageView.image!.withRenderingMode(.alwaysTemplate)
            cell.timeImageView.tintColor = UIColor.white
            
            cell.paceImageView.image = cell.paceImageView.image!.withRenderingMode(.alwaysTemplate)
            cell.paceImageView.tintColor = UIColor.white
            
            
            cell.runTitleLabel.text = myrun.title
            cell.distanceLabel.text = "\(myrun.distance) KM"
            cell.timeLabel.text = myrun.moving_time
            cell.runDate.text = myrun.date
            cell.paceLabel.text = "\(myrun.average_speed) KM/H"
            
            HUD.hide(animated: true)
            return cell
        }
        
        
        if((dataSource?.count)! == 0) {
            HUD.hide(animated: true)
            setupEmptyBackgroundView()
        }
        
        dataSource?.bind(to: tableView)
    }
    
    
    func getUid() -> String {
        return (FIRAuth.auth()?.currentUser?.uid)!
    }
    
    func getQuery() -> FIRDatabaseQuery {
        return self.ref
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        getQuery().removeAllObservers()
    }
    
    
    // MARK - Helpers
    
    func setupEmptyBackgroundView()  {
    
         let image = UIImage(named: "ic_run_empty")!.withRenderingMode(.alwaysTemplate)
         let topMessage = "My Runs"
         let bottomMessage = "You don't have any record synced yet. Select a marathon event and sync record from Strava"
        
        let emptyBackgroundView = EmptyBackgroundView(image: image, top: topMessage, bottom: bottomMessage)
        tableView.backgroundView = emptyBackgroundView
    }
    
    
    // MARK: - IBActions
    
    @IBAction func didTouchRefresh(_ sender: UIBarButtonItem) {
        
        fetchMyRuns()
        
        self.tableView.reloadData()
    }
    
    
    func setUI() {
    
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0/255.0, green: 188.0/255.0, blue: 212.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        self.navigationController?.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
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
