///  Copyright © 2019 Ihor Malovanyi. All rights reserved.
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in all
/// copies or substantial portions of the Software.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.

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

