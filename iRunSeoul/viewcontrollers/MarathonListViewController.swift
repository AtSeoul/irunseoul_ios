//
//  MarathonListViewController.swift
//  iRunSeoul
//
//  Created by Hassan Abid on 18/04/2017.
//
//

import UIKit
import Firebase
import FirebaseDatabaseUI
import PKHUD

class MarathonListViewController: UIViewController, UITableViewDelegate, EventViewControllerDelegate {

    var ref: FIRDatabaseReference!    
    var dataSource: FUITableViewDataSource?
    var isNewEventFilter : Bool = true
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("MarathonListViewController | viewDidLoad")
        
        setUI()
        
        tableView.delegate = self
        
        ref = FIRDatabase.database().reference()
        
        fetchEventList()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
        
        let backgroundImage = UIImage(named: "tableview_bg.png")
        let imageView = UIImageView(image: backgroundImage)
        imageView.addBlurEffect()
        self.tableView.backgroundView = imageView
            
        self.tabBarController?.tabBar.isHidden = false
        
        navigationItem.title = "Marathon Events"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("didSelectRowAt : ")
        performSegue(withIdentifier: "eventdetail", sender: indexPath)
        
    
    }
    
    func fetchEventList() {
        
        
        let identifier = "eventcell"
        /* Register TableViewCell if you are creating it manually without using prototype cell!
         tableView.register(EventTableViewCell.self, forCellReuseIdentifier: identifier)
         */
        
        HUD.show(.progress)

        dataSource = FUITableViewDataSource.init(query: getQuery()) { (tableView, indexPath, snap) -> UITableViewCell in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! EventTableViewCell
            
            cell.selectionStyle = .none
            
            guard let event = Event.init(snapshot: snap) else { return cell }
            
            cell.backgroundColor = UIColor(red: 33.0/255.0, green: 33.0/255.0, blue: 33.0/255.0, alpha: 0.8)
            
            cell.titleLabel.text = event.title
            cell.cityLabel.text = event.location
            cell.dateTimeLabel.text = event.date
            
            let daysDiff = self.getDaysDiff(date_str: event.date)
            if(daysDiff < 0 ) {
                let plusDaysDiff = -1 * daysDiff
                cell.leftDaysLabel.text = "\(plusDaysDiff) Days ago"
                cell.leftDaysLabel.font = UIFont.systemFont(ofSize: 12)
            } else {
                cell.leftDaysLabel.text = "D-\(self.getDaysDiff(date_str: event.date))"
                cell.leftDaysLabel.font = UIFont.boldSystemFont(ofSize: 20)
            }
            
            if(!event.weather.isEmpty) {
                let weather_name = event.weather.replacingOccurrences(of: "-", with: "_", options: .literal)
                let weather_icon_name = "ic_\(weather_name).png"
                let weatherIcon = UIImage(named: weather_icon_name)
                cell.weatherImageView.image = weatherIcon
            }
            
            
            
            HUD.hide()
            return cell
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

    
    // MARK: - Helpers
    
    func getDaysDiff(date_str: String) -> Int {
    
        var diffDays: Int = 0
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        
        let raceDate = dateFormatter.date(from: date_str)
        
        if let race_date = raceDate {
            
            diffDays = race_date.interval(ofComponent: .day, fromDate: Date())
            
        }
        
        
        return diffDays
    
    }
    
    func setUI() {
    
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0/255.0, green: 188.0/255.0, blue: 212.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        self.navigationController?.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let indexPath: IndexPath = sender as? IndexPath else { return }
        
        guard let eventViewController: EventViewController = segue.destination as? EventViewController else {
            return
        }
        
        navigationItem.title = nil
        if let dataSource = dataSource {
            
//            eventViewController.navigationItem.leftItemsSupplementBackButton = true
            eventViewController.title = "Event"
            eventViewController.event = Event.init(snapshot: dataSource.snapshot(at: indexPath.row))
            eventViewController.delegate = self
            
            self.navigationController?.navigationBar.tintColor = UIColor(red: 0/255.0, green: 188.0/255.0, blue: 212.0/255.0, alpha: 1.0)
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
            
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func didTouchFilter(_ sender: UIBarButtonItem) {
    
        self.showFilterAlert()
        
    }
    
    
    func showFilterAlert() {
        let title = NSLocalizedString("Filter Marathon Events", comment: "")
        let message = NSLocalizedString("Chose approriate option", comment: "")
        let cancelButtonTitle = NSLocalizedString("Cancel", comment: "")
        let otherButtonTitleOne = NSLocalizedString("Past Events", comment: "")
        let otherButtonTitleTwo = NSLocalizedString("New Events", comment: "")
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Create the actions.
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel) { action in
        
            
        }
        
        let pastEventAction = UIAlertAction(title: otherButtonTitleOne, style: .default) { _ in
            
            print("pastEventAction")
            self.isNewEventFilter = false
            self.fetchEventList()
            self.tableView.reloadData()
            
        }
        
        let newEventsAction = UIAlertAction(title: otherButtonTitleTwo, style: .default) { _ in
            
            print("newEventsAction")
            self.isNewEventFilter = true
            self.fetchEventList()
            self.tableView.reloadData()
        }
        
        // Add the actions.
        alertController.addAction(cancelAction)
        alertController.addAction(pastEventAction)
        alertController.addAction(newEventsAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: EventViewController Delegate
    
    func didFinishAddingActivity(sender: EventViewController) {
        
        print("didFinishAddingActivity")
        
        self.tabBarController?.selectedIndex = 1
    
    }
 

}
