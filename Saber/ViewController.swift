//
//  ViewController.swift
//  Saber
//
//  Created by Gautham Ganesh Elango on 1/3/16.
//  Copyright © 2016 Gautham Ganesh Elango. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMotion
import AudioToolbox
import GoogleMobileAds
import Foundation
import MapKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var lightSaber: UIImageView!
    
    var ButtonAudioURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("On", ofType: "wav")!)
    var ButtonAudio2URL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Off", ofType: "wav")!)
    var ButtonAudio3URL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Idle", ofType: "wav")!)
    var ButtonAudioPlayer = AVAudioPlayer()
    var ButtonAudioPlayer2 = AVAudioPlayer()
    var ButtonAudioPlayer3 = AVAudioPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.sharedApplication().statusBarHidden = true

        do { self.ButtonAudioPlayer = try AVAudioPlayer(contentsOfURL:self.ButtonAudioURL, fileTypeHint: nil) } catch _ { }
        do { self.ButtonAudioPlayer2 = try AVAudioPlayer(contentsOfURL:self.ButtonAudio2URL, fileTypeHint: nil) } catch _ { }
        do { self.ButtonAudioPlayer3 = try AVAudioPlayer(contentsOfURL:self.ButtonAudio3URL, fileTypeHint: nil) } catch _ { }

        self.lightSaber.hidden = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func toggleTorch(on on: Bool) {
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                if on == true {
                    device.torchMode = .On
                } else {
                    device.torchMode = .Off
                }
                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time( DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }

    @IBAction func buttonTouchDown(sender: UIButton) {
        ButtonAudioPlayer.play()
        ButtonAudioPlayer3.play()

        self.lightSaber.hidden = false
        lightSaber.center.y = self.view.frame.width + 1000  //Starting Location
        UIView.animateWithDuration(1.0  /*Duration*/, animations: ({
            self.lightSaber.center.y = self.view.frame.width - 50  /*Ending location*/}))
        
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        delay(0.5){
        self.toggleTorch(on: true)
        }
    
    }
    
    @IBAction func buttonTouchEnded(sender: UIButton) {
        self.lightSaber.hidden = false
 
        ButtonAudioPlayer2.play()
        ButtonAudioPlayer3.stop()

        lightSaber.center.y = self.view.frame.width - 50   //Starting location
        UIView.animateWithDuration(1.0 /*Duration*/, animations: ({self.lightSaber.center.y = self.view.frame.width + 1000    /*Ending location*/}))
        
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        delay(0.5){
        self.toggleTorch(on: false)
        }
        
        delay(60){
            self.lightSaber.hidden = true
            return
        }
        
    }
    
}