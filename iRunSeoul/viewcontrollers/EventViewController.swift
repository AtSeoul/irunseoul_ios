//
//  TestViewController.swift
//  iRunSeoul
//
//  Created by Hassan Abid on 24/04/2017.
//
//

import UIKit
import GoogleMaps
import SafariServices
import StravaKit
import Firebase
import PKHUD

protocol EventViewControllerDelegate: class {
    
    func didFinishAddingActivity(sender: EventViewController)
}


class EventViewController: UIViewController, SFSafariViewControllerDelegate {
    
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var eventApplicationPeriodLabel: UILabel!
    @IBOutlet weak var eventWeatherLabel: UILabel!
    @IBOutlet weak var eventWebsiteButton: UIButton!
    @IBOutlet weak var eventMapButton: UIButton!
    @IBOutlet weak var linkStravaButton: UIButton!
    @IBOutlet weak var eventMapView: GMSMapView!
    
    // MARK: - Private Constants -
    
    fileprivate let ClientIDKey: String = "client_id"
    fileprivate let ClientSecretKey: String = "client_secret"

    
    var clientId : String = ""
    var clientSecret : String = ""
    
    var event: Event?
    let zoomLevel: Float = 13.0
    var safariViewController: SFSafariViewController? = nil
    var ref: DatabaseReference!
    
    weak var delegate:EventViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Strava.isDebugging = true
        self.ref = Database.database().reference()
        setUI()
        setMap()
        
        NotificationCenter.default.addObserver(self, selector: #selector(EventViewController.stravaAuthorizationCompleted(_:)), name: NSNotification.Name(rawValue: StravaAuthorizationCompletedNotification), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: StravaAuthorizationCompletedNotification), object: nil)
    }
    
    
    // MARK: - IB Actions
    
