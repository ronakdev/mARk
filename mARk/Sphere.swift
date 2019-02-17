//
//  Sphere.swift
//  mARk
//
//  Created by Ronak Shah on 2/16/19.
//  Copyright © 2019 Ronak Shah. All rights reserved.
//

import Foundation
import ARKit
import FirebaseFirestore

class Sphere: SCNNode {
    
    static let radius: CGFloat = 0.01
    
    let sphereGeometry: SCNSphere
    let sphereNode: SCNNode!
    var positionString: String
    
    // Required but unused
    required init?(coder aDecoder: NSCoder) {
        sphereGeometry = SCNSphere(radius: Sphere.radius)
        self.positionString = ""
        self.sphereNode = nil
        super.init(coder: aDecoder)
        self.positionString = "\(self.position.x),\(self.position.y),\(self.position.z)"
    }
    
    // The real action happens here
    init(position: SCNVector3) {
        self.sphereGeometry = SCNSphere(radius: Sphere.radius)
        self.positionString = "\(position.x),\(position.y),\(position.z)"
        self.sphereNode = SCNNode(geometry: self.sphereGeometry)

        super.init()
        
        sphereNode.position = position
        
        self.addChildNode(sphereNode)
    }
    
    func clear() {
        self.removeFromParentNode()
    }
    
    func toDictionary(lat: Double, lng: Double) -> [String: Any] {
        var dict: [String: Any] = [:]
        
        dict["color"] = "white"
        dict["hardLocation"] = GeoPoint(latitude: lat, longitude: lng)
        
        dict["relativeLocation"] = ["x": "\(self.sphereNode.position.x)", "y": "\(self.sphereNode.position.y)", "z": "\(self.sphereNode.position.z)"]
        dict["positionVector"] = "\(self.sphereNode.position.x),\(self.sphereNode.position.y),\(self.sphereNode.position.z)"
        return dict
    }
    
    func setEditable(_ editable: Bool) {
        let material: SCNMaterial = SCNMaterial()

        if !editable {
            material.diffuse.contents = UIColor.red
        } else {
            material.diffuse.contents = UIColor.white
        }
        self.sphereGeometry.materials = [material]
        self.sphereNode.geometry = self.sphereGeometry
    }

}
