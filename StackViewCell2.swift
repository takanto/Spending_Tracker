//
//  StackViewCell2.swift
//  Spending Tracker
//
//  Created by Takato on 2022/08/05.
//

import UIKit

class StackViewCell2: UIView {

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
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
    }


}
