//
//  Event.swift
//  iRunSeoul
//
//  Created by Hassan Abid on 17/04/2017.
//
//

import UIKit
import Firebase

class Event: NSObject {

    var title: String
    var city: String
    var date: String
    var email: String
    var host: String
    var application_period: String
    var latitude: String
    var location: String
    var longitude: String
    var map_url: String
    var phone: String
    var temperature: String
    var weather: String
    var website: String
    var race: NSArray
    var event_description: String
    
    init(title: String, city: String, date: String,
         email: String, host: String,  application_period: String, latitude: String,
         location: String, longitude: String, map_url: String, phone: String,
         temperature: String, weather: String, website: String,
         race: NSArray, event_description: String) {
        
        self.title = title
        self.city = city
        self.date = date
        self.email = email
        self.host = host
        self.application_period = application_period
        self.latitude = latitude
        self.location = location
        self.longitude = longitude
        self.map_url = map_url
        self.phone = phone
        self.temperature = temperature
        self.weather = weather
        self.website = website
        self.race = race
        self.event_description = event_description
    }
    
    init?(snapshot: DataSnapshot) {
        
        guard let dict = snapshot.value as? [String: AnyObject] else { return nil }
        guard let title = dict["title"] else { return nil }
        guard let city = dict["city"] else { return nil }
        guard let date = dict["date"] else { return nil }
        guard let email = dict["email"] else { return nil }
        guard let host = dict["host"] else { return nil }
        guard let application_period = dict["application_period"] else { return nil }
        guard let latitude = dict["latitude"] else { return nil }
        guard let location = dict["location"] else { return nil }
        guard let longitude = dict["longitude"] else { return nil }
        guard let map_url = dict["map_url"] else { return nil }
        guard let phone = dict["phone"] else { return nil }
        guard let temperature = dict["temperature"] else { return nil }
        guard let weather = dict["weather"] else { return nil }
        guard let website = dict["website"] else { return nil }
        guard let race = dict["race"] else { return nil }
        guard let event_description = dict["description"] else { return nil }
        
        self.title = title as! String
        self.city = city as! String
        self.date = date as! String
        self.email = email as! String
        self.host = host as! String
        self.application_period = application_period as! String
        self.latitude = latitude as! String
        self.location = location as! String
        self.longitude = longitude as! String
        self.map_url = map_url as! String
        self.phone = phone as! String
        self.temperature = temperature as! String
        self.weather = weather as! String
        self.website = website as! String
        self.race = race as! NSArray
        self.event_description = event_description as! String
    }
    
    convenience override init() {
        
        self.init(title: "", city: "", date: "",
                   email: "", host: "",  application_period: "", latitude: "",
                   location: "", longitude: "", map_url: "", phone: "",
                   temperature: "", weather: "", website: "",
                   race: [""], event_description: "")
    }


}
