//
//  PermissionsViewController.swift
//  mARk
//
//  Created by Ronak Shah on 2/17/19.
//  Copyright © 2019 Ronak Shah. All rights reserved.
//

import UIKit
import AVKit
import CoreLocation

class PermissionsViewController: UIViewController {
    var manager: CLLocationManager!
    @IBOutlet weak var permissionStatusLabel: UILabel!
    
    @IBOutlet weak var infoTextView: UITextView!
    var camera: Bool = false
    var location: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func enableCamera(_ sender: UIButton) {
        //Camera
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                //access granted
                sender.setTitle("allow camera ✅", for: .normal)
                self.camera = true
            } else {
                sender.setTitle("allow camera ❌", for: .normal)
                self.camera = false
            }
        }
        updateStatusLabel()
    }
    
    @IBAction func enableLocation(_ sender: UIButton) {
        manager = CLLocationManager()
        manager.requestWhenInUseAuthorization()
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways {
            sender.setTitle("allow location ✅", for: .normal)
            location = true
        } else {
            sender.setTitle("allow location ❌", for: .normal)
            location = false
        }
        updateStatusLabel()
    }
    
    func updateStatusLabel() {
        if camera && location {
            self.permissionStatusLabel.text = "✅ All Permissions Enabled!"
        } else if camera {
            self.permissionStatusLabel.text = "📷 is there, we need location"
        } else if location {
            self.permissionStatusLabel.text = "We got location, waiting on 📷"
        } else {
            self.permissionStatusLabel.text = "waiting on permissions"
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
