//
//  DataStore.swift
//  Spending Tracker
//
//  Created by Takato on 2022/07/07.
//

import Foundation
import Metal

// Data store is for managing userdefaults (can be updated to Firebase)

struct StorageKeys {
    
    // This's month current expense
    static let TME = "ThisMonthExpense"
    
    // This month's goal set
    static let Goal = "ThisMonthGoal"
    
    // months spent by the user (array)
    static let months = "months"
    
    // corresponding expenses in the past (array)
    static let pastepenses = "pastexpenses"
    
    // buddy name
    static let BuddyName = "BuddyName"
    
    // category we are looking at
    static let CurrrentCategory = "CurrentCategory"
    
    // list of category color pallets
    static let Color = "Color"
    
    // list of categories
    static let ListCategories = "ListCategories"
    
    // New or Modify
    static let CurrentAction = "CurrentAction"
    
}

class DataStore {
    
    func GetUserDefaults () -> UserDefaults {
        return UserDefaults.standard
    }
    
    //
    // Storing data
    //
    
    
    // Store currently selected category
    func StoreCurrentCategory (Category: String) {
        let def = GetUserDefaults()
        
        def.setValue(Category, forKey: StorageKeys.CurrrentCategory)
        def.synchronize()
    }
    
    // Store list of category
    func StoreListCategory (Category: String) {
        let def = GetUserDefaults()
        
        var categories = def.array(forKey: StorageKeys.ListCategories) as? [String] ?? []
        if categories.contains(Category) == false {
            categories.append(Category)
        }
        def.set(categories, forKey: StorageKeys.ListCategories)
    }
    
    // Store colors corresponding to each category
    func StoreColor (Category: String, Color: [String]) {
        let def = GetUserDefaults()
        
        var strings = def.object(forKey: StorageKeys.Color) as? [String:[String]] ?? [:]
        strings[Category] = Color
        def.set(strings, forKey: StorageKeys.Color)
    }
    
    // Stores this month's current expense
    func StoreDataPoint (Category: String, TME: String) {
        let def = GetUserDefaults()
        
        var strings = def.object(forKey: StorageKeys.TME) as? [String:String] ?? [:]
        strings[Category] = TME
        def.set(strings, forKey: StorageKeys.TME)
        // def.setValue(TME, forKey: StorageKeys.TME)
        // def.synchronize()
    }
    
    // Stores this month's goal
    func StoreGoal (Category: String, Goal: String) {
        let def = GetUserDefaults()
        
        var strings = def.object(forKey: StorageKeys.Goal) as? [String:String] ?? [:]
        strings[Category] = Goal
        def.set(strings, forKey: StorageKeys.Goal)
        //def.setValue(Goal, forKey: StorageKeys.Goal)
        //def.synchronize()
    }
    
    // Stores the months for charts
    func StoreMonths (month: String) {
        let def = GetUserDefaults()
        
        var months = def.array(forKey: StorageKeys.months) as? [String] ?? []
        months.append(month)
        def.set(months, forKey: StorageKeys.months)
    }
    
    // Store past expense
    func StorePastExpenses (Category: String, pastexpense: String) {
        let def = GetUserDefaults()
        
        var strings = def.object(forKey: StorageKeys.pastepenses) as? [String:[String]] ?? [:]
        strings[Category]?.append(pastexpense)
        def.set(strings, forKey: StorageKeys.pastepenses)
    }
    
    // Store List of past expenses for charts
    func StoreListPastExpenses(Category: String, pastexpenses: [String]){
        let def = GetUserDefaults()
        
        var strings = def.object(forKey: StorageKeys.pastepenses) as? [String:[String]] ?? [:]
        strings[Category]? = pastexpenses
        def.set(strings, forKey: StorageKeys.pastepenses)
    }
    
    // Store Buddy Name
    func StoreBuddyName (Buddy: String) {
        let def = GetUserDefaults()
        
        def.setValue(Buddy, forKey: StorageKeys.BuddyName)
        def.synchronize()
    }
    
