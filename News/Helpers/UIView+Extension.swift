//
//  UIView+Extention.swift
//  LiveShopCast
//
//  Created by Kent Nguyen on 5/25/18.
//  Copyright © 2018 Poeta Digital. All rights reserved.
//

import UIKit
import Foundation
import QuartzCore

struct ConstrainDefault{
    let width = "width"
    let height = "height"
    let top = "top"
    let bottom = "bottom"
    let leading = "leading"
    let training = "training"
}

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        set {
            self.layer.cornerRadius = newValue
            self.layer.layoutSublayers()
            self.layer.needsLayout()
        }
        
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable
    var borderColor: UIColor {
        set {
            self.layer.borderColor = newValue.cgColor
            self.layer.layoutSublayers()
            self.layer.needsLayout()
        }
        
        get {
            
            if let bColor = layer.borderColor {
                return UIColor.init(cgColor: bColor)
            }
            
            return UIColor.clear
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        set {
            self.layer.borderWidth = newValue
            self.layer.layoutSublayers()
            self.layer.needsLayout()
        }
        
        get {
            return self.layer.borderWidth
        }
    }
    
    static func getNib( _ nibNameOrNil: String? = nil) -> UINib {
        var _nibName = nibNameOrNil
        if _nibName == nil{
            _nibName = self.getClassName().components(separatedBy: ".").last
        }
        return UINib(nibName: _nibName!, bundle: nil)
    }
    
    static func getFromNib() -> [Any]? {
        return Bundle.main.loadNibNamed(self.getClassName(), owner: self, options: nil)
    }
    
    func getFromNib() -> [Any]? {
        return Bundle.main.loadNibNamed(self.getClassName(), owner: self, options: nil)
    }
    
    func getNib( _ nibNameOrNil: String? = nil) -> UINib {
        var _nibName = nibNameOrNil
        if _nibName == nil{
            _nibName = self.getClassName().components(separatedBy: ".").last
        }
        return UINib(nibName: _nibName!, bundle: nil)
    }
    
    func getConstraint(_ identifier:String) -> NSLayoutConstraint? {
        let constraints = self.constraints.filter { (constraint) -> Bool in
            return constraint.identifier == identifier
        }
        if constraints.count > 0
        {
            return constraints[0]
        }
        return nil
    }
    
    func imageFromView() -> UIImage {
        if UIScreen.main.responds(to: #selector(NSDecimalNumberBehaviors.scale)) {
            UIGraphicsBeginImageContextWithOptions(frame.size, false, UIScreen.main.scale)
        } else {
            UIGraphicsBeginImageContext(frame.size)
        }
        layer.render(in: UIGraphicsGetCurrentContext()!)
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return image
        }
        
        return UIImage()
    }
    
    func adjustAnchorPoint(anchorPoint: CGPoint) {
        var newPoint = CGPoint(x: bounds.width * anchorPoint.x, y: bounds.height * anchorPoint.y)
        var oldPoint = CGPoint(x: bounds.width * layer.anchorPoint.x, y: bounds.height * layer.anchorPoint.y)
        
        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)
        
        var position = layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        translatesAutoresizingMaskIntoConstraints = true
        layer.anchorPoint = anchorPoint
        layer.position = position
    }
    
    func setBorderView(_ radius:CGFloat, color:UIColor, borderWidth:CGFloat)
    {
        self.layer.masksToBounds = true;
        self.layer.cornerRadius = radius
        self.layer.borderColor = color.cgColor;
        self.layer.borderWidth = borderWidth;
    }
    
    func setBorderView(_ radius:CGFloat, shadowRadius:CGFloat, shadowColor:UIColor, offset: CGSize)
    {
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = 0.25
        self.layer.shadowRadius = shadowRadius
        self.layer.masksToBounds = false
        self.layer.cornerRadius = radius
    }
    
    @objc func setBorderView(_ radius:CGFloat, color:UIColor, shadowColor:UIColor, offset: CGSize)
    {
        self.setBorderView(radius, color: color)
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false;
    }
    
    func applyGradient(colors:[CGColor], locations:[Double]){
        self.layer.sublayers?.forEach({ (layer) in
            if layer is CAGradientLayer{
                layer.removeFromSuperlayer()
            }
        })
        let layer = CAGradientLayer.init()
        layer.frame = self.bounds
        layer.colors = colors
        layer.startPoint = CGPoint.init(x: 0.5, y: 0)
        layer.endPoint = CGPoint.init(x: 0.5, y: 1)
        layer.locations = locations as [NSNumber]
        layer.cornerRadius = self.cornerRadius
        self.layer.insertSublayer(layer, at: 0)
    }
    
    func setBorderView(_ radius:CGFloat, color:UIColor)
    {
        setBorderView(radius, color: color, borderWidth: 0.5)
    }
    
    func setBorderView(_ radius:CGFloat)
    {
        setBorderView(radius, color: UIColor.clear, borderWidth: 0.0)
    }
    
    func addSubView(_ view:UIView, padding:UIEdgeInsets? = UIEdgeInsets.init())
    {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        // Height constraint, half of parent view height
        self.addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: padding!.top))
        
        // Center horizontally
        self.addConstraint(NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: padding!.left))
        
        // Center vertically
        self.addConstraint(NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: padding!.bottom))
        
        // Center vertically
        self.addConstraint(NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: padding!.right))
        self.updateConstraints()
        self.layoutIfNeeded()
    }
    
    func addTopSubView(_ view:UIView, padding:UIEdgeInsets, height:CGFloat)
    {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        // Height constraint, half of parent view height
        let heightContraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height)
        heightContraint.identifier = ConstrainDefault().height
        self.addConstraint(heightContraint)
        
        // Center horizontally
        self.addConstraint(NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: padding.left))
        
        // Center vertically
        let topContraint = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: padding.top)
        topContraint.identifier = ConstrainDefault().top
        self.addConstraint(topContraint)
        
        // Center vertically
        self.addConstraint(NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: padding.right))
        
        self.updateConstraints()
        self.layoutIfNeeded()
    }
    
    func addBottomSubView(_ view:UIView, padding:UIEdgeInsets, height:CGFloat)
    {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        // Height constraint, half of parent view height
        self.addConstraint(NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height))
        
        // Center horizontally
        self.addConstraint(NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: padding.left))
        
        // Center vertically
        self.addConstraint(NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: padding.bottom))
        
        // Center vertically
        self.addConstraint(NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: padding.right))
        self.updateConstraints()
        self.layoutIfNeeded()
    }
    
    static func animateFadeOut(toValue:CGFloat)->CABasicAnimation{
        let anim = CABasicAnimation.init(keyPath: "opacity")
        anim.toValue = toValue
        anim.duration = 1
        anim.repeatCount = 0
        return anim
    }
    
    func getLayer<T:CAShapeLayer>(color:UIColor, lineWidth:CGFloat, path:CGPath)->T{
        let layer = T.init()
        layer.lineCap = .round
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = color.cgColor
        layer.lineWidth = lineWidth
        layer.frame = self.bounds
        layer.path = path
        layer.strokeStart = 0
        layer.strokeEnd = 1
        return layer
    }
    
    func scaleAnimation(animation:AnimationInfo){
        let scaleAnimation:CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.duration = animation.duration
        scaleAnimation.repeatCount = animation.repeatCount
        scaleAnimation.autoreverses = animation.autoreverses
        scaleAnimation.fromValue = animation.fromValue
        scaleAnimation.toValue = animation.toValue
        self.layer.add(scaleAnimation, forKey: "scale")
    }
    
    func removeAnimations(){
        self.layer.removeAllAnimations()
    }
}


struct AnimationInfo{
    var duration:Double = 1
    var repeatCount:Float = 0
    var autoreverses = true
    var fromValue:Any?
    var toValue:Any?
    var byValue: Any?
}
