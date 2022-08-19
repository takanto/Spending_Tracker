//
//  FirstViewController.swift
//  Spending Tracker
//
//  Created by Takato on 2022/07/06.
//



import UIKit

// This controller is the main page of the app showing date, total expense

class FirstViewController: UIViewController {

    
    @IBOutlet weak var Expense: UILabel!
    
    @IBOutlet weak var CurrentDate: UILabel!
    
    @IBOutlet weak var ImageView: UIImageView!
    
    @IBOutlet weak var BuddyImageView: UIImageView!
    
    var state = monthlyupdate.NotUpdated
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // if there's no category, create default category 'Total'
        if DataStore().GetListCategories() == [] {
            DataStore().StoreListCategory(Category: "Total")
            DataStore().StoreDataPoint(Category: "Total", TME: "0")
            DataStore().StoreGoal(Category: "Total", Goal: "0")
            DataStore().StoreCurrentCategory(Category: "Total")
            DataStore().StoreColor(Category: "Total", Color: ["0","0","0","0.5"])
        }
        

        UpdateMonthly()
        
        displayResizedImage()
        
        displayCurrentExpense()
        

    }
    
    // override viewDidAppear for refreshing displays
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(true)
                
        UpdateMonthly()
        
        displayResizedImage()
        
        displayCurrentExpense()
        
    }
    
    // seague after adding or subtracting expense
    @IBAction func bluesegue(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
                 DispatchQueue.main.async {
                     self.loadView()
                     self.viewDidLoad()
                 }
             }
    }
    
    // display current total expense
    func displayCurrentExpense() {
        CurrentDate.text = Utilities().GetCurrentDate()
        
        let oldexpense = DataStore().GetLastExpense(Category: "Total")
        Expense.text = oldexpense
        print(oldexpense)
    }
    
    // Update the goal, expense, and store the data of last month in UserDefaults
    func UpdateMonthly () {
        
        if Utilities().GetCurrentDay() == "1" && state == monthlyupdate.NotUpdated {
            // appending the lendgers
            
            var month = String(Int(Utilities().GetCurrentMonth())! - 1)
            var year = Utilities().GetCurrentYear()
            
            // adjusting for january
            if month == "0"{
                month = "12"
                year = String(Int(year)! - 1)
            }
            
            let storedmonth = year + "." + month
            
            DataStore().StoreMonths(month: storedmonth)
            
            let listcategories = DataStore().GetListCategories()
            for i in 0..<listcategories.count {
                let oldexpense = DataStore().GetLastExpense(Category: listcategories[i])
                DataStore().StorePastExpenses(Category: listcategories[i], pastexpense: oldexpense)
                
                // Reset the goal and the oldexpense
                DataStore().StoreDataPoint(Category: listcategories[i],TME: "0")
                DataStore().StoreGoal(Category: listcategories[i], Goal: "0")
            }
            
            
            // It's updated so that it won't keep updating on the same day
            state = monthlyupdate.Updated
        }
        else if Utilities().GetCurrentDay() == "2" {
            
            // Putting it back to not updated for the next month
            state = monthlyupdate.NotUpdated
            
        }
    }
    
    
    // resizing the image of the weight according to total expense/goal
    func resizeImage (image: UIImage, ratio: Double) -> UIImage? {
        let size = image.size
        let newheight = size.height * ratio
        
        var newsize : CGSize
        if newheight <= 200 {
            newsize = CGSize(width: size.width * ratio, height: size.height * ratio)
        }
        else {
            newsize = CGSize(width: 200, height: 200)
        }
        
        let rect = CGRect(origin: .zero, size: newsize)
        
        UIGraphicsBeginImageContextWithOptions(newsize, false, 1.0)
            image.draw(in: rect)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return newImage
    }
    
    // change the image of buddy to reflect how heavy the spending has become
    func buddyImage (ratio: Double) -> UIImage? {
        if ratio == 0 {
            return UIImage(named:"Cool Buddy")
        }
        if 0.01 <= ratio && ratio <= 0.5 {
            return UIImage(named:"Easy Buddy")
        }
        if 0.51 <= ratio && ratio <= 0.75 {
            return UIImage(named:"Medium Buddy")
        }
        if 0.76 <= ratio && ratio <= 0.99 {
            return UIImage(named:"Hard Buddy")
        }
        return UIImage(named:"Dead Buddy")
    }
    
    // display resized images
    func displayResizedImage () {
        var ratio: Double
        
        if DataStore().GetGoal(Category: "Total") == "0" {
            ratio = 0
        }
        else {
            ratio = Double(DataStore().GetLastExpense(Category: "Total"))! / Double(DataStore().GetGoal(Category: "Total"))!
            
        }
        
        let resized = resizeImage(image: UIImage(named: "Guilt.png")!, ratio: ratio)
        
        ImageView.image = resized
        ImageView.contentMode = .bottom
        BuddyImageView.image = buddyImage(ratio: ratio)
    }
}
