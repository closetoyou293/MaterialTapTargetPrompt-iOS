//
//  MaterialTapTargetPrompt.swift
//  MaterialTapTargetPrompt
//
//  Created by abedalkareem omreyh on 1/24/17.
//  Copyright © 2017 abedalkareem omreyh. All rights reserved.
//

import UIKit

class MaterialTapTargetPrompt: UIView {

    fileprivate var targetView:UIView!
    fileprivate let sizeOfView:CGFloat!
    fileprivate let coloredCircleLayer = CAShapeLayer()
    fileprivate let blurWhiteCircleLayer = CAShapeLayer()
    fileprivate var dummyView:UIView? = nil
    
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
    
    var textPostion:TextPostion = .bottomRight{
        willSet{
            var xPostion:CGFloat = 0.0
            var yPostion:CGFloat = 0.0

            // set y and x postion
            switch newValue {
            case .bottomRight:
                xPostion = self.frame.width/1.9
                yPostion = self.frame.width/1.6
            case .bottomLeft:
                xPostion = self.frame.width/4
                yPostion = self.frame.width/1.6
            case .topRight:
                xPostion = self.frame.width/1.9
                yPostion = self.frame.width/4
            case .topLeft:
                xPostion = self.frame.width/4
                yPostion = self.frame.width/4
            case .centerRight:
                xPostion = self.frame.width/1.6
                yPostion = self.frame.width/2.23
            case .centerLeft:
                xPostion = self.frame.width/6
                yPostion = self.frame.width/2.23
            case .cenertTop:
                xPostion = self.frame.width/2.23
                yPostion = self.frame.width/1.6
            case .centerBottom:
                xPostion = self.frame.width/2.23
                yPostion = self.frame.width/1.6
            }
            
            // reposition labels
            lblPrimaryText.frame = CGRect(x: xPostion, y: yPostion, width: lblPrimaryText.frame.width, height: lblPrimaryText.frame.height)
            lblSecondaryText.frame = CGRect(x: xPostion, y: lblPrimaryText.frame.height+lblPrimaryText.frame.origin.y+spaceBetweenLabel, width: lblSecondaryText.frame.width, height: lblSecondaryText.frame.height)
        }
    }
    
    // MARK: init
    
    @objc init(controller: UIViewController,target targetView: NSObject){
        self.sizeOfView = controller.view.frame.width * 2 // set size of view
        self.controller = controller // set current view controller
        super.init(frame: CGRect(x: 0, y: 0, width: sizeOfView, height: sizeOfView))
        
        self.targetView = getTargetView(object: targetView) // get the view from the sended target
        backgroundColor = UIColor.clear // make background of view clear
        layer.cornerRadius = sizeOfView // make view circly
        
        let window = UIApplication.shared.keyWindow

        let cFrame = self.targetView.convert(self.targetView.bounds, to: window)
        
        self.center = CGPoint(x: cFrame.origin.x + cFrame.width/2 , y: cFrame.origin.y + cFrame.height/2) //center view

        window?.addSubview(self) // add to window
        
        drawColoredCircle()
        drawBlurWhiteCircle()
        addText()
        
        // dummy view used to hide the MaterialTapTargetPrompt view when you touch out of the view
        addDummyView()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    fileprivate func getTargetView(object: NSObject) -> UIView?{
        if let barButtonItem = object as? UIBarButtonItem {
            return (barButtonItem.value(forKey: "view") as! UIView) //get the view from UIBarButtonItem
        }else if let view = object as? UIView {
            return view
        }else{
            return nil
        }
    }


    fileprivate func addText(){
        var xPostion = self.frame.width/1.9 // right
        if textPostion == .bottomLeft{
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
        
        // hide labels
        lblPrimaryText.alpha = 0
        lblSecondaryText.alpha = 0

    }
    
    fileprivate func showLabels(){
        UIView.animate(withDuration: 0.5) {
            self.lblPrimaryText.alpha = 1
            self.lblSecondaryText.alpha = 1
        }
    }

    // MARK: Draw circles
    
    fileprivate func drawColoredCircle(){
        
        coloredCircleLayer.path = shrinkedBlurWhiteCirclePath().cgPath
        coloredCircleLayer.fillRule = kCAFillRuleEvenOdd
        coloredCircleLayer.fillColor = circleColor.cgColor
        coloredCircleLayer.opacity = 0.8

        self.layer.addSublayer(coloredCircleLayer)
        
        playExpandAnimation()
        self.playFocusAnimation()

    }

    
    fileprivate func drawBlurWhiteCircle(){
        
        blurWhiteCircleLayer.path = shrinkedBlurWhiteCirclePath().cgPath
        blurWhiteCircleLayer.fillRule = kCAFillRuleEvenOdd
        blurWhiteCircleLayer.fillColor = UIColor.white.cgColor
        blurWhiteCircleLayer.opacity = 0.0

        self.layer.addSublayer(blurWhiteCircleLayer)
        
        addBulrFilterToWhiteCircle()
        playAnimationForWhiteCircle()
    }
    
    func addBulrFilterToWhiteCircle(){
        let blurFilter = CIFilter(name: "CIGaussianBlur")
        blurFilter?.setDefaults()
        blurFilter?.setValue(0, forKey:"inputRadius")
        if #available(iOS 10.0, *) {
            blurFilter?.name = "blur"
        }
        blurFilter?.setValue(30, forKey: "inputRadius")
        blurWhiteCircleLayer.filters = [blurFilter!]
    }
    
    // MARK: Animations
    
    fileprivate func playExpandAnimation(){
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            self.coloredCircleLayer.path = self.coloredCircleLayerPath().cgPath
            self.playFocusAnimation()
            self.showLabels()
        })
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = 0.8
        animation.toValue =  coloredCircleLayerPath().cgPath
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        // if you remove it the shape will return to the original shape after the animation finished
        animation.fillMode = kCAFillRuleEvenOdd
        animation.isRemovedOnCompletion = false
        
