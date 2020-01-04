//
//  Curtain.swift
//  SweetCurtainRemaster
//
//  Created by Ihor Malovanyi on 01.01.2020.
//  Copyright © 2020 Ihor Malovanyi. All rights reserved.
//

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
    
}
