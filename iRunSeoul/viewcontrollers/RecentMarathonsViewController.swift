//
//  RecentMarathonsViewController.swift
//  iRunSeoul
//
//  Created by Hassan Abid on 18/04/2017.
//
//

import UIKit
import Firebase


class RecentMarathonsViewController: MarathonListViewController {
    
    
    override func getQuery() -> FIRDatabaseQuery {

        var date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        
        date.addTimeInterval(-345600)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let current_date = formatter.string(from: date)
        
        print("date : \(date) year: \(year) day: \(day) month: \(month) current_date: \(current_date)")
        
        if(self.isNewEventFilter) {
            return (ref?.child("event").child("\(year)").queryOrdered(byChild: "date").queryStarting(atValue: current_date))!
        } else {
        
            return (ref?.child("event").child("\(year)").queryOrdered(byChild: "date").queryStarting(atValue: "2017/01/01 08:00").queryEnding(atValue:current_date))!
        }
        
        
    }
    
    

}
