//
//  CircleView.swift
//  AlphaMood
//
//  Created by Абылайхан on 7/27/19.
//  Copyright © 2019 Абылайхан. All rights reserved.
//

import UIKit

@IBDesignable
class CircleView: UIView {

    var shape: CAShapeLayer!
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
        addSublayer(with: .clear)
    }
    
    func addSublayer(with: UIColor) {
        self.shape = CAShapeLayer()
        shape.path = UIBezierPath(ovalIn: self.bounds).cgPath
        drawShape(with: with)
        shape.strokeColor = UIColor.white.cgColor
        self.layer.addSublayer(shape)
    }
    func drawShape (with: UIColor) {
        self.shape.fillColor = with.cgColor
    }
    

}
