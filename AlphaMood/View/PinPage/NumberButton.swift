//
//  NumberButton.swift
//  AlphaMood
//
//  Created by Абылайхан on 7/27/19.
//  Copyright © 2019 Абылайхан. All rights reserved.
//

import UIKit

class NumberButton: UIButton {

    var path: UIBezierPath!
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)
        let shape = CAShapeLayer()
        self.path = UIBezierPath(ovalIn: rect)
        shape.path = path.cgPath
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeColor = UIColor.black.cgColor
        self.layer.addSublayer(shape)
        
    }
    
    
    
 
    

}
