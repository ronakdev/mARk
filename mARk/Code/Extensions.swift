//
//  Extensions.swift
//  mARk
//
//  Created by Ronak Shah on 2/16/19.
//  Copyright © 2019 Ronak Shah. All rights reserved.
//

import Foundation

precedencegroup ExponentiationPrecedence {
    associativity: right
    higherThan: MultiplicationPrecedence
}

infix operator ** : ExponentiationPrecedence

func ** (_ base: Double, _ exp: Double) -> Double {
    return pow(base, exp)
}

func ** (_ base: Float, _ exp: Float) -> Float {
    return pow(base, exp)
}

extension String {
    func toFloat() -> Float? {
        return Float(self)
    }
}
