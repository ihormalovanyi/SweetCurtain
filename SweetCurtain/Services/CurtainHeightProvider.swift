//
//  CurtainHeightDimensions.swift
//  CurtainTEST
//
//  Created by Ihor Malovanyi on 16.12.2019.
//  Copyright © 2019 Ihor Malovanyi. All rights reserved.
//

import UIKit

internal class CurtainHeightProvider {
    
    var minCoefficient: CGFloat = 0.2
    var maxCoefficient: CGFloat = 0.8
    var midCoefficient: CGFloat? = 0.5
    
    var isMidAvailable: Bool { midCoefficient != nil }
    
    func height(_ heightType: CurtainHeightState, relative view: UIView?, ignoreSafeArea: Bool) -> CGFloat? {
        var viewHeight: CGFloat!
        
        if #available(iOS 11.0, *) {
            viewHeight = ignoreSafeArea ? view?.safeAreaLayoutGuide.layoutFrame.height : view?.bounds.height
            if viewHeight != nil {
                viewHeight += view?.safeAreaInsets.bottom ?? 0
            }
        } else {
            viewHeight = view?.bounds.height
        }
        
        guard viewHeight != nil else { return nil }
        
        switch heightType {
        case .min: return viewHeight * minCoefficient
        case .max: return viewHeight * maxCoefficient
        case .mid:
            if let midCoefficient = midCoefficient {
                return viewHeight * midCoefficient
            }
            return nil
        case .hide: return 0
        }
    }
    
    func closestHeightState(to coefficient: CGFloat) -> CurtainHeightState {
        let closestCoefficient = [Any?]([minCoefficient, midCoefficient, maxCoefficient]).compactMap { $0 as? CGFloat }.findClosest(to: coefficient)
        
        switch closestCoefficient {
        case minCoefficient: return .min
        case maxCoefficient: return .max
        case midCoefficient: return .mid
        default: return .min
        }
    }
    
    func heightState(after heightState: CurtainHeightState, toSmaller: Bool) -> CurtainHeightState {
        switch heightState {
        case .min: return toSmaller ? .min : isMidAvailable ? .mid : .max
        case .mid: return toSmaller ? .min : .max
        case .max: return toSmaller ? isMidAvailable ? .mid : .min : .max
        case .hide: return .hide
        }
    }
    
}

