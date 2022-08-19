//
//  FirstViewController1.swift
//  Spending Tracker
//
//  Created by Takato on 2022/07/06.
//

import UIKit

// This controller is for adding and subtracting expense of chosen category

class FirstViewController1: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    
    var category = DataStore().GetCurrentCategory()
    
    @IBOutlet weak var CategoryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // show which category is chosen from the table of category
        CategoryLabel.text = category

    }
    
    // When number pads are clicked, it updates the resultLabel accordingly
    @IBAction func numberClicked(_ sender: UIButton) {
        UpdateDisplay(number: String(sender.tag))
    }
    
    func UpdateDisplay (number: String) {
        if let num = resultLabel.text {
            if num != "" {
                resultLabel.text! += number
            }
            else {
                resultLabel.text = number
            }
        }
    }
    
    // clear button to delete the most recently typed character
    @IBAction func clearClicked(_ sender: Any) {
        if let num = resultLabel.text {
            if num != "" {
                resultLabel.text!.removeLast()
            }
            else {
                return
            }
        }
    }
    
    // When this button is pushed, it will affect the total expense of the month
    @IBAction func plusminusClicked(_ sender: UIButton) {
        if let num = resultLabel.text {
            if num != "" {
                let oldexpense = DataStore().GetLastExpense(Category: category)
                let oldexpensetotal = DataStore().GetLastExpense(Category: "Total")
                var newexpense: String
                var newexpensetotal: String
                
                switch sender.tag {
                case 10:
                    newexpense = String(Double(oldexpense)! - Double(num)!)
                    newexpensetotal = String(Double(oldexpensetotal)! - Double(num)!)
                    DataStore().StoreDataPoint(Category: category, TME: newexpense)
                    DataStore().StoreDataPoint(Category: "Total", TME: newexpensetotal)
                    
                default :
                    newexpense = String(Double(oldexpense)! + Double(num)!)
                    newexpensetotal = String(Double(oldexpensetotal)! + Double(num)!)
                    DataStore().StoreDataPoint(Category: category, TME: newexpense)
                    DataStore().StoreDataPoint(Category: "Total", TME: newexpensetotal)
                }
                
                // go back to the main page after valid addition 
                performSegue(withIdentifier: "bluesegue", sender: sender)
                
            }
            else {
                return
            }
        }
    
    }

}
