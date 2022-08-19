//
//  SecondViewController.swift
//  Spending Tracker
//
//  Created by Takato on 2022/07/06.
//
// iOS Chart or any chart come here with the scroll view and stack view.

import UIKit
import Charts

// This controller displays charts showing monthly expenses for each category alongside with goals and expected spending of the month

class SecondViewController: UIViewController {
    
    @IBOutlet weak var StackView: UIStackView!
    
    @IBOutlet weak var TitleView: UIView!
    
    var newView: UIView!
    
    var chartcount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewSetUp()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    // Setting up charts of all the categories
    func viewSetUp() {
        
        let getlistCategories = DataStore().GetListCategories()
        print(chartcount,getlistCategories.count)
        
        // Removing what's in the stack view (extention added at the end)
        StackView.removeAllArrangedSubviews()
        
        // Title view
        let titleView = StackViewCell()
        titleView.label.text = "Charts"
        titleView.label.sizeToFit()
        titleView.label.textColor = UIColor.black
        titleView.label.font = UIFont(name: "Baby Doll", size: 40)
        titleView.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        titleView.translatesAutoresizingMaskIntoConstraints = false
        
        StackView.addArrangedSubview(titleView)
        
        // Loop trough the list of categories and generate chart
        if getlistCategories.count != 0 {
            for i in 0..<getlistCategories.count {
                let category = getlistCategories[i]
            
                // set subtitle view showing the name of the category
                let subtitleview = StackViewCell2()
                subtitleview.label.text = category + ":"
                subtitleview.label.sizeToFit()
                subtitleview.label.textColor = UIColor.black
                subtitleview.label.font = UIFont(name: "Baby Doll", size: 20)
                subtitleview.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
                subtitleview.translatesAutoresizingMaskIntoConstraints = false
                
                StackView.addArrangedSubview(subtitleview)
                
                // generating chart
                // if there's no previous months stored, it cannot refer to the past data so the algorithm is different
                if DataStore().GetMonths(Category: category).count == 1 {
                    var month = String(Int(Utilities().GetCurrentMonth())! - 1)
                    var year = Utilities().GetCurrentYear()
                
                    // adjusting for january
                    if month == "0"{
                        month = "12"
                        year = String(Int(year)! - 1)
                    }
                
                    let storedmonth = year + "." + month
                    newView = createChart(months: [storedmonth], expenses: ["0"], goal: DataStore().GetGoal(Category: category), category: category)
                    StackView.addArrangedSubview(newView)
                    chartcount += 1
                }
                else {
                    newView = createChart(months: DataStore().GetMonths(Category: category)[0] as! [String], expenses: DataStore().GetMonths(Category: category)[1] as! [String], goal:DataStore().GetGoal(Category: category), category: category)
                    StackView.addArrangedSubview(newView)
                    chartcount += 1
                }
            }
        }
        
        // Adding mascot at the bottom of the page
        let buddyview = UIImageView()
        buddyview.image = UIImage(named: "Cool Buddy")
        buddyview.contentMode = .scaleAspectFit
        buddyview.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        buddyview.translatesAutoresizingMaskIntoConstraints = false
        
        StackView.addArrangedSubview(buddyview)
        
        // Adding blank cell for better UI
        let blankview = StackViewCell()
        blankview.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        blankview.translatesAutoresizingMaskIntoConstraints = false
        
        StackView.addArrangedSubview(blankview)
    }
    
