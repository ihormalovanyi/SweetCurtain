//
//  CurtainUpdateModel.swift
//  SweetCurtainRemaster
//
//  Created by Ihor Malovanyi on 01.01.2020.
//  Copyright © 2020 Ihor Malovanyi. All rights reserved.
//

import UIKit

internal class CurtainUpdateModel: Curtain {
        
    var minHeightCoefficient: CGFloat = 0.2 {
        willSet { curtainController.curtainHeightProvider.minCoefficient = newValue }
    }
    var midHeightCoefficient: CGFloat? = 0.5 {
        willSet { curtainController.curtainHeightProvider.midCoefficient = newValue }
    }
    var maxHeightCoefficient: CGFloat = 0.8 {
        willSet { curtainController.curtainHeightProvider.maxCoefficient = newValue }
    }
    var swipeResistance: CurtainSwipeResistance = .normal
    var movingDuration: TimeInterval = 0.4
    var topBounce: Bool = true
    var bottomBounce: Bool = true
    var showsHandleIndicator: Bool = true {
        willSet { curtainController.curtainShowsHandleIndicator = newValue }
    }
    
    var heightCoefficient: CGFloat { curtainController.curtainHeightCoefficient }
    var actualHeight: CGFloat { curtainController.curtainActualHeight }
    
    var handleIndicatorColor: UIColor {
        get { return curtainController.curtainHandleIndicatorColor }
        set { curtainController.curtainHandleIndicatorColor = newValue }
    }

    
    private var curtainController: CurtainController
    
    init(in curtainController: CurtainController) {
        self.curtainController = curtainController
    }
    
}
