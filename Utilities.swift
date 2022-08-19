//
//  Utilities.swift
//  Spending Tracker
//
//  Created by Takato on 2022/07/08.
//

import Foundation

class Utilities {
    
    // for displaying on the main screen
    func GetCurrentDate () -> String {
        let now = Date.now
        let date = now.formatted(date: .numeric, time: .omitted)
        
        return date
    }
    
    // for the algorithm (extracting only the day of now
    func GetCurrentDay () -> String {
        let date = Date()
        let calender = Calendar.current
        
        return String(calender.component(.day, from: date))
    }
    
    // for the algorithm (extracting only the month of now
    func GetCurrentMonth () -> String {
        let date = Date()
        let calender = Calendar.current
        
        return String(calender.component(.month, from: date))
    }
    
    // for the algorithm (extracting only the year of now
    func GetCurrentYear () -> String {
        let date = Date()
        let calender = Calendar.current
        
        return String(calender.component(.year, from: date))
    }
}


