//
//  CurtainController+AddControllers.swift
//  SweetCurtainRemaster
//
//  Created by Ihor Malovanyi on 30.12.2019.
//  Copyright © 2019 Ihor Malovanyi. All rights reserved.
//

import UIKit

internal extension CurtainController {
    
    func performSeguesIfNeeded() {
        guard storyboard != nil else { return }
        
        performSegue(withIdentifier: CurtainConnectionSegue.Constants.contentSegueID, sender: nil)
        performSegue(withIdentifier: CurtainConnectionSegue.Constants.curtainSegueID, sender: nil)
    }
    
    func addContent(_ viewController: UIViewController) {
        addChild(viewController)
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
    
    func addCurtain(_ viewController: UIViewController) {
        addChild(viewController)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewController.view)
        
        let heightConstraint = viewController.view.heightAnchor.constraint(equalToConstant: 200)
        heightConstraint.identifier = CurtainController.Constants.heightConstraintID
        heightConstraint.priority = .defaultLow

        NSLayoutConstraint.activate([
            viewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            viewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            viewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            heightConstraint
        ])
        
        didMove(toParent: self)
    }
    
}
