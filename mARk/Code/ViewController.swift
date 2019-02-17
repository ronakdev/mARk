//
//  ViewController.swift
//  mARk
//
//  Created by Ronak Shah on 2/16/19.
//  Copyright © 2019 Ronak Shah. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import Firebase
import CoreLocation
import ColorSlider

class ViewController: UIViewController, ARSCNViewDelegate, CLLocationManagerDelegate {

    
    // Nathan/Daniel master plan:
        // store a set location for each mark
        // load the mark if user starts the app within the set location radius
        // using distanceFromLocation method to find distance from two points
    
    
//    latitude: 33.6489, longitude: -117.8421
    @IBOutlet var sceneView: ARSCNView!
    var spheres: [Sphere] = []
    var currentLocation: CLLocation! = CLLocation(latitude: 33.6489, longitude: -117.8421  ) // utc not where i am
    var locManager: CLLocationManager!
    let setLat = 33.64774
    let setLong = -117.83562
    @IBOutlet weak var colorSliderView: UIView!
    var colorSlider: ColorSlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorSlider = ColorSlider(orientation: .horizontal, previewSide: .top)
        
        colorSlider.frame = CGRect(x: 25, y: self.sceneView.frame.height - 12, width: self.sceneView.frame.width - 20, height: 12)
        colorSlider.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 20)
        colorSlider.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 20)
        
        sceneView.addSubview(colorSlider)
        
        colorSlider.addTarget(self, action: #selector(changedColor(_:)), for: .valueChanged)
        locManager = CLLocationManager()
        locManager.requestWhenInUseAuthorization()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        // sceneView.showsStatistics = true
        
        // Create a new scene
//        let scene = //SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
//        sceneView.scene = scene
        
        let tapRecog = UITapGestureRecognizer(target: self, action: #selector(self.didTapScreen(_:)))
        self.sceneView.addGestureRecognizer(tapRecog)
        
        // loading in that data
        
        let db = Firestore.firestore()
        
        // THIS IS HARD CODED RIGHT NOW
        let latitude = self.currentLocation.coordinate.latitude
        let longitude = self.currentLocation.coordinate.longitude
        
        let lat = 0.0144927536231884
        let lon = 0.0181818181818182
        let distance = 0.0189394
        
        
        
        let lowerLat = latitude - (lat * distance)
        let lowerLon = longitude - (lon * distance)
        
        let greaterLat = latitude + (lat * distance)
        let greaterLon = longitude + (lon * distance)

        print("latitude: \(latitude)")
        print("longitude: \(longitude)")
        
        let markQuery = db.collection("marks")

        
        markQuery.getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                
                var marksFound = 0
                for document in snapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let nodes = document.data()["mark"] as! [[String: Any]]
                    let markData = document.data()
                    
                    // creates CLLocation for each mark
                    let markLocation: CLLocation! = CLLocation(latitude: markData["lat"] as! Double, longitude: markData["lng"]! as! Double  )
                    
                    // the value 1 can be tested
                    if (self.currentLocation.distance(from: markLocation) < 1){
                        marksFound+=1
                        for data in nodes {
                            self.addSphere(position:
                                SCNVector3(
                                    Float((data["relativeLocation"] as! [String: Any])["x"] as! String)!,
                                    Float((data["relativeLocation"] as! [String: Any])["y"] as! String)!,
                                    Float((data["relativeLocation"] as! [String: Any])["z"] as! String)!
                                )
                            )
                            self.spheres[0].setUIColor(color: self.hexToUIColor(hexString: data["color"] as! String))
                            self.spheres = []
                        }
                    }
                }
                print("\n\n\n\n\n\(marksFound) total marks found\n\n\n\n\n\n\n")
            }
        }
    }
    
    @objc func changedColor(_ slider: ColorSlider) {
        print (slider.color)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    @objc func didTapScreen(_ recog: UITapGestureRecognizer) {
        let location = recog.location(in: self.sceneView)
        
        if (location.y > 600) {
            return
        }
        
        if let cameraNode = self.sceneView.pointOfView {
            
            let distance: Float = 0.3 // Hardcoded depth
            let pos = sceneSpacePosition(inFrontOf: cameraNode, atDistance: distance, x: 0, y: 0)
            
            addSphere(position: pos)
        }
    }
    
    @IBAction func shareNode(_ sender: UIButton) {
        print(CLLocationManager.authorizationStatus() == .authorizedWhenInUse)
        if self.currentLocation != nil {
            var nodes = [[String: Any]]()
            for sphere in self.spheres {
                nodes.append(sphere.toDictionary(lat: self.currentLocation.coordinate.latitude, lng: self.currentLocation.coordinate.longitude))
                sphere.setEditable(false)
            }
            
            let db = Firestore.firestore()
            db.collection("marks").addDocument(data: [
            "mark" : nodes,
            "lat" : self.currentLocation.coordinate.latitude,
            "lng" : self.currentLocation.coordinate.longitude,
            ])
            self.spheres = [] // we forget about these now
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func addSphere(position: SCNVector3) {
        print("adding sphere at point: \(position)")
        let sphere: Sphere = Sphere(position: position)
        sphere.setUIColor(color: colorSlider.color)
        self.sceneView.scene.rootNode.addChildNode(sphere)
        // if we keep an array of these babies, then calling
        // sphere.clear() on each will remove them from the scene
        spheres.append(sphere)
    }
    
    func sceneSpacePosition(inFrontOf node: SCNNode, atDistance distance: Float, x: Float, y: Float) -> SCNVector3 {
        let localPosition = SCNVector3(x: x, y: y, z: -distance)
        let scenePosition = node.convertPosition(localPosition, to: nil)
        // to: nil is automatically scene space
        return scenePosition
    }
    
    
//    func UIColorFromString(string: String) -> UIColor {
//        let componentsString = string.replace("[", withString: "").replace("]", withString: "")
//        let components = componentsString.componentsSeparatedByString(", ")
//        return UIColor(red: CGFloat((components[0] as NSString).floatValue),
//                       green: CGFloat((components[1] as NSString).floatValue),
//                       blue: CGFloat((components[2] as NSString).floatValue),
//                       alpha: CGFloat((components[3] as NSString).floatValue))
//    }

    
    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    // MARK: CoreLocationManagerDelegateMethods
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if (CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways) {
            currentLocation = manager.location
        }
    }
    func hexToUIColor(hexString: String) -> UIColor {
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") {
        let start = hexString.index(hexString.startIndex, offsetBy: 1)
        let hexColor = String(hexString[start...])
        
        if hexColor.count == 8 {
        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0
        
        if scanner.scanHexInt64(&hexNumber) {
        r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
        g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
        b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
        a = CGFloat(hexNumber & 0x000000ff) / 255
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
        
        }
        }
        }
        
        return UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    }
}
