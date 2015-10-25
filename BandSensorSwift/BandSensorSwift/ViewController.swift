//
//  ViewController.swift
//  BandSensorSwift
//
//  Created by Cooper on 10/10/15.


import UIKit


class ViewController: UIViewController, MSBClientManagerDelegate {

    @IBOutlet weak var txtOutput: UITextView!
    @IBOutlet weak var accelLabel: UILabel!
    weak var client: MSBClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        MSBClientManager.sharedManager().delegate = self
        if let client = MSBClientManager.sharedManager().attachedClients().first as? MSBClient {
            self.client = client
            MSBClientManager.sharedManager().connectClient(self.client)
            self.output("Please wait. Connecting to Band...")
        } else {
            self.output("Failed! No Bands attached.")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func runExampleCode(sender: AnyObject) {
        if let client = self.client {
            if client.isDeviceConnected == false {
                self.output("Band is not connected. Please wait....")
                return
            }
            
            
               try! client.sensorManager.startHearRateUpdatesToQueue(NSOperationQueue(), withHandler: { (hrmData: MSBSensorHeartRateData!, error: NSError!) in
                    if error != nil {
                        print("Error retrieving Heart Rate: \(error.description)")
                    }
                    print("heart rate is: ")
                    print(hrmData.heartRate)
            
            
//                switch (hrmData.quality) {
//                case MSBSensorHeartRateQuality.Acquiring:
//                    quality = "Acquiring"
//                case MSBSensorHeartRateQuality.Locked:
//                    quality = "Locked"
//                default:
//                    quality = "Unknown"
//                }
//                self.hrmQualityLabel.text = quality
//                self.bpmLabel.text = NSString(format: "%d", hrmData.heartRate) as String
            })
            
//            do {
//                try client.sensorManager.startAccelerometerUpdatesToQueue(NSOperationQueue(),  withHandler: { (accelerometerData: MSBSensorAccelData!, error: NSError!) in
//                    self.accelLabel.text = NSString(format: "Accel Data: X=%+0.2f Y=%+0.2f Z=%+0.2f", accelerometerData.x, accelerometerData.y, accelerometerData.z) as String
//                })
//            } catch {
//                print ("aaaaaaaa")
//                print(error)
//            }
            
    
            //Stop Accel updates after 60 seconds
//            let delay = 60.0 * Double(NSEC_PER_SEC)
//            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
//            dispatch_after(time, dispatch_get_main_queue(), {
//                self.output("Stopping Accelerometer updates...")
//                if let client = self.client {
//                    do {
//                        try client.sensorManager.stopAccelerometerUpdatesErrorRef()
//                    } catch {
//                        print ("bbbbbbb")
//                        print(error)
//                    }
//
//                }
//            })
        } else {
            self.output("Band is not connected. Please wait....")
        }
    }
    
    func output(message: String) {
        print ("Doctor Heart start!")
        self.txtOutput.text = NSString(format: "%@\n%@", self.txtOutput.text, message) as String
        let p = self.txtOutput.contentOffset
        self.txtOutput.setContentOffset(p, animated: false)
        self.txtOutput.scrollRangeToVisible(NSMakeRange(self.txtOutput.text.lengthOfBytesUsingEncoding(NSASCIIStringEncoding), 0))
    }
    
    // Mark - Client Manager Delegates
    func clientManager(clientManager: MSBClientManager!, clientDidConnect client: MSBClient!) {
        self.output("Band connected.")
    }
    
    func clientManager(clientManager: MSBClientManager!, clientDidDisconnect client: MSBClient!) {
        self.output(")Band disconnected.")
    }
    
    func clientManager(clientManager: MSBClientManager!, client: MSBClient!, didFailToConnectWithError error: NSError!) {
        self.output("Failed to connect to Band.")
        self.output(error.description)
    }
}

