//
//  ViewController.swift
//  Saber
//
//  Created by Ganesh Gautham on 1/3/16.
//  Copyright © 2016 Ganesh Gautham Industries. All rights reserved.
//

import UIKit
import AVFoundation
import iAd
import CoreMotion
import AudioToolbox
import GoogleMobileAds
import Foundation

class ViewController: UIViewController, ADBannerViewDelegate {
    
    @IBOutlet weak var lightSaber: UIImageView!
    @IBOutlet weak var Banner: ADBannerView!
    @IBOutlet weak var Share: UILabel!
    @IBOutlet weak var bannerView: GADBannerView!
    
    var interstitial: GADInterstitial!
    
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

        self.Banner.hidden = true
        self.bannerView.hidden = false
        Banner.delegate = self
        self.canDisplayBannerAds = true
        print("Google Mobile Ads SDK version: " + GADRequest.sdkVersion())
        bannerView.adUnitID = "ca-app-pub-6037554166107597/7563075862"
        bannerView.rootViewController = self
        bannerView.loadRequest(GADRequest())
        self.interstitial = GADInterstitial(adUnitID: "ca-app-pub-6037554166107597/4470008669")
        let request = GADRequest()
        request.testDevices = ["2077ef9a63d2b398840261c8221a0c9b"]
        self.interstitial.loadRequest(request)
        
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
   
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        NSLog("Error")
        self.bannerView.hidden = false
    }
    
    func bannerViewWillLoadAd(banner: ADBannerView!) {
    
    }
    
    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
        return true
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        self.bannerView.hidden = true
        self.Banner.hidden = false
    }

    @IBAction func buttonTouchDown(sender: UIButton) {
        ButtonAudioPlayer.play()
        ButtonAudioPlayer3.play()

        self.lightSaber.hidden = false
        lightSaber.center.y = self.view.frame.width + 1000  //Starting Location
        UIView.animateWithDuration(1.0  /*Duration*/, animations: ({
            self.lightSaber.center.y = self.view.frame.width - 30  /*Ending location*/}))
        
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        UIView.animateWithDuration(0.4, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.Share.alpha = 0.0
            }, completion: {
                (finished: Bool) -> Void in
        })
        
        delay(0.5){
        self.toggleTorch(on: true)
        }
    }
    
    @IBAction func buttonTouchEnded(sender: UIButton) {
        self.lightSaber.hidden = false
 
        ButtonAudioPlayer2.play()
        ButtonAudioPlayer3.stop()

        lightSaber.center.y = self.view.frame.width - 30   //Starting location
        UIView.animateWithDuration(1.0 /*Duration*/, animations: ({self.lightSaber.center.y = self.view.frame.width + 1000    /*Ending location*/}))
        
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        UIView.animateWithDuration(0.8, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.Share.alpha = 1.0
            }, completion: nil)
        
        delay(0.5){
        self.toggleTorch(on: false)
        }
        
        delay(60){
            self.lightSaber.hidden = true
            return
        }
        
    }

    @IBAction func shareButton(sender: UIButton) {

        let myShare = "Simulate a lightsaber on the iPhone app, Blue Saber! Download at https://appsto.re/us/Wu6iab.i" //Text to share
        let activityVC:UIActivityViewController = UIActivityViewController(activityItems: [myShare], applicationActivities: nil)
        self.presentViewController(activityVC, animated: true, completion: nil)
        lightSaber.center.y = self.view.frame.width - 80
        UIView.animateWithDuration(1.0 , animations: ({self.lightSaber.center.y = self.view.frame.width + 1000}))
        self.lightSaber.hidden = true
    }
}