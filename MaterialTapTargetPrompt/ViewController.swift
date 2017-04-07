//
//  ViewController.swift
//  MaterialTapTargetPrompt
//
//  Created by abedalkareem omreyh on 1/24/17.
//  Copyright © 2017 abedalkareem omreyh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    @IBOutlet weak var leftBarButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    
    
    @IBAction func showLeftShowcase(_ sender: UIButton) {
        let tapTargetPrompt = MaterialTapTargetPrompt(target: leftBarButton)
        tapTargetPrompt.action = {
            print("left clicked")
        }
        tapTargetPrompt.circleColor = #colorLiteral(red: 0.1568627451, green: 0.6588235294, blue: 0.8901960784, alpha: 1)
        tapTargetPrompt.primaryText = "Add Home"
        tapTargetPrompt.secondaryText = "Here you can add home"
        tapTargetPrompt.textPostion = .bottomRight
    }
    
    @IBAction func showRightShowcase(_ sender: UIButton) {
        let tapTargetPrompt = MaterialTapTargetPrompt(target: rightBarButton)
        tapTargetPrompt.action = {
            print("right clicked")
        }
        tapTargetPrompt.circleColor = #colorLiteral(red: 0.1568627451, green: 0.6588235294, blue: 0.8901960784, alpha: 1)
        tapTargetPrompt.primaryText = "Slide Menu"
        tapTargetPrompt.secondaryText = "This menu show a good things"
        tapTargetPrompt.textPostion = .bottomLeft
    }

}

