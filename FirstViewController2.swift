//
//  FirstViewController2.swift
//  Spending Tracker
//
//  Created by Takato on 2022/08/03.
//

import UIKit

// This controller is for selecting the category user wants to update

class FirstViewController2: UIViewController,  UITableViewDataSource, UITableViewDelegate {

    var ListCategories = DataStore().GetListCategories()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Resigtering cells in table
        tableView.register(MyTableViewCell.nib(), forCellReuseIdentifier: MyTableViewCell.identifier)
        self.tableView.dataSource = self
        self.tableView.delegate = self

    }
    
    // setting up table of category
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ListCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: MyTableViewCell.identifier, for: indexPath) as! MyTableViewCell
        
        let category = ListCategories[indexPath.row]
        
        // setting color stored to each corresponding category
        let R = Double(DataStore().GetColor(Category: category)[0])!
        let G = Double(DataStore().GetColor(Category: category)[1])!
        let B = Double(DataStore().GetColor(Category: category)[2])!
        let alpha = Double(DataStore().GetColor(Category: category)[3])!
        cell.backgroundColor = UIColor(red: R/255, green: G/255, blue: B/255, alpha: alpha)
        
        // setting text label
        cell.textLabel?.text = category
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = UIFont(name: "Baby Doll", size: 20)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = ListCategories[indexPath.row]
        
        // store which category is selected and perform segue to FirstViewController 1
        DataStore().StoreCurrentCategory(Category: category)
        print(category)
        performSegue(withIdentifier: "segue1", sender: self)
   }
    

}


