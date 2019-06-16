//
//  BackgroundStackView.swift
//  CheckThatIn
//
//  Created by Vladimir Vetrov on 16/06/2019.
//  Copyright © 2019 Vladimir. All rights reserved.
//

import UIKit

class BackgroundStackView: UIStackView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        let subView = UIView(frame: bounds)
        subView.backgroundColor = UIColor(hexString: "#e5e5ea")
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        subView.layer.cornerRadius = 8
        insertSubview(subView, at: 0)
    }
    

}