    @IBAction func didClickWebsite(_ sender: UIButton) {
        
        if let single_event = event {
            
            let svc = SFSafariViewController(url: NSURL(string: single_event.website)! as URL, entersReaderIfAvailable: true)
            svc.delegate = self
            self.present(svc, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func didClickMap(_ sender: Any) {
        
        if let single_event = event {
            
            let svc = SFSafariViewController(url: NSURL(string: single_event.map_url)! as URL)
            svc.delegate = self
            self.present(svc, animated: true, completion: nil)
        }

    }
    
    
    @IBAction func didClickStrava(_ sender: UIButton) {
        
        connectWithStrava()
    }

    
    // MARK - SafarViewControllerdelegate 
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Helpers
    
    func setUI() {
        
        self.navigationController?.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        if let single_event = event {
            
            self.eventTitleLabel.text = single_event.title
            self.eventDateLabel.text = single_event.date
            self.eventWeatherLabel.text = "Predicted Weather : \(single_event.temperature)"
            self.eventApplicationPeriodLabel.text = "Application Period : \(single_event.application_period)"
            self.eventLocationLabel.text = single_event.location
            
        }
        
    }
    
    func setMap() {
        
        let marker = GMSMarker()
        
        if let single_event = event {
            
            if(!single_event.latitude.isEmpty && !single_event.latitude.isEmpty) {
                let latitude = Double(single_event.latitude)!
                let longitude = Double(single_event.longitude)!
                
                print("latitude : \(latitude) longitude : \(longitude)")
                
                let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoomLevel)
                
                eventMapView.camera = camera
                
                eventMapView.settings.compassButton = true
                
                marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                marker.title = single_event.title
                marker.snippet = single_event.location
                marker.map = eventMapView
                
                
            } else {
                eventMapView.isHidden = true
            }
            
        }
    }
    
    func connectWithStrava() {
    
        let path = Bundle.main.path(forResource: "Strava-Info", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        
        self.clientId = dict!.object(forKey: "strava_client_id") as! String
        self.clientSecret = dict!.object(forKey: "strava_client_secret") as! String
        
        storeDefaults()
        
        print("client_id : \(clientId) client_secret : \(clientSecret)")
        
        if !Strava.isAuthorized {
            authorizeStrava()
        } else {
        
            self.getActivity { (success, error) in
                
                if(success) {
                    HUD.flash(.success, delay: 1.0) { finished in
                        self.delegate?.didFinishAddingActivity(sender: self)
                        _ = self.navigationController?.popViewController(animated: true)
                        print("actiivty stored!!")
                    }
                } else {
                    HUD.hide()
                    self.showNoActivityAlert()
                }
            }
        }
        
    }
    
    
    func authorizeStrava() {
    
        let redirectURI = "stravaseoul://localhost/oauth/signin"
        Strava.set(clientId: clientId, clientSecret: clientSecret, redirectURI: redirectURI)
        
        if let URL = Strava.userLogin(scope: .Public) {
            let vc = SFSafariViewController(url: URL, entersReaderIfAvailable: false)
            present(vc, animated: true, completion: nil)
            safariViewController = vc
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
    
    // MARK: - Defaults Functions -
    
    internal func loadDefaults() {
        let defaults = UserDefaults.standard
        if let clientId = defaults.object(forKey: ClientIDKey) as? String,
            let clientSecret = defaults.object(forKey: ClientSecretKey) as? String {
            self.clientId = clientId
            self.clientSecret = clientSecret
        }
    }
    
    internal func storeDefaults() {
        let defaults = UserDefaults.standard
        defaults.set(clientId, forKey: ClientIDKey)
        defaults.set(clientSecret, forKey: ClientSecretKey)
    }
    
    internal func stravaAuthorizationCompleted(_ notification: Notification?) {
//        assert(Thread.isMainThread, "Main Thread is required")
        safariViewController?.dismiss(animated: true, completion: nil)
        safariViewController = nil
//        refreshUI()
        guard let userInfo = notification?.userInfo,
            let status = userInfo[StravaStatusKey] as? String else {
                return
        }
        if status == StravaStatusSuccessValue {
//            self.statusLabel.text = "Authorization successful!"
            print("Authorization successful!")
        }
        else if let error = userInfo[StravaErrorKey] as? NSError {
            debugPrint("Error: \(error.localizedDescription)")
        }
        
        getActivity { (success, error) in
         
            if(success) {
                 HUD.flash(.success, delay: 1.0) { finished in
                    
                    self.delegate?.didFinishAddingActivity(sender: self)
                    _ = self.navigationController?.popViewController(animated: true)
                    print("actiivty stored!!")
                }
            } else {
                 HUD.hide()
                self.showNoActivityAlert()
            }
        }
        
        
    }
    
    func getActivity(_ completionHandler: @escaping ((_ success: Bool, _ error: NSError?) -> ())) {
        
        let page = Page(page: 1, perPage: 40)
        HUD.show(.progress)
        Strava.getActivities(page, completionHandler: { (activities, error) in
            if let activities = activities {
                
                print("number of activities : \(activities.count)")
                
                for activity in activities {

                    if(self.isStravaActivity(date_str: self.event!.date, date_strava: activity.startDateLocal)) {
                    
                        print("got activity : \(activity)")
                        
                        let userID = Auth.auth().currentUser?.uid
                        self.ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in

                            self.ref.child("user-runs").child(userID!).queryOrdered(byChild: "run_id").queryEqual(toValue: "\(activity.activityId)").observeSingleEvent(of: .value, with: { (snapshot) in
                            
                            
                                guard !snapshot.exists() else {
                                
                                    completionHandler(false, nil)
                                    return
                                }
                                
                                let event = self.event!
                                let key = self.ref.child("runs").childByAutoId().key
                                let run = ["uid": userID!,
                                           "title": event.title,
                                           "city": event.city,
                                           "date": event.date,
                                           "host": event.host,
                                           "latitude": event.latitude,
                                           "location": event.location,
                                           "longitude": event.longitude,
                                           "map_url": event.map_url,
                                           "temperature": event.temperature,
                                           "weather": event.weather,
                                           "website": event.website,
                                           "run_app": "strava",
                                           "run_id": "\(activity.activityId)",
                                           "run_name": activity.name,
                                           "distance": self.getDistanceInKM(distanceInMeters: activity.distance),
                                           "moving_time": self.getFormattedMovingTime(timeInSeconds: activity.movingTime),
                                           "average_speed": self.getSpeedKMperHR(averageSpeed: activity.averageSpeed),
                                           "type": activity.type,
                                           "start_date": activity.startDate?.description ?? "",
                                           "start_date_local": activity.startDateLocal?.description ?? "",
                                           "photo_url": ""]
                                
                                
                                let childUpdates = ["/runs/\(key)": run,
                                                    "/user-runs/\(userID!)/\(key)/": run]
                                self.ref.updateChildValues(childUpdates)
                                self.ref.updateChildValues(childUpdates, withCompletionBlock: { (error, reference) in
                                    
                                    guard error == nil else {
                                        
                                        print("sucessfully added value")
                                        completionHandler(false, nil)
                                        return
                                    }
                                    completionHandler(true, nil)
                                    
                                })
                            
                            })
                            
                            
                        }) { (error) in
                            print(error.localizedDescription)
                            completionHandler(false, nil)
                        }
                        
                    }
                }
               
                
                
            }
            else if let error = error {
                completionHandler(false, error)
            }
        })

    }
    
    
    func isStravaActivity(date_str: String, date_strava: Date?) -> Bool {
        
        var dateDiff: Bool = false
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
//        dateFormatter.timeZone = TimeZone(abbreviation: "GMT +9")
        let raceDate = dateFormatter.date(from: date_str)

        if let start_date = date_strava,
            let race_date = raceDate {
            
            print("start_date : \(start_date) >= race_date : \(race_date.addingTimeInterval(32400))")
            print("\(start_date.compare(race_date.addingTimeInterval(32400)).rawValue)")
            
            
            print("race_date : \(race_date.addingTimeInterval(32400)) < start_date : \(start_date.addingTimeInterval(21600))")
            print("\(start_date.compare(race_date.addingTimeInterval(54000)).rawValue)")
            
            if ((start_date.compare(race_date.addingTimeInterval(32400)).rawValue >= 0) &&
                (start_date.compare(race_date.addingTimeInterval(54000)).rawValue < 0)) {
            
                dateDiff = true
            }

        }
        
        
        return dateDiff
        
    }
    
    func isActivityinRange(date_str: String, date_strava: Date?) -> Int {
    
    
        var dateDiff: Int = 0
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        dateFormatter.timeZone = TimeZone.current
        let raceDate = dateFormatter.date(from: date_str)
        
        if let start_date = date_strava,
            let race_date = raceDate {
            
            print("start_date : \(start_date) == race_date : \(race_date)")
            dateDiff = start_date.interval(ofComponent: .day, fromDate: race_date)
        }
        

        
        
        return dateDiff
    }
    
    func getDistanceInKM(distanceInMeters: Float) -> String {
    
         let distance = distanceInMeters/1000.0
        
         return String(format: "%.2f", distance)
    }
    
    func getFormattedMovingTime(timeInSeconds: Int) -> String {
    
        let hours = timeInSeconds / 3600
        let minutes = (timeInSeconds % 3600) / 60
        let secs = timeInSeconds % 60
        
        return String(format: "%02d:%02d:%02d", hours, minutes, secs)
    }
    
    func getSpeedKMperHR(averageSpeed: Float) -> String {
    
        let kmperhr = averageSpeed * (3600.0/1000.0)
        return String(format: "%.2f", kmperhr)
    }
    
    
    func showNoActivityAlert() {
        
        let title = NSLocalizedString("Error", comment: "")
        let cancelButtonTitle = NSLocalizedString("OK", comment: "")
        
        let alertController = UIAlertController(title: title, message: "Activity not found or already added!", preferredStyle: .alert)
        
        // Create the action.
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel) { action in
            print("cancel button clicked")
        }
        
        // Add the action.
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }


}
