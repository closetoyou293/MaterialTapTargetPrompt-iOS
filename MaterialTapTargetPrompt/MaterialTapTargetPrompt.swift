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
    fileprivate var dummyView:UIView?
    fileprivate let appWindow = UIApplication.shared.keyWindow
    

    var lblPrimaryText:UILabel!
    var lblSecondaryText:UILabel!
    
    var spaceBetweenLabel:CGFloat = 10.0
    var font:UIFont?
    var action:(() -> Void) = {}
    var dismissed:(() -> Void) = {}
    
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

            let viewWidth = self.frame.width
            // set y and x postion
            switch newValue {
            case .bottomRight:
                xPostion = viewWidth/1.9
                yPostion = viewWidth/1.6
            case .bottomLeft:
                xPostion = viewWidth/4
                yPostion = viewWidth/1.6
            case .topRight:
                xPostion = viewWidth/1.9
                yPostion = viewWidth/4
            case .topLeft:
                xPostion = viewWidth/4
                yPostion = viewWidth/4
            case .centerRight:
                xPostion = viewWidth/1.6
                yPostion = viewWidth/2.23
            case .centerLeft:
                xPostion = viewWidth/6
                yPostion = viewWidth/2.23
            case .cenertTop:
                xPostion = viewWidth/2.23
                yPostion = viewWidth/1.6
            case .centerBottom:
                xPostion = viewWidth/2.23
                yPostion = viewWidth/1.6
            }
            
            // reposition labels
            lblPrimaryText.frame = CGRect(x: xPostion, y: yPostion, width: lblPrimaryText.frame.width, height: lblPrimaryText.frame.height)
            lblSecondaryText.frame = CGRect(x: xPostion, y: lblPrimaryText.frame.height+lblPrimaryText.frame.origin.y+spaceBetweenLabel, width: lblSecondaryText.frame.width, height: lblSecondaryText.frame.height)
        }
    }
    
    // MARK: init
    
    @objc init(target targetView: NSObject){
        self.sizeOfView = appWindow!.frame.width * 2 // set size of view
        super.init(frame: CGRect(x: 0, y: 0, width: sizeOfView, height: sizeOfView))
        
        self.targetView = getTargetView(object: targetView) // get the view from the sended target
        backgroundColor = UIColor.clear // make background of view clear
        

        let convertedFrame = self.targetView.convert(self.targetView.bounds, to: appWindow)
        self.center = CGPoint(x: convertedFrame.origin.x + convertedFrame.width/2 , y: convertedFrame.origin.y + convertedFrame.height/2) //center view

        appWindow?.addSubview(self) // add to window
        
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
        lblPrimaryText.font = font ?? UIFont.boldSystemFont(ofSize: 20)
        lblPrimaryText.sizeToFit()
        self.addSubview(lblPrimaryText)
        
        lblSecondaryText = UILabel(frame: CGRect(x: xPostion, y: lblPrimaryText.frame.height+lblPrimaryText.frame.origin.y+spaceBetweenLabel, width: self.frame.width*3, height: 5))
        lblSecondaryText.text = secondaryText
        lblSecondaryText.numberOfLines = 9
        lblSecondaryText.textColor = UIColor.white
        lblSecondaryText.font = font ?? UIFont.systemFont(ofSize: 18)
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
        
        coloredCircleLayer.path = shrinkedBlurWhiteCirclePath.cgPath
        coloredCircleLayer.fillRule = kCAFillRuleEvenOdd
        coloredCircleLayer.fillColor = circleColor.cgColor
        coloredCircleLayer.opacity = 0.9

        self.layer.addSublayer(coloredCircleLayer)
        
        playExpandAnimation()

    }

    
    fileprivate func drawBlurWhiteCircle(){
        
        blurWhiteCircleLayer.path = shrinkedBlurWhiteCirclePath.cgPath
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
            self.showLabels()
        })
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = 0.8
        animation.toValue =  coloredCircleLayerPath.cgPath
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        // if you remove it the shape will return to the original shape after the animation finished
        animation.fillMode = kCAFillModeBoth
        animation.isRemovedOnCompletion = false
        
        coloredCircleLayer.add(animation, forKey: nil)
        CATransaction.commit()
    }
    

    
    fileprivate func playAnimationForWhiteCircle(){
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = 1.55
        animation.beginTime = CACurrentMediaTime() + 0.8
        animation.toValue =  expandedBlurWhiteCirclePath.cgPath
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.repeatCount = HUGE
        // if you remove it the shape will return to the original shape after the animation finished
        animation.fillMode = kCAFillRuleEvenOdd
        animation.isRemovedOnCompletion = false
        blurWhiteCircleLayer.add(animation, forKey: nil)

        let opacityanimation : CABasicAnimation = CABasicAnimation(keyPath: "opacity");
        opacityanimation.fromValue = 0.7
        opacityanimation.toValue = 0
        opacityanimation.beginTime = CACurrentMediaTime() + 0.8
        opacityanimation.repeatCount = HUGE
        opacityanimation.duration = 1.55
        blurWhiteCircleLayer.add(opacityanimation, forKey: nil)
        
    }
    
    // when touch the icon run the action
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first

        // if button clicked invoke action
        let isButtonClicked = shrinkedBlurWhiteCirclePath.cgPath.boundingBoxOfPath.contains(touch!.location(in: self))
        if isButtonClicked {
            action()
            dismiss(isButtonClicked:true)
            return
        }
        
        dismiss(isButtonClicked:false)

    }
    
    
    // dummy view used to stop user interaction
    fileprivate func addDummyView(){
        dummyView = UIView(frame: CGRect(x: 0, y: 0, width: appWindow!.frame.size.width, height: appWindow!.frame.size.height))
        dummyView?.backgroundColor = UIColor.clear
        dummyView?.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        dummyView?.addGestureRecognizer(tapGesture)
        appWindow!.addSubview(dummyView!)
        appWindow!.bringSubview(toFront: self)
    }
    
    // dismiss the view
    func dismiss(isButtonClicked:Bool){
        if !isButtonClicked { dismissed() }
        dummyView?.removeFromSuperview()
        self.removeFromSuperview()
    }

}


