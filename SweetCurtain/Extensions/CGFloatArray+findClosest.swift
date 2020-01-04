//
//  CGFloat+findNearestNumber.swift
//  SweetCurtainRemaster
//
//  Created by Ihor Malovanyi on 30.12.2019.
//  Copyright © 2019 Ihor Malovanyi. All rights reserved.
//

import UIKit

internal extension Array where Element == CGFloat {
    
    func findClosest(to target: CGFloat) -> CGFloat? {
        let closest = enumerated().min(by: { abs($0.1 - target) < abs($1.1 - target) })
        
        return closest?.element
    }
    
}

