//
//  MyRun.swift
//  iRunSeoul
//
//  Created by Hassan Abid on 17/04/2017.
//
//

import UIKit
import Firebase

class MyRun: NSObject {

    
    var uid: String
    var title: String
    var city: String
    var date: String
    var host: String
    var latitude: String
    var location: String
    var longitude: String
    var map_url: String
    var temperature: String
    var weather: String
    var website: String
    
    var run_app: String
    var run_id: String
    var run_name: String
    var distance: String
    var moving_time: String
    var start_date: String
    var start_date_local: String
    var average_speed: String
    var type: String
    var photo_url: String
    
    init(uid: String, title: String, city: String, date: String,
         host: String, latitude: String, location: String, longitude: String, map_url: String,
         temperature: String, weather: String, website: String,
         run_app: String, run_id: String, run_name: String, distance: String, moving_time: String,
         start_date: String, start_date_local: String, average_speed: String, type: String, photo_url: String) {
        
        self.uid = uid
        self.title = title
        self.city = city
        self.date = date
        self.host = host
        self.latitude = latitude
        self.location = location
        self.longitude = longitude
        self.map_url = map_url
        self.temperature = temperature
        self.weather = weather
        self.website = website
        
        self.run_app = run_app
        self.run_id = run_id
        self.run_name = run_name
        self.distance = distance
        self.moving_time = moving_time
        self.start_date = start_date
        self.start_date_local = start_date_local
        self.average_speed = average_speed
        self.type = type
        self.photo_url = photo_url
    }
    
    init?(snapshot: DataSnapshot) {
        
        guard let dict = snapshot.value as? [String: AnyObject] else { return nil }
        guard let uid = dict["uid"] else { return nil }
        guard let city = dict["city"] else { return nil }
        guard let host = dict["host"] else { return nil }
        guard let title = dict["title"] else { return nil }
        guard let date = dict["date"] else { return nil }
        guard let latitude = dict["latitude"] else { return nil }
        guard let location = dict["location"] else { return nil }
        guard let longitude = dict["longitude"] else { return nil }
        guard let map_url = dict["map_url"] else { return nil }
        guard let temperature = dict["temperature"] else { return nil }
        guard let weather = dict["weather"] else { return nil }
        guard let website = dict["website"] else { return nil }
        
        guard let run_app = dict["run_app"] else { return nil }
        guard let run_id = dict["run_id"] else { return nil }
        guard let run_name = dict["run_name"] else { return nil }
        guard let distance = dict["distance"] else { return nil }
        guard let moving_time = dict["moving_time"] else { return nil }
        guard let start_date = dict["start_date"] else { return nil }
        guard let start_date_local = dict["start_date_local"] else { return nil }
        guard let average_speed = dict["average_speed"] else { return nil }
        guard let type = dict["type"] else { return nil }
        guard let photo_url = dict["photo_url"] else { return nil }
        
        self.uid = uid as! String
        self.title = title as! String
        self.city = city as! String
        self.date = date as! String
        self.host = host as! String
        self.latitude = latitude as! String
        self.location = location as! String
        self.longitude = longitude as! String
        self.map_url = map_url as! String
        self.temperature = temperature as! String
        self.weather = weather as! String
        self.website = website as! String
        
        self.run_app = run_app as! String
        self.run_id = run_id as! String
        self.run_name = run_name as! String
        self.distance = distance as! String
        self.moving_time = moving_time as! String
        self.start_date = start_date as! String
        self.start_date_local = start_date_local as! String
        self.average_speed = average_speed as! String
        self.type = type as! String
        self.photo_url = photo_url as! String

    }
    
    convenience override init() {
        
        self.init(uid: "", title: "", city: "", date: "",
                  host: "", latitude: "",
                  location: "", longitude: "", map_url: "",
                  temperature: "", weather: "", website: "",
                  run_app: "", run_id: "", run_name: "", distance: "", moving_time: "",
                  start_date: "", start_date_local: "", average_speed: "",
                  type: "", photo_url: "")
    }



}