// MARK: Size of circles (Paths)

extension MaterialTapTargetPrompt{
    
    var smallCirclePath:UIBezierPath {
        get{
            let convertedFrame = self.convert(targetView.frame, from:targetView.superview)
            return  UIBezierPath(roundedRect: convertedFrame, cornerRadius: targetMidHeight)
        }
    }
    
    var midCirclePath:UIBezierPath {
        get{
            var convertedFrame = convertedTargetFrame
            convertedFrame.add(number: 100)
            return  UIBezierPath(roundedRect: convertedFrame, cornerRadius: convertedFrame.height+100)
        }
    }
    
    var bigCirclePath:UIBezierPath {
        get{
            let size = self.frame.size.width
            var convertedFrame = convertedTargetFrame
            convertedFrame.add(number:size)
            return  UIBezierPath(roundedRect: convertedFrame, cornerRadius: convertedFrame.height+size)
        }
    }
    
    var shrinkedBlurWhiteCirclePath:UIBezierPath{
        get{
            let path = smallCirclePath
            path.append(smallCirclePath)
            path.usesEvenOddFillRule = true
            return path
        }
    }
    
    var expandedBlurWhiteCirclePath:UIBezierPath{
        let path = midCirclePath
        path.append(smallCirclePath)
        path.usesEvenOddFillRule = true
        return path
    }
    
    
    var coloredCircleLayerPath:UIBezierPath{
        let path = bigCirclePath
        path.append(smallCirclePath)
        path.usesEvenOddFillRule = true
        return path
    }
}

// MARK: Dimension

extension MaterialTapTargetPrompt{
    var width:CGFloat{
        return frame.size.width
    }
    
    var height:CGFloat{
        return frame.size.height
    }
    
    var midHeight:CGFloat{
        return frame.size.height / 2
    }
    
    var midWidth:CGFloat{
        return frame.size.width / 2
    }
    
    var x:CGFloat{
        return frame.origin.x
    }
    
    var y:CGFloat{
        return frame.origin.y
    }
    
    var midX:CGFloat{
        return frame.origin.x
    }
    
    var midY:CGFloat{
        return frame.origin.y
    }
    
    
    
    var convertedTargetFrame: CGRect {
         return self.convert(targetView.frame, from:targetView.superview)
    }

    var targetWidth:CGFloat{
        return convertedTargetFrame.size.width
    }
    
    var targetHeight:CGFloat{
        return convertedTargetFrame.size.height
    }
    
    var targetMidHeight:CGFloat{
        return convertedTargetFrame.size.height / 2
    }
    
    var targetMidWidth:CGFloat{
        return convertedTargetFrame.size.width / 2
    }
    
    var targetX:CGFloat{
        return convertedTargetFrame.origin.x
    }
    
    var targetY:CGFloat{
        return convertedTargetFrame.origin.y
    }
    
    var targetMidX:CGFloat{
        return convertedTargetFrame.midX
    }
    
    var targetMidY:CGFloat{
        return convertedTargetFrame.midY
    }

}


extension CGRect{
    fileprivate mutating func add(number:CGFloat){
        self.size.height += number
        self.size.width += number
        self.origin.x -= (number/2)
        self.origin.y -= (number/2)
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

