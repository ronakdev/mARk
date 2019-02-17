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
    var color: String = "white"
    let uicolor : UIColor = UIColor(red: 1, green: 165/255, blue: 0, alpha: 1)
    
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
//        self.color = color;
    }
    
    func clear() {
        self.removeFromParentNode()
    }
    
    func toDictionary(lat: Double, lng: Double) -> [String: Any] {
        var dict: [String: Any] = [:]
        
        dict["color"] = self.color
        dict["hardLocation"] = GeoPoint(latitude: lat, longitude: lng)
        
        dict["relativeLocation"] = ["x": "\(self.sphereNode.position.x)", "y": "\(self.sphereNode.position.y)", "z": "\(self.sphereNode.position.z)"]
        dict["positionVector"] = "\(self.sphereNode.position.x),\(self.sphereNode.position.y),\(self.sphereNode.position.z)"
        
        // do geohasing nonsense here
        
        return dict
    }
    
    func setEditable(_ editable: Bool) {
        
        let changeColorAction = SCNAction.run { (node) in
            let material: SCNMaterial = SCNMaterial()
            
            if !editable {
                material.diffuse.contents = UIColor.red
            } else {
                material.diffuse.contents = self.uicolor
                self.color = self.toHexString(color: self.uicolor)//self.StringFromUIColor(self.color)
            }
            self.sphereGeometry.materials = [material]
            self.sphereNode.geometry = self.sphereGeometry
        }
        let waitAction = SCNAction.wait(duration: 1)
        let revertColorAction = SCNAction.run { (node) in
            let material: SCNMaterial = SCNMaterial()
            
            material.diffuse.contents = self.uicolor
            
            self.sphereGeometry.materials = [material]
            self.sphereNode.geometry = self.sphereGeometry
        }
        self.runAction(SCNAction.sequence([changeColorAction, waitAction, revertColorAction]))
    }
    
    func StringFromUIColor(_ name: String) -> UIColor? {
        let selector = Selector("\(name)Color")
        if UIColor.self.responds(to: selector) {
            let color = UIColor.self.perform(selector).takeUnretainedValue()
            return (color as! UIColor)
        } else {
            return nil
        }
    }
    
    func setUIColor(color : UIColor) {
        sphereGeometry.firstMaterial?.diffuse.contents = color
        self.color = toHexString(color : color)
    }
    
    func toHexString(color : UIColor) -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgba:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0 | (Int)(a*255)
        
        return NSString(format:"#%08x", rgba) as String
    }


}
