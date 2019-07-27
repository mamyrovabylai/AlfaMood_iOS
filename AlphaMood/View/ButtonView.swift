//
//  ButtonView.swift
//  AlphaMood
//
//  Created by Абылайхан on 7/27/19.
//  Copyright © 2019 Абылайхан. All rights reserved.
//

import UIKit
protocol ButtonViewDelegate {
    func buttonTapped(number: String)
}
@IBDesignable
class ButtonView: UIView {

    @IBOutlet weak var label: UILabel!
    @IBInspectable var number: String!
    var path: UIBezierPath!
    var delegate: ButtonViewDelegate?
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
        shape.strokeColor = UIColor.white.cgColor
        self.layer.addSublayer(shape)
        
    }
    
    func getCirclePath(rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath(ovalIn: rect)
        return path
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let hitted = touches.contains { (touch) -> Bool in
            let point = touch.location(in: self)
            if self.path.contains(point){
                return true
            }
            return false
        }
        if hitted {
            self.delegate?.buttonTapped(number: self.number)
        }
        
    }
 

}
