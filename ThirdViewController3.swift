//
//  ThirdViewController3.swift
//  Spending Tracker
//
//  Created by Takato on 2022/08/03.
//

import UIKit

// this controller is for modifying category or creating new category

class ThirdViewController3: UIViewController, UITextFieldDelegate {

    let CurrentAction = DataStore().GetCurrentAction()
    
    @IBOutlet weak var Name: UITextField!
    
    @IBOutlet weak var Goal: UITextField!
    
    @IBOutlet weak var LabelText: UILabel!
    
    var goalnotset = true
    
    var titlenotset = true
    
    var RGB = ["0","0","0","0.5"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Name.delegate = self
        Goal.delegate = self
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)

        setLabel()
        
        // cannot change the name and goal of total category
        if CurrentAction == "Modify" {
            let category = DataStore().GetCurrentCategory()
            Name.text = category
            if category == "Total" {
                Name.isUserInteractionEnabled = false
                Goal.isUserInteractionEnabled = false
            }
            Goal.text = DataStore().GetGoal(Category: category)
            
            RGB = DataStore().GetColor(Category: category)
            
            var tag = 100
            switch RGB {
            case ["255","0","0","0.5"]:
                tag = 200
            case ["0","0","255","0.5"]:
                tag = 300
            case ["0","255","0","0.5"]:
                tag = 400
            case ["255","255","0","0.5"]:
                tag = 500
            case ["255","150","0","0.5"]:
                tag = 600
            case ["150","0","255","0.5"]:
                tag = 700
            case ["0","170","190","0.5"]:
                tag = 800
            case ["255","0","150","0.5"]:
                tag = 900
            case ["130","130","0","0.5"]:
                tag = 1000
            case ["130","255","0","0.5"]:
                tag = 1100
            case ["0","0","0","0.2"]:
                tag = 1200
            default:
                tag = 100
            }
            updateColorButton(tag: tag)
        }
        
        
        // Do any additional setup after loading the view.
    }

    //displaying what user is trying to do
    func setLabel() {
        if CurrentAction == "Modify" {
            LabelText.text = "Modify Selected Category"
        }
        
        if CurrentAction == "New" {
            LabelText.text = "Create New Category"
        }
    }
    
    //color selection
    @IBAction func colorSelected(_ sender: UIButton) {
        
        updateColorButton(tag: sender.tag)
        
        switch sender.tag {
        case 200:
            RGB = ["255","0","0","0.5"]
        case 300:
            RGB = ["0","0","255","0.5"]
        case 400:
            RGB = ["0","255","0","0.5"]
        case 500:
            RGB = ["255","255","0","0.5"]
        case 600:
            RGB = ["255","150","0","0.5"]
        case 700:
            RGB = ["150","0","255","0.5"]
        case 800:
            RGB = ["0","170","190","0.5"]
        case 900:
            RGB = ["255","0","150","0.5"]
        case 1000:
            RGB = ["130","130","0","0.5"]
        case 1100:
            RGB = ["130","255","0","0.5"]
        case 1200:
            RGB = ["0","0","0","0.2"]
        default:
            RGB = ["0","0","0","0.5"]
        }
        print(RGB)
    }

    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    
    // indicator for selected color
    func updateColorButton (tag: Int) {
        for i in stride(from: 100, to: 1300, by: 100) {
            if let button = self.view.viewWithTag(i) as? UIButton {
                button.backgroundColor = UIColor.clear
            }
        }
        if let button = self.view.viewWithTag(tag) as? UIButton {
            button.backgroundColor = UIColor.gray
        }
    }
    
    
    @IBAction func SetClicked(_ sender: Any) {
        
        // Modify
        if CurrentAction == "Modify" {
            let category = DataStore().GetCurrentCategory()
            let goal = DataStore().GetGoal(Category: category)
            
            DataStore().StoreColor(Category: category, Color: RGB)
            
            // update goal if condition is met
            if let inputGoal = Goal.text {
                if inputGoal != "" {
                    goalnotset = false
                    if inputGoal != goal {
                        DataStore().StoreGoal(Category: category, Goal: inputGoal)
                        if category != "Total" {
                            let goal3 = DataStore().GetGoal(Category: category)
                            let newgoal = String(Double(DataStore().GetGoal(Category: "Total"))! - Double(goal)! + Double(goal3)!)
                            DataStore().StoreGoal(Category: "Total", Goal: newgoal)
                        }
                    }
                }
            }
            
            
            let goal2 = DataStore().GetGoal(Category: category)
            
            // update name when condition is met
            if let inputName = Name.text {
                if inputName != "" {
                    titlenotset = false
                    if inputName != category {
                        if category != "Total" {
                            DataStore().StoreColor(Category: inputName, Color: DataStore().GetColor(Category: category))
                            DataStore().StoreDataPoint(Category: inputName, TME: DataStore().GetLastExpense(Category: category))
                            DataStore().StoreListCategory(Category: inputName)
                        
                            if DataStore().GetMonths(Category: inputName).count != 1 {
                                DataStore().StoreListPastExpenses(Category: inputName, pastexpenses: DataStore().GetMonths(Category: category)[1] as! [String])
                            }
                            DataStore().StoreGoal(Category: inputName, Goal: goal2)
                    
                            let newgoal = String(Double(DataStore().GetGoal(Category: "Total"))! - Double(goal)! + Double(goal2)!)
                            DataStore().StoreGoal(Category: "Total", Goal: newgoal)
                    
                            DataStore().RemoveCategory(Category: category)
                    }
                }
                }
            }
        }
        
        // New
        if CurrentAction == "New" {
            
            if let inputName = Name.text {
                if let inputGoal = Goal.text {
                    if inputName != "" && inputGoal != "" {
                        if DataStore().GetListCategories().contains(inputName) == false {
                            titlenotset = false
                            goalnotset = false
                        
                            DataStore().StoreListCategory(Category: inputName)
                            DataStore().StoreDataPoint(Category: inputName, TME: "0")
                        
                            if DataStore().GetMonths(Category: "Total").count != 1 {
                                let pastexpenses = DataStore().GetMonths(Category: "Total")[0] as! [String]
                                let newpastexpenses = [String](repeating: "0", count: pastexpenses.count)
                                DataStore().StoreListPastExpenses(Category: inputName, pastexpenses: newpastexpenses)
                            }

                            DataStore().StoreColor(Category: inputName, Color: RGB)
                            DataStore().StoreGoal(Category: inputName, Goal: inputGoal)
                            let newgoal = String(Double(DataStore().GetGoal(Category: "Total"))! + Double(inputGoal)!)
                            DataStore().StoreGoal(Category: "Total", Goal: newgoal)
                        
                        }
                    }
                    
                }
            }
            
        }
        
        // when all conditions are met, changes will be reflected and it will go back to ThirdViewController
        if goalnotset == false && titlenotset == false {
            performSegue(withIdentifier: "greensegue", sender: sender)
        }
        else {
            let alart = UIAlertController(title: "Hey", message: "Either name or goal is not good man", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "OKAY..", style: .cancel)
            
            alart.addAction(cancelAction)

            present(alart, animated: true, completion: nil)
        }
    }
    
}
