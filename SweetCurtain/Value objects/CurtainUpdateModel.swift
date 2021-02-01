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

internal class CurtainUpdateModel: Curtain {
        
    var minHeightCoefficient: CGFloat = 0.2 {
        willSet { curtainController?.curtainHeightProvider.minCoefficient = newValue }
    }
    var midHeightCoefficient: CGFloat? = 0.5 {
        willSet { curtainController?.curtainHeightProvider.midCoefficient = newValue }
    }
    var maxHeightCoefficient: CGFloat = 0.8 {
        willSet { curtainController?.curtainHeightProvider.maxCoefficient = newValue }
    }
    var swipeResistance: CurtainSwipeResistance = .normal
    var movingDuration: TimeInterval = 0.4
    var topBounce: Bool = true
    var bottomBounce: Bool = true
    var showsHandleIndicator: Bool = true {
        willSet { curtainController?.curtainShowsHandleIndicator = newValue }
    }
    
    var heightCoefficient: CGFloat { curtainController?.curtainHeightCoefficient ?? 0 }
    var actualHeight: CGFloat { curtainController?.curtainActualHeight ?? 0 }
    
    var handleIndicatorColor: UIColor {
        get { return curtainController?.curtainHandleIndicatorColor ?? .clear }
        set { curtainController?.curtainHandleIndicatorColor = newValue }
    }

    //The leak was fixed thanks to Roman Scherbakov
    //0.2.2 -> 0.2.5: make 'curtainController' weak
    private weak var curtainController: CurtainController?
    
    init(in curtainController: CurtainController) {
        self.curtainController = curtainController
    }
    
}
