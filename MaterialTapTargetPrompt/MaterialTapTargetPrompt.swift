//
//  MaterialTapTargetPrompt.swift
//  MaterialTapTargetPrompt
//
//  Created by abedalkareem omreyh on 1/24/17.
//  Copyright © 2017 abedalkareem omreyh. All rights reserved.
//

import UIKit

class MaterialTapTargetPrompt: UIView {

    var targetView:UIView!
    let sizeOfView:CGFloat!
    let coloredCircleLayer = CAShapeLayer()
    let blurWhiteCircleLayer = CAShapeLayer()
    var lblPrimaryText:UILabel!
    var lblSecondaryText:UILabel!
    let spaceBetweenLabel:CGFloat = 10.0
    var action:(() -> Void) = {}
    var controller:UIViewController!
    
    var primaryText:String = "Primary text Here !" {
        willSet{
            lblPrimaryText.text = newValue
            lblPrimaryText.sizeToFit()
        }
    }
    
    var secondaryText:String = "Secondary text Here !" {
        willSet{
            lblSecondaryText.text = newValue
            lblSecondaryText.sizeToFit()
        }
    }
    
    var circleColor:UIColor! = UIColor.brown {
        willSet{
            coloredCircleLayer.fillColor = newValue.cgColor
        }
    }
    
    var textPostion:TextPostion = .right{
        willSet{
            var xPostion = self.frame.width/1.9 // right
            if newValue == .left{
                xPostion = self.frame.width/4 // left
            }
            // reposition labels
            lblPrimaryText.frame = CGRect(x: xPostion, y: self.frame.width/1.6, width: lblPrimaryText.frame.width, height: lblPrimaryText.frame.height)
            lblSecondaryText.frame = CGRect(x: xPostion, y: lblPrimaryText.frame.height+lblPrimaryText.frame.origin.y+spaceBetweenLabel, width: lblSecondaryText.frame.width, height: lblSecondaryText.frame.height)
        }
    }
    
    @objc init(controller: UIViewController,target targetView: NSObject){
        self.sizeOfView = controller.view.frame.width * 2
        self.controller = controller
        super.init(frame: CGRect(x: 0, y: 0, width: sizeOfView, height: sizeOfView))
        
        self.targetView = getTargetView(object: targetView)
        backgroundColor = UIColor.clear // make background of view clear
        layer.cornerRadius = sizeOfView // make view circly
        self.center = CGPoint(x: self.targetView.center.x, y: self.targetView.center.y+self.targetView.frame.width/2) //center view

        let window = UIApplication.shared.keyWindow
        window?.addSubview(self) // add to window
        
        drawColoredCircle()
        drawBlurWhiteCircle()
        addText()
        
        // dummy view used to hide the MaterialTapTargetPrompt view when you touch out of the view
        dummyView()
    }
    
    func getTargetView(object: NSObject) -> UIView?{
        if let barButtonItem = object as? UIBarButtonItem {
            return (barButtonItem.value(forKey: "view") as! UIView)
        }else if let view = object as? UIView {
            return view
        }else{
            return nil
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func dummyView(){
        let dummyView = UIView(frame: CGRect(x: 0, y: 0, width: controller.view.frame.size.width, height: controller.view.frame.size.height))
        dummyView.backgroundColor = UIColor.clear
        dummyView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        dummyView.addGestureRecognizer(tapGesture)
        controller.view.addSubview(dummyView)
        controller.view.bringSubview(toFront: self)
    }

    
    func addText(){
        var xPostion = self.frame.width/1.9 // right
        if textPostion == .left{
            xPostion = self.frame.width/4
        }
        
        lblPrimaryText = UILabel(frame: CGRect(x: xPostion, y: self.frame.width/1.6, width: self.frame.width*3, height: 5))
        lblPrimaryText.text = primaryText
        lblPrimaryText.numberOfLines = 3
        lblPrimaryText.textColor = UIColor.white
        lblPrimaryText.font = UIFont.boldSystemFont(ofSize: 20)
        lblPrimaryText.sizeToFit()
        self.addSubview(lblPrimaryText)
        
        lblSecondaryText = UILabel(frame: CGRect(x: xPostion, y: lblPrimaryText.frame.height+lblPrimaryText.frame.origin.y+spaceBetweenLabel, width: self.frame.width*3, height: 5))
        lblSecondaryText.text = secondaryText
        lblSecondaryText.numberOfLines = 9
        lblSecondaryText.textColor = UIColor.white
        lblSecondaryText.font = UIFont.systemFont(ofSize: 18)
        lblSecondaryText.sizeToFit()
        self.addSubview(lblSecondaryText)
    }

    
    func drawColoredCircle(){
        let radius = targetView.frame.size.width + 10
        let centerOfView = self.bounds.size.width / 2 - radius
        let circlePath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.width), cornerRadius: self.bounds.size.width)
        let clearPath = UIBezierPath(roundedRect: CGRect(x:centerOfView, y: centerOfView, width: 2 * radius, height: 2 * radius), cornerRadius: radius)
        circlePath.append(clearPath)
        circlePath.usesEvenOddFillRule = true
        
        coloredCircleLayer.path = circlePath.cgPath
        coloredCircleLayer.fillRule = kCAFillRuleEvenOdd
        coloredCircleLayer.fillColor = circleColor.cgColor
        coloredCircleLayer.opacity = 0.8

        self.layer.addSublayer(coloredCircleLayer)
        
        playFocusAnimation()
    }
    
