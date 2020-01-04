//
//  UIView+findScrollSubview.swift
//  SweetCurtainRemaster
//
//  Created by Ihor Malovanyi on 30.12.2019.
//  Copyright © 2019 Ihor Malovanyi. All rights reserved.
//

import UIKit

internal extension UIView {
    
    func findScrollSubview() -> UIScrollView? {
        if let scrollView = self as? UIScrollView {
            return scrollView
        } else {
            for newView in subviews {
                return newView.findScrollSubview()
            }
            
            return nil
        }
    }
    
}
