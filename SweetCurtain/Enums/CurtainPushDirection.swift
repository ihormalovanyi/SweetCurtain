//
//  CurtainPushDirection.swift
//  Pods-SweetCurtainPlayground
//
//  Created by Ihor Malovanyi on 28.12.2019.
//

import UIKit

internal enum CurtainPushDirection {
    
    case up
    case down
    case calm
    
    static func `for`(velocity: CGFloat, treshold: CGFloat) -> CurtainPushDirection {
        (-treshold...treshold).contains(velocity) ? .calm : velocity < -treshold ? .up : .down
    }
    
}
