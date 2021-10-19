///  Copyright © 2021 Ihor Malovanyi. All rights reserved.
/// https://www.ihor.pro
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

public struct Detents {
            
    public enum CurrentDetent {
        
        case small, medium, large
        
    }
    
    internal enum CommitDirrection {
        
        case above, below
        
    }
    
    internal var currentHeight: CGFloat { current == .small ? small : current == .medium ? medium : large }
    private(set) var current: CurrentDetent = .small
    
    private(set) var small: CGFloat
    private(set) var medium: CGFloat
    private(set) var large: CGFloat
    
    private var isStaticSize: Bool { small == medium && medium == large }
    
    public init(static height: CGFloat) {
        small = height
        medium = height
        large = height
    }

    public init(small: CGFloat, large: CGFloat) {
        self.small = small
        self.medium = large
        self.large = large
    }
    
    public init(small: CGFloat, medium: CGFloat, large: CGFloat) {
        self.small = small
        self.medium = medium
        self.large = large
    }
    
    internal func permittedHeight(including height: CGFloat, bounces: Bool = false) -> CGFloat {
        guard !isStaticSize else {
            return small
        }
        
        let newHeight = (current == .small ? small : current == .large ? large : medium) + height
        
        let bounceValue: CGFloat = 0//bounces ? height / 2 : 0
        
        return newHeight < small + bounceValue ? small : newHeight > large ? large + bounceValue : newHeight
    }
    
    mutating internal func commit(_ height: CGFloat, dirrection: CommitDirrection? = nil) {
        guard !isStaticSize else { return }
        
        switch dirrection {
        case .above:
            current = height < medium ? medium == large ? .large : .medium : .large
        case .below:
            current = height > medium ? medium == large ? .small : .medium : .small
        default:
            if medium == large {
                current = (small + large) / 2 < height ? .large : .small
            } else {
                current = (((small + medium) / 2)...((medium + large) / 2)).contains(height) ? .medium : height < medium ? .small : .large
            }
        }
    }
    
}
