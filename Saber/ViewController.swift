//
//  ViewController.swift
//  Saber
//
//  Created by Ganesh Gautham on 1/3/16.
//  Copyright © 2016 Ganesh Gautham Industries. All rights reserved.
//
//Frameworks
import UIKit    //For UI
import AVFoundation //For audio
import iAd  //For iAds
import CoreMotion   //For gyroscope/accelerometer
//ViewController class
import AudioToolbox //For different sounds
import GoogleMobileAds
import Foundation
class ViewController: UIViewController, ADBannerViewDelegate {
    
    //Outlets
    @IBOutlet weak var lightSaber: UIImageView!
    @IBOutlet weak var Banner: ADBannerView!
    @IBOutlet weak var Share: UILabel!
    @IBOutlet weak var bannerView: GADBannerView!
    
    var interstitial: GADInterstitial!
    
    //Values
    //Variables
    var ButtonAudioURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("On", ofType: "wav")!)    //Path for On.wav
    var ButtonAudio2URL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Off", ofType: "wav")!)  //Path for Off.wav
    var ButtonAudio3URL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Idle", ofType: "wav")!) //Path for Idle.wav
    
    /*
    var ButtonAudio4URL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Swing", ofType: "wav")!) //Path for Swing.WAV
    */
    
    var ButtonAudioPlayer = AVAudioPlayer() //Plays audio
    var ButtonAudioPlayer2 = AVAudioPlayer()    //Plays audio
    var ButtonAudioPlayer3 = AVAudioPlayer()    //Plays  audio
    
    /*
    var ButtonAudioPlayer4 = AVAudioPlayer()    //Plays audio
    */
    
    var lastDirection = 0
    var threshold: Double = 0   //Minimum positive(right) accel
    var nthreshold: Double = 0  //Minimum negative(left) accel
    //Constants
    let motionManager = CMMotionManager()   //Motion manager

    var count = 0
    var amount = 1
    
    /*
    var isPlaying1 = false
    */
    
    
    //Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        //Called after the controller's view is loaded into memory
        UIApplication.sharedApplication().statusBarHidden = true
        // print("Google Mobile Ads SDK version: " + GADRequest.sdkVersion())
        
        //Audio
        do { self.ButtonAudioPlayer = try AVAudioPlayer(contentsOfURL:self.ButtonAudioURL, fileTypeHint: nil) } catch _ { } //Sets correct audio for On.wav
        do { self.ButtonAudioPlayer2 = try AVAudioPlayer(contentsOfURL:self.ButtonAudio2URL, fileTypeHint: nil) } catch _ { }   //Sets correct audio for Off.wav
        do { self.ButtonAudioPlayer3 = try AVAudioPlayer(contentsOfURL:self.ButtonAudio3URL, fileTypeHint: nil) } catch _ { }   //Sets correct audio for Idle.wav
        
        /*
        do {
            try ButtonAudioPlayer4 = AVAudioPlayer(contentsOfURL: ButtonAudio4URL)
            ButtonAudioPlayer4.prepareToPlay()
        } catch {
            print("audioPlayer failure")
        }   //Sets correct audio for Swing.WAV
        */
        
        //lightSaber
        self.lightSaber.hidden = true  //Hides lightSaber in when loaded
        
        //Banner
        self.Banner.hidden = true   //Shows Banner when loaded
        self.bannerView.hidden = false
        Banner.delegate = self
        self.canDisplayBannerAds = true //Displays ads when loaded
        print("Google Mobile Ads SDK version: " + GADRequest.sdkVersion())
        bannerView.adUnitID = "ca-app-pub-6037554166107597/7563075862"
        bannerView.rootViewController = self
        bannerView.loadRequest(GADRequest())
        
        self.interstitial = GADInterstitial(adUnitID: "ca-app-pub-6037554166107597/4470008669")
        
        let request = GADRequest()
        // Requests test ads on test devices.
        request.testDevices = ["2077ef9a63d2b398840261c8221a0c9b"]
        self.interstitial.loadRequest(request)
        
    }
        /*
    func play() {
        ButtonAudioPlayer4.currentTime = 0
        ButtonAudioPlayer4.play()
        if self.isPlaying1 == true {
            return
        }
        self.isPlaying1 = true
    }
    func stop() {
        ButtonAudioPlayer4.currentTime = 0
        ButtonAudioPlayer4.stop()
        if self.isPlaying1 == false {
            return
        }
        self.isPlaying1 = false
    }
    */

    func delay(delay:Double, closure:()->()) {
        
        dispatch_after(
            dispatch_time( DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Sent to the view controller when the app receives a memory warning
        
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
        //Called when ad loads
        self.bannerView.hidden = true
        self.Banner.hidden = false   //Shows Banner
        
    }

    //Actions
    //Button
    @IBAction func buttonTouchDown(sender: UIButton) {
        //Called when Button is held on
         
        //Audio
        ButtonAudioPlayer.play()    //Play On.wav
        ButtonAudioPlayer3.play()   //Play Idle.wav
        
        //Animation
        self.lightSaber.hidden = false //Show lightSaber
        lightSaber.center.y = self.view.frame.width + 1000  //Starting Location
        UIView.animateWithDuration(1.0  /*Duration*/, animations: ({
            self.lightSaber.center.y = self.view.frame.width - 30  /*Ending location*/}))
        
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        UIView.animateWithDuration(0.4, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.Share.alpha = 0.0
            }, completion: {
                (finished: Bool) -> Void in
                // Fade in
        })
        delay(0.5){
        self.toggleTorch(on: true)
        }
        
        /*
        //CoreMotion
        //Values
        lastDirection = 0 //Idle accel
        threshold = 1.0 //Minimum positive(right) accel
        nthreshold = -1.0 //Minimum negative(left) accel
        
        if motionManager.accelerometerAvailable {
            let queue = NSOperationQueue()
            motionManager.startAccelerometerUpdatesToQueue(queue, withHandler: {
                data, error in
                guard let data = data else{
                    return
                }
        
        // Get the acceleration
        let xAccel = data.acceleration.x    //X accel
        let yAccel = data.acceleration.y    //Y accel
        let zAccel = data.acceleration.z    //Z accel
        let xPositive = xAccel > 0  //Positive(right) x accel
        let xNegative = xAccel < 0  //Negative(left) x accel
        let yPositive = yAccel > 0  //Positive(up) y accel
        let yNegative = yAccel < 0  //Negative(down) y accel
        let zPositive = zAccel > 0  //Positive(front) z accel
        let zNegative = zAccel < 0  //Negative(back) z accel
        
        // Run if the acceleration is higher than theshold
        if abs(xAccel) > self.threshold {
            
            //If moved right
            dispatch_async(dispatch_get_main_queue()) {
                if self.lastDirection != 1 && xPositive {
                    self.lastDirection = 1
                    print("Up")
                    self.play()
            } else if self.lastDirection !=     -1 && !xPositive {
                self.lastDirection = -1
                print("Down")
                self.play()
            }
            }
        }
        
        // Run if the acceleration is higher than ntheshold
        if abs(xAccel) < self.nthreshold {
        
            //If moved left
            dispatch_async(dispatch_get_main_queue()) {
                if self.lastDirection != 1 && xNegative {
                    self.lastDirection = 1
                    print("Up")
                    self.play()
            } else if self.lastDirection !=     -1 && !xNegative {
                self.lastDirection = -1
                print("Down")
                self.play()
            }
            }
        }
        
        // Run if the acceleration is higher than theshold
        if abs(yAccel) > self.threshold {
            
            //If moved up
            dispatch_async(dispatch_get_main_queue()) {
                if self.lastDirection != 1 && yPositive {
                    self.lastDirection = 1
                    print("Up")
                    self.play()
            } else if self.lastDirection !=     -1 && !yPositive {
                self.lastDirection = -1
                print("Down")
                self.play()
            }
            }
        }
            
        // Run if the acceleration is higher than ntheshold
        if abs(yAccel) < self.nthreshold {
            
            //If moved left
            dispatch_async(dispatch_get_main_queue()) {
                if self.lastDirection != 1 && yNegative {
                    self.lastDirection = 1
                    print("Up")
                    self.play()
            } else if self.lastDirection !=     -1 && !yNegative {
                self.lastDirection = -1
                print("Down")
                self.play()
        }
        }
        }
            
        // Run if the acceleration is higher than theshold
        if abs(zAccel) > self.threshold {
            
        //If moved front
        dispatch_async(dispatch_get_main_queue()) {
        if self.lastDirection != 1 && zPositive {
        self.lastDirection = 1
        print("Up")
        self.play()
        } else if self.lastDirection !=     -1 && !zPositive {
        self.lastDirection = -1
        print("Down")
        self.play()
        }
        }
        }
            
        // Run if the acceleration is higher than theshold
        if abs(zAccel) < self.nthreshold {
            
        //If moved back
        dispatch_async(dispatch_get_main_queue()) {
        if self.lastDirection != 1 && zNegative {
        self.lastDirection = 1
        print("Up")
        self.play()
        } else if self.lastDirection !=     -1 && !zNegative {
        self.lastDirection = -1
        print("Down")
        self.play()
        }
        }
        }
        
        })
            
        }
        */
        
    }
    
    @IBAction func buttonTouchEnded(sender: UIButton) {
        //Called when the finger is removed from Button
        self.lightSaber.hidden = false
        //Audio
        ButtonAudioPlayer2.play()   //Play Off.wav
        ButtonAudioPlayer3.stop()   //Stop playing Idle.wav
        
        //Animation
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
    
    //Share
    @IBAction func shareButton(sender: UIButton) {
        //Called when Share is pressed
        //Constants
        let myShare = "Simulate a lightsaber on the iPhone app, Blue Saber! Download at https://appsto.re/us/Wu6iab.i" //Text to share
        let activityVC:UIActivityViewController = UIActivityViewController(activityItems: [myShare], applicationActivities: nil)
        
        self.presentViewController(activityVC, animated: true, completion: nil) //Share view
        
        lightSaber.center.y = self.view.frame.width - 80   //Starting location
        UIView.animateWithDuration(1.0 /*Duration*/, animations: ({self.lightSaber.center.y = self.view.frame.width + 1000    /*Ending location*/}))
        
        self.lightSaber.hidden = true
        
    }
    
}

/*
if (settings.core.rate_app_counter === 10) {
navigator.notification.confirm(
'Love the app? Rate Blue Saber on the App Store.',
function(button) {
// yes = 1, no = 2, later = 3
if (button == '1') {    // Rate Now
if (device_ios) {
window.open('itms-apps://itunes.apple.com/us/app/domainsicle-domain-name-search/id511364723?ls=1&mt=8'); // or itms://
}

this.core.rate_app = false;
} else if (button == '2') { // Later
this.core.rate_app_counter = 0;
} else if (button == '3') { // No
this.core.rate_app = false;
}
}, 'Rate Blue Saber', ['Rate Blue Saber', 'Remind me later', 'No Thanks']);
}
*/

/* Todo list:
- accelerometer
- gyroscope
- admob
- when pressed too much (use Increment() function)
- get correct build number
- create new description for new version
- improve graphics
- create screenshots for new version
- make idle.wav loop or increase length
- add app analytics
- app video


- reload when not working
*/