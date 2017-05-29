//
//  GradientButton.swift
//  TinderClone
//
//  Created by mahmoud khudairi on 5/27/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit

@IBDesignable

class GraidentButton: UIButton {
    @IBInspectable var FirstColor: UIColor = UIColor.clear{
        didSet{
            updateView()
        }
    }
    
    
    @IBInspectable var SecondColor: UIColor = UIColor.clear{
        didSet{
            updateView()
        }
    }
    
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    
    func updateView(){
        let layer = self.layer as! CAGradientLayer
        layer.startPoint = CGPoint(x: 0.0, y: 0.5)
        layer.endPoint = CGPoint(x: 1.0, y: 0.5)
        layer.colors = [FirstColor.cgColor, SecondColor.cgColor]
    }
}
