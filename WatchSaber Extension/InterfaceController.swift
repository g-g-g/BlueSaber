//
//  InterfaceController.swift
//  WatchSaber Extension
//
//  Created by Ganesh Gautham on 2/28/16.
//  Copyright © 2016 Ganesh Gautham Industries. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {
    
    @IBOutlet var Saber: WKInterfaceImage!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Saber.hidden = true
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    /*
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        
        
        super.didDeactivate()
    }
    */
    @IBAction func Pressed() {
       
    }
    
    /*
    @IBOutlet var animateButton: WKInterfaceButton!
    @IBOutlet var buttonSpacerGroup: WKInterfaceGroup!
    var buttonMoved: Bool!
    
    @IBAction func animateMovingButton() {
    if (buttonMoved != true) {
    animateWithDuration(0.3, animations: {
    self.buttonSpacerGroup.setHeight(100)
    })
    
    buttonMoved = true
    animateButton.setTitle("Reset")
    } else {
    animateWithDuration(0.3, animations: {
    self.buttonSpacerGroup.setHeight(0)
    })
    
    buttonMoved = false
    animateButton.setTitle("Animate!")
    }
    }
    */
    
}
