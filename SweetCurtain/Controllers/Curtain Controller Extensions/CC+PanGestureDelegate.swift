//
//  CC+PanGestureDelegate.swift
//  Pods-SweetCurtainPlayground
//
//  Created by Ihor Malovanyi on 03.01.2020.
//

import UIKit

extension CurtainController: UIGestureRecognizerDelegate {
    
    ///- TODO: Need to test this solution. It need for allow horizontal scroll
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let _ = otherGestureRecognizer as? UIPanGestureRecognizer,
            let current = gestureRecognizer as? UIPanGestureRecognizer else {
                return false
        }
        
        let velocity = current.velocity(in: view)
        
        return abs(velocity.x) >= abs(velocity.y)
    }
    
}
