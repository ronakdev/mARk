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

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var spheres: [Sphere] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
        
        let tapRecog = UITapGestureRecognizer(target: self, action: #selector(self.didTapScreen(_:)))
        self.sceneView.addGestureRecognizer(tapRecog)
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
        print("X: \(location.x), Y: \(location.y)")
        
        if let cameraNode = self.sceneView.pointOfView {
            
            let distance: Float = 0.3 // Hardcoded depth
            let pos = sceneSpacePosition(inFrontOf: cameraNode, atDistance: distance, x: 0, y: 0)
            
            addSphere(position: pos)
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
}
