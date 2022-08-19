//
//  ThridViewController2.swift
//  Spending Tracker
//
//  Created by Takato on 2022/08/03.
//

import UIKit

// This controller is for showing which action to take for which category

class ThridViewController2: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var ListCategories = DataStore().GetListCategories()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var Remove: UIButton!
    
    @IBOutlet weak var Modify: UIButton!
    
    @IBOutlet weak var New: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register custom cell for table of categories
        tableView.register(MyTableViewCell.nib(), forCellReuseIdentifier: MyTableViewCell.identifier)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    // setting up table
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ListCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: MyTableViewCell.identifier, for: indexPath) as! MyTableViewCell
        
        // assign corresponding color to each category
        let category = ListCategories[indexPath.row]
        let R = Double(DataStore().GetColor(Category: category)[0])!
        let G = Double(DataStore().GetColor(Category: category)[1])!
        let B = Double(DataStore().GetColor(Category: category)[2])!
        let alpha = Double(DataStore().GetColor(Category: category)[3])!
        cell.backgroundColor = UIColor(red: R/255, green: G/255, blue: B/255, alpha: alpha)
        
        // setting corresponding text to each category
        cell.textLabel?.text = category
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = UIFont(name: "Baby Doll", size: 20)
        return cell
    }
    
    // when category is tapped store the selected category in userdefault
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = ListCategories[indexPath.row]
        DataStore().StoreCurrentCategory(Category: category)
        print(category)
   }

    // When remove is clicked, warning appears
    @IBAction func RemoveClicked(_ sender: Any) {
        let category = DataStore().GetCurrentCategory()
        
        // User cannot remove total category
        if category == "Total" {
            let alart = UIAlertController(title: "Hey", message: "You can't really remove \(category)?", preferredStyle: .alert)

            let cancelAction = UIAlertAction(title: "OKAY..", style: .cancel)

            alart.addAction(cancelAction)

            present(alart, animated: true, completion: nil)
        }
        
        // if not total, present warning and proceed
        let alart = UIAlertController(title: "Hey", message: "Do you really want to remove \(category)?", preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let saveAction = UIAlertAction(title: "Yes!", style: .default) { _ in

            // this code runs when the user hits the "save" button
            DataStore().RemoveCategory(Category: category)
            DataStore().StoreCurrentCategory(Category: "Total")
            self.performSegue(withIdentifier: "greensegue1", sender: sender)
            }
        
        alart.addAction(saveAction)
        alart.addAction(cancelAction)

        present(alart, animated: true, completion: nil)
        }
        
    // When modify or new is clicked, store current action and move to ThridViewController 3
    @IBAction func ModifyClicked(_ sender: Any) {
        DataStore().StoreCurrentAction(Action: "Modify")
    }
    
    @IBAction func NewClicked(_ sender: Any) {
        DataStore().StoreCurrentAction(Action: "New")
    }
    
    
    
}


