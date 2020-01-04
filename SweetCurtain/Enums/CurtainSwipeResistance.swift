//
//  CurtainSwipeResistance.swift
//  SweetCurtain
//
//  Created by Ihor Malovanyi on 28.12.2019.
//

import UIKit

///Swipe resistances available for the curtain.
public enum CurtainSwipeResistance {
    
    ///No resistance. Velocity value is 0.
    case any
    ///Low resistance. Velocity value is 300.
    case low
    ///Normal resistance. Velocity value is 600.
    case normal
    ///High resistance. Velocity value is 900.
    case high
    ///Custom resistance. Velocity value is what you set.
    case custom(velocity: CGFloat)
    
    internal var velocity: CGFloat {
        switch self {
        case .any: return 0
        case .low: return 300
        case .normal: return 600
        case .high: return 900
        case .custom(let velocity): return velocity
        }
    }
    
}
