//
//  progressBarView.swift
//  TaskForce
//
//  Created by Daniel Stahl on 5/8/18.
//  Copyright © 2018 Daniel Stahl. All rights reserved.
//

import UIKit

class ProgressBarView: UIView {
//    var bgPath: UIBezierPath!
//    var shapeLayer: CAShapeLayer!
//    var progressLayer: CAShapeLayer!
//
//    private func createCirclePath() {
//        let x = self.frame.width / 2
//        let y = self.frame.height / 2
//        let center = CGPoint(x: x, y: y)
//
//        bgPath.addArc(withCenter: center, radius: x / CGFloat(2), startAngle: CGFloat(0), endAngle: CGFloat(6.28), clockwise: true)
//        bgPath.close()
//    }
//
//    func simpleShape() {
//        createCirclePath()
//
//        shapeLayer = CAShapeLayer()
//        shapeLayer.path = bgPath.cgPath
//        shapeLayer.lineWidth = 15
//        shapeLayer.fillColor = nil
//        shapeLayer.strokeColor = UIColor.lightGray.cgColor
//
//        progressLayer = CAShapeLayer()
//        progressLayer.path = bgPath.cgPath
//        progressLayer.lineWidth = 15
//        progressLayer.lineCap = kCALineCapRound
//        progressLayer.fillColor = nil
//        progressLayer.strokeColor = UIColor.red.cgColor
//        progressLayer.strokeEnd = 0.0
//
//        self.layer.addSublayer(shapeLayer)
//        self.layer.addSublayer(progressLayer)
//    }
//
//    var progress: Float = 0 {
//        willSet(newValue) {
//            progressLayer.strokeEnd = CGFloat(newValue)
//        }
//    }
    
    var bgPath: UIBezierPath!
    var shapeLayer: CAShapeLayer!
    var progressLayer: CAShapeLayer!
    
    var progress: Float = 0 {
        willSet(newValue)
        {
            progressLayer.strokeEnd = CGFloat(newValue)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bgPath = UIBezierPath()
        self.simpleShape()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        bgPath = UIBezierPath()
        self.simpleShape()
    }
    
    func simpleShape()
    {
        createCirclePath()
        shapeLayer = CAShapeLayer()
        shapeLayer.path = bgPath.cgPath
        shapeLayer.lineWidth = 15
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        
        progressLayer = CAShapeLayer()
        progressLayer.path = bgPath.cgPath
        progressLayer.lineCap = kCALineCapRound
        progressLayer.lineWidth = 15
        progressLayer.fillColor = nil
        progressLayer.strokeColor = UIColor.red.cgColor
        progressLayer.strokeEnd = 0.0
        
        
        self.layer.addSublayer(shapeLayer)
        self.layer.addSublayer(progressLayer)
    }
    
    private func createCirclePath()
    {
        
        let x = self.frame.width/2
        let y = self.frame.height/2
        let center = CGPoint(x: x, y: y)
        print(x,y,center)
        bgPath.addArc(withCenter: center, radius: x/CGFloat(2), startAngle: CGFloat(0), endAngle: CGFloat(6.28), clockwise: true)
        bgPath.close()
    }
    
    
}