        coloredCircleLayer.add(animation, forKey: nil)
        CATransaction.commit()
    }
    

    fileprivate func playFocusAnimation(){
        let radius = targetView.frame.size.width
        let centerOfView = self.bounds.size.width / 2 - radius/2
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.width), cornerRadius: self.bounds.size.width)
        let circlePath = UIBezierPath(roundedRect: CGRect(x:centerOfView, y: centerOfView, width: radius, height:  radius), cornerRadius: radius)
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
    
    fileprivate func playAnimationForWhiteCircle(){
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = 1.55
        animation.beginTime = CACurrentMediaTime() + 0.8
        animation.toValue =  expandedBlurWhiteCirclePath().cgPath
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
    
    
    // MARK: Size of circles
    
    fileprivate func shrinkedBlurWhiteCirclePath() -> UIBezierPath{
        let radius = targetView.frame.size.width + 10
        let superViewWidth = targetView.frame.size.width + 11
        let centerOfView = self.bounds.size.width / 2 - (radius/2)
        let path = UIBezierPath(roundedRect: CGRect(x: (self.bounds.size.width/2)-(superViewWidth/2), y: (self.bounds.size.width/2)-(superViewWidth/2), width: superViewWidth, height: superViewWidth), cornerRadius: superViewWidth)
        let circlePath = UIBezierPath(roundedRect: CGRect(x:centerOfView, y: centerOfView, width: radius, height: radius), cornerRadius: radius)
        path.append(circlePath)
        path.usesEvenOddFillRule = true
        return path
    }
    
    fileprivate func expandedBlurWhiteCirclePath() -> UIBezierPath{
        let radius = targetView.frame.size.width + 15
        let superViewWidth = self.bounds.size.width/4
        let centerOfView = self.bounds.size.width / 2 - (radius/2)
        let path = UIBezierPath(roundedRect: CGRect(x: (self.bounds.size.width/2)-(superViewWidth/2), y: (self.bounds.size.width/2)-(superViewWidth/2), width: superViewWidth, height: superViewWidth), cornerRadius: superViewWidth)
        let circlePath = UIBezierPath(roundedRect: CGRect(x:centerOfView, y: centerOfView, width: radius, height: radius), cornerRadius: radius)
        path.append(circlePath)
        path.usesEvenOddFillRule = true
        return path
    }

    
    fileprivate func coloredCircleLayerPath() -> UIBezierPath{
        let radius = targetView.frame.size.width + 10
        let centerOfView = self.bounds.size.width / 2 - radius
        let circlePath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.width), cornerRadius: self.bounds.size.width)
        let clearPath = UIBezierPath(roundedRect: CGRect(x:centerOfView, y: centerOfView, width: 2 * radius, height: 2 * radius), cornerRadius: radius)
        circlePath.append(clearPath)
        circlePath.usesEvenOddFillRule = true
        return circlePath
    }
    
    // when touch the icon run the action
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first

        // if button clicked invoke action
        let isButtonClicked = shrinkedBlurWhiteCirclePath().cgPath.boundingBoxOfPath.contains(touch!.location(in: self))
        if isButtonClicked {
            action()
        }
        
        self.dismiss()

    }
    
    
    // dummy view used to stop user interaction
    fileprivate func addDummyView(){
        dummyView = UIView(frame: CGRect(x: 0, y: 0, width: controller.view.frame.size.width, height: controller.view.frame.size.height))
        dummyView?.backgroundColor = UIColor.clear
        dummyView?.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        dummyView?.addGestureRecognizer(tapGesture)
        controller.view.addSubview(dummyView!)
        controller.view.bringSubview(toFront: self)
    }
    
    // dismiss the view
    func dismiss(){
        dummyView?.removeFromSuperview()
        self.removeFromSuperview()
    }
    
    

    

}




@objc enum TextPostion:Int{
    case bottomRight
    case bottomLeft
    case topLeft
    case topRight
    case centerLeft
    case centerRight
    case cenertTop
    case centerBottom
}