    func playFocusAnimation(){
        let radius = targetView.frame.size.width
        let centerOfView = self.bounds.size.width / 2 - radius + 5
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.width), cornerRadius: self.bounds.size.width)
        let circlePath = UIBezierPath(roundedRect: CGRect(x:centerOfView, y: centerOfView, width: 2 * radius - 10, height: 2 * radius - 10), cornerRadius: radius)
        path.append(circlePath)
        path.usesEvenOddFillRule = true
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = 0.8
        animation.toValue =  path.cgPath
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.autoreverses = true
        animation.repeatCount = HUGE
        // if you remove it the shape will return to the original shape after the animation finished
        animation.fillMode = kCAFillRuleEvenOdd
        animation.isRemovedOnCompletion = false
        coloredCircleLayer.add(animation, forKey: nil)
        
    }
    
    func drawBlurWhiteCircle(){
        let radius = targetView.frame.size.width * 2 - 10
        let superViewWidth = self.bounds.size.width/10
        let centerOfView = (self.bounds.size.width/2)-(radius/2)
        let path = UIBezierPath(roundedRect: CGRect(x: (self.bounds.size.width/2)-(superViewWidth/2), y: (self.bounds.size.width/2)-(superViewWidth/2), width: superViewWidth, height: superViewWidth), cornerRadius: superViewWidth)
        let circlePath = UIBezierPath(roundedRect: CGRect(x:centerOfView, y: centerOfView, width: radius, height: radius), cornerRadius: radius)
        path.append(circlePath)
        path.usesEvenOddFillRule = true
        
        blurWhiteCircleLayer.path = path.cgPath
        blurWhiteCircleLayer.fillRule = kCAFillRuleEvenOdd
        blurWhiteCircleLayer.fillColor = UIColor.white.cgColor
        blurWhiteCircleLayer.opacity = 0.5

        self.layer.addSublayer(blurWhiteCircleLayer)
        
        let blurFilter = CIFilter(name: "CIGaussianBlur")
        blurFilter?.setDefaults()
        blurFilter?.setValue(0, forKey:"inputRadius")
        if #available(iOS 10.0, *) {
            blurFilter?.name = "blur"
        }
        blurFilter?.setValue(30, forKey: "inputRadius")
        blurWhiteCircleLayer.filters = [blurFilter!]

        playAnimationForWhiteCircle()
    }
    
    func playAnimationForWhiteCircle(){
        let radius = targetView.frame.size.width + 10
        let superViewWidth = self.bounds.size.width/4
        let centerOfView = self.bounds.size.width / 2 - radius
        let path = UIBezierPath(roundedRect: CGRect(x: (self.bounds.size.width/2)-(superViewWidth/2), y: (self.bounds.size.width/2)-(superViewWidth/2), width: superViewWidth, height: superViewWidth), cornerRadius: superViewWidth)
        let circlePath = UIBezierPath(roundedRect: CGRect(x:centerOfView, y: centerOfView, width: 2 * radius, height: 2 * radius), cornerRadius: radius)
        path.append(circlePath)
        path.usesEvenOddFillRule = true
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = 1.55
        animation.beginTime = CACurrentMediaTime() + 0.8
        animation.toValue =  path.cgPath
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.repeatCount = HUGE
        // if you remove it the shape will return to the original shape after the animation finished
        animation.fillMode = kCAFillRuleEvenOdd
        animation.isRemovedOnCompletion = false
        blurWhiteCircleLayer.add(animation, forKey: nil)

        let opacityanimation : CABasicAnimation = CABasicAnimation(keyPath: "opacity");
        opacityanimation.fromValue = 0.5
        opacityanimation.toValue = 0
        opacityanimation.beginTime = CACurrentMediaTime() + 0.8
        opacityanimation.repeatCount = HUGE
        opacityanimation.duration = 1.55
        blurWhiteCircleLayer.add(opacityanimation, forKey: nil)
        
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        action()
    }
    
    func dismiss(){
        self.removeFromSuperview()
    }

    

}

@objc enum TextPostion:Int{
    case right
    case left
}

