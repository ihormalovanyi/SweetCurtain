//
//  UIViewController+CurtainController.swift
//  SweetCurtainRemaster
//
//  Created by Ihor Malovanyi on 01.01.2020.
//  Copyright © 2020 Ihor Malovanyi. All rights reserved.
//

import UIKit

public extension UIViewController {
    
    ///The nearest ancestor in the view controller hierarchy that is a curtain controller.
    var curtainController: CurtainController? { findCurtainParent(in: self) }
    
}

internal extension UIViewController {
    
    func findCurtainParent(in controller: UIViewController) -> CurtainController? {
        guard let parent = controller.parent else { return nil }
        
        if let curtainController = parent as? CurtainController {
            return curtainController
        } else {
            return findCurtainParent(in: parent)
        }
    }
    
}
