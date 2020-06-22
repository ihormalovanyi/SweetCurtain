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

public protocol Curtain {
    
    ///The minimum value that describes the ratio of the curtain minimum permissible height to the height of the content.
    var minHeightCoefficient: CGFloat { get set }
    ///The intermediate value that describes the ratio of the curtain intermediate permissible height to the height of the content.
    var midHeightCoefficient: CGFloat? { get set }
    ///The maximum value that describes the ratio of the curtain maximum permissible height to the height of the content.
    var maxHeightCoefficient: CGFloat { get set }
    ///The swipe resistance of the curtain.
    var swipeResistance: CurtainSwipeResistance { get set }
    ///The time in seconds for reaching curtain to the nearest point.
    var movingDuration: TimeInterval { get set }
    ///The boolean value that controls whether the curtain bounces past the top.
    var topBounce: Bool { get set }
    ///The boolean value that controls whether the curtain bounces past the bottom.
    var bottomBounce: Bool { get set }
    ///The boolean that controls whether the curtain shows top handle indicator.
    var showsHandleIndicator: Bool { get set }
    ///The color of the curtain's handle indicator.
    var handleIndicatorColor: UIColor { get set }
    ///The current value that describes the ratio of the curtain actual height to the height of the content.
    var heightCoefficient: CGFloat { get }
    ///The current value that describes the curtain actual height.
    var actualHeight: CGFloat { get }
    ///The boolean value that allow to control the simultaneous gestures
    var shouldRecognizeSimultaneously: Bool { get set }
    
}

public extension Curtain {
    
    ///The function that returns CGFloat value describes the relationship of actual curtains height and the range between bottom and top state. This relation is CGFloat value in a range between 0 and 1 where 0.
    ///- Parameter bottomState: Describes the start state in the calculation range.
    ///- Parameter topState: Describes the end state in the calculation range.
    func relativeCoefficient(bottom bottomState: CurtainHeightState, top topState: CurtainHeightState) -> CGFloat {
        var bottomCoefficient: CGFloat
        var topCoefficient: CGFloat
        
        switch bottomState {
        case .min: bottomCoefficient = minHeightCoefficient
        case .mid: bottomCoefficient = midHeightCoefficient ?? 0
        case .max: bottomCoefficient = maxHeightCoefficient
        default: bottomCoefficient = 0
        }
        
        switch topState {
        case .min: topCoefficient = minHeightCoefficient
        case .mid: topCoefficient = midHeightCoefficient ?? 0
        case .max: topCoefficient = maxHeightCoefficient
        default: topCoefficient = 0
        }
        
        return round((heightCoefficient - bottomCoefficient) / (topCoefficient - bottomCoefficient) * 1000) / 1000
    }

}
