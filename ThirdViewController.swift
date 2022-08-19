//
//  ThirdViewController.swift
//  Spending Tracker
//
//  Created by Takato on 2022/07/06.
//

import UIKit

// This controller is for settings

class ThirdViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // setting up seague for coming back here after changing setting
    @IBAction func greensegue(segue: UIStoryboardSegue) {
    }
    
    // When Buddy name's changed
    @IBAction func BuddyNameClicked(_ sender: Any) {
        let alart = UIAlertController(title: "Hey", message: "Set your buddy's name", preferredStyle: .alert)
        
        alart.addTextField { (textField) in
            textField.placeholder = "Buddy's name"
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in

            // this code runs when the user hits the "save" button

            // if there is any input, store it in the goal
            if let inputName = alart.textFields![0].text {
                if inputName != "" {
                    DataStore().StoreBuddyName(Buddy: inputName)
                }
                else {
                    DataStore().StoreBuddyName(Buddy: "0")
                }
            }
        }
        
        alart.addAction(saveAction)
        alart.addAction(cancelAction)

        present(alart, animated: true, completion: nil)
    }
}