    // Store current action (new/modify)
    func StoreCurrentAction (Action: String) {
        let def = GetUserDefaults()
        
        def.setValue(Action, forKey: StorageKeys.CurrentAction)
        def.synchronize()
    }
    
    //
    // Getting Stored Data
    //
    
    // Get currently selected category
    func GetCurrentCategory () -> String {
        let def = GetUserDefaults()
        
        if let category = def.string(forKey: StorageKeys.CurrrentCategory) {
            return category
        }
        else {
            return "0"
        }
    }
    
    // Get current list of categories stored
    func GetListCategories() -> [String] {
        let def = GetUserDefaults()
        
        if let categories = def.array(forKey: StorageKeys.ListCategories) as? [String] {
            return categories
        }
        else {
            return []
        }
    }
    
    // get corresponding stored color of a category
    func GetColor (Category:String) -> [String] {
        let def = GetUserDefaults()
        
        if let colors = def.object(forKey: StorageKeys.Color) as? [String:[String]] {
            if let color = colors[Category] {
                return color
            }
            else {
                return ["0","0","0","0.5"]
            }
        }
        else {
            return ["0","0","0","0.5"]
        }
    }
    
    // Get this month's current expense
    func GetLastExpense (Category:String) -> String {
        let def = GetUserDefaults()
        
        if let lastexpense = def.object(forKey: StorageKeys.TME) as? [String:String] {
            if let expense = lastexpense[Category] {
                return expense
            }
            else {
                return "0"
            }
        }
        else {
            return "0"
        }
    }
    
    // Get this month's current goal
    func GetGoal (Category: String) -> String {
        let def = GetUserDefaults()
        
        if let lastgoal = def.object(forKey: StorageKeys.Goal) as? [String:String] {
            if let goal = lastgoal[Category] {
                return goal
            }
            else {
                return "0"
            }
        }
        else {
            return "0"
        }
    }
    
    // Get the past expenses as set of arrays
    func GetMonths (Category: String) -> [Any] {
        let def = GetUserDefaults()
        
        if let months = def.array(forKey: StorageKeys.months) {
            if let pastexpenses = def.object(forKey: StorageKeys.pastepenses) as? [String:[String]] {
                if let expenses = pastexpenses[Category] {
                    return [months, expenses]
                }
            }
        }
        return ["Not Found"]
    }
    
    // get buddy name
    func GetBuddyName () -> String {
        let def = GetUserDefaults()
        
        if let name = def.string(forKey: StorageKeys.BuddyName) {
            return name
        }
        else {
            return "0"
        }
    }
    
    // Get current action
    func GetCurrentAction () -> String {
        let def = GetUserDefaults()
        
        if let name = def.string(forKey: StorageKeys.CurrentAction) {
            return name
        }
        else {
            return "New"
        }
    }
    
    //
    //Removal of category
    //
    
    func RemoveCategory (Category: String) {
        let def = GetUserDefaults()
        
        // removing color
        var colors = def.object(forKey: StorageKeys.Color) as? [String:[String]] ?? [:]
        colors[Category] = nil
        def.set(colors, forKey: StorageKeys.Color)
        
        // removing category from current expense
        var strings = def.object(forKey: StorageKeys.TME) as? [String:String] ?? [:]
        strings[Category] = nil
        def.set(strings, forKey: StorageKeys.TME)
        
        // removing category for goal
        var goals = def.object(forKey: StorageKeys.Goal) as? [String:String] ?? [:]
        goals[Category] = nil
        def.set(goals, forKey: StorageKeys.Goal)
        
        // removing past expenses the category
        var expenses = def.object(forKey: StorageKeys.pastepenses) as? [String:[String]] ?? [:]
        expenses[Category] = nil
        def.set(expenses, forKey: StorageKeys.pastepenses)
        
        // removing it from list of categories
        var categories = def.array(forKey: StorageKeys.ListCategories) as? [String] ?? []
        categories = categories.filter(){$0 != Category}
        def.set(categories, forKey: StorageKeys.ListCategories)

    }
    
    
    // checks whether anything is stored in a key in User defaults
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        let def = GetUserDefaults()
        return def.object(forKey: key) != nil
    }
}