    // create chart using the list of past expenses for each category
    private func createChart (months: [String], expenses: [String], goal:String, category: String) -> UIView{

        // creating views
        let window = UIView()
        window.heightAnchor.constraint(equalToConstant: 280.0).isActive = true
        window.translatesAutoresizingMaskIntoConstraints = false
        let barChart = BarChartView(frame: CGRect(x: 20, y: 20, width: 300, height: 250))
        
        var entries = [BarChartDataEntry] ()
        var colors = [UIColor] ()
        
        // Getting the colors sorted and getting data points from userdefault
        for i in 0..<months.count {
            entries.append(BarChartDataEntry(x: Double(months[i])!, y: Double(expenses[i])!))
            let R = Double(DataStore().GetColor(Category: category)[0])!
            let G = Double(DataStore().GetColor(Category: category)[1])!
            let B = Double(DataStore().GetColor(Category: category)[2])!
            let alpha = Double(DataStore().GetColor(Category: category)[3])!
            colors.append(UIColor(red: R/255, green: G/255, blue: B/255, alpha: alpha))
        }
        
        // Merging past expenses to current expense
        let currentYearMonth = Utilities().GetCurrentYear() + "." + Utilities().GetCurrentMonth()
        let currentexpense = DataStore().GetLastExpense(Category: category)
        let entriesToday = [BarChartDataEntry(x: Double(currentYearMonth)!, y: Double(currentexpense)!)]
        colors.append(UIColor.black)
        
        let set = BarChartDataSet(entries: entries, label:"Monthly Expense")
        let setToday = BarChartDataSet(entries: entriesToday, label:"This month")
        let setAll = set + setToday
        setAll.colors = colors
        
        // Setting up data, constraints, and display options
        let data = BarChartData(dataSet: setAll)
        data.barWidth = 0.05
        
        barChart.rightAxis.enabled = false
        barChart.xAxis.labelPosition = .bottom
        barChart.xAxis.axisMinimum = Double(months[0])! - 0.1
        barChart.xAxis.axisMaximum = Double(months[months.count - 1])! + 0.2
        barChart.xAxis.setLabelCount(months.count + 3, force: true)
        barChart.xAxis.drawGridLinesEnabled = false
        barChart.data = data
        
        barChart.leftAxis.axisMinimum = 0
        
        barChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        
        
        // adding goal line
        let limitline = ChartLimitLine(limit: Double(goal)!,label:"goal"+goal)
        limitline.lineDashLengths = [3.0]
        limitline.label = "Goal:" + goal
        limitline.valueFont = UIFont(name: "Baby Doll", size: 15)!
        limitline.lineColor = UIColor.black
        
        // adding projected expense line
        let projectedExpense = (Double(DataStore().GetLastExpense(Category: category))! * 30) / Double(Utilities().GetCurrentDay())!
        let limitline2 = ChartLimitLine(limit: projectedExpense ,label:"projected expese:"+String(projectedExpense.rounded(.up)))
        limitline2.lineDashLengths = [3.0]
        limitline2.label = "Projected Expese:" + String(projectedExpense.rounded(.up))
        limitline2.valueFont = UIFont(name: "Baby Doll", size: 15)!
        
        // setting the height by the hightest line drawn
        var biggerline: Double
        
        if projectedExpense > Double(goal)! {
            limitline.labelPosition = .bottomRight
            limitline2.lineColor = UIColor.red
            biggerline = projectedExpense
        }
        else {
            limitline2.labelPosition = .bottomRight
            limitline2.lineColor = UIColor.green
            biggerline = Double(goal)!
        }
        
        barChart.leftAxis.addLimitLine(limitline)
        barChart.leftAxis.addLimitLine(limitline2)
        
        let allExpenses = expenses + [DataStore().GetLastExpense(Category: category)]
        var largest = 0.0
        for item in allExpenses {
            if Double(item)! > largest {
                largest = Double(item)!
            }
        }
        
        if biggerline > largest {
            barChart.leftAxis.axisMaximum = projectedExpense * 1.1
        }
        
        
        // setting up fonts
        barChart.xAxis.labelFont = UIFont(name: "Baby Doll", size: 10)!
        barChart.leftAxis.labelFont = UIFont(name: "Baby Doll", size: 10)!
        barChart.legend.font = UIFont(name: "Baby Doll", size: 10)!
        data.setValueFont(UIFont(name: "Baby Doll", size: 10)!)

        // returning window
        window.addSubview(barChart)
        
        return window
        
        
    }


}

extension UIStackView {
    
    func removeAllArrangedSubviews() {
        
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        
        // Deactivate all constraints
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        
        // Remove the views from self
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}
