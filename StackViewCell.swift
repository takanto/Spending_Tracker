//
//  StackViewCell.swift
//  Spending Tracker
//
//  Created by Takato on 2022/08/05.
//

import UIKit

// Setting constraints for stack view for ios Charts

class StackViewCell: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    let label = UILabel()
    
    init() {
        super.init(frame: CGRect())
        
        addSubview(label)
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor, constant: 60).isActive = true
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
    }

}
