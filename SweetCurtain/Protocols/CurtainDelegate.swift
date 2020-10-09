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

import Foundation

///The methods declared by the CurtainDelegate protocol allow the adopting delegate to respond to messages from the CurtainController class and thus respond to, and in some affect, operations such as changing height state, dragging, and updating actual curtain height coefficient.
public protocol CurtainDelegate: class {
    
    ///Tells the delegate when the curtain did change ir's height state.
    ///- Parameter curtain: The object that represents curtain properties.
    ///- Parameter heightState: The new height state of the curtain.
    func curtain(_ curtain: Curtain, didChange heightState: CurtainHeightState)
    
    ///Tells the delegate when the curtain is about to start dragging.
    ///- Parameter curtain: The object that represents curtain properties.
    func curtainWillBeginDragging(_ curtain: Curtain)
    
    ///Tells the delegate when dragging will be ended in the curtain.
    ///- Parameter curtain: The object that represents curtain properties.
    func curtainWillEndDragging(_ curtain: Curtain)
    
    ///Tells the delegate when dragging ended in the curtain.
    ///- Parameter curtain: The object that represents curtain properties.
    func curtainDidEndDragging(_ curtain: Curtain)
    
    ///Tells the delegate when the user draggs the curtain.
    ///- Parameter curtain: The object that represents curtain properties.
    func curtainDidDrag(_ curtain: Curtain)
    
}

public extension CurtainDelegate {
    
    func curtain(_ curtain: Curtain, didChange heightState: CurtainHeightState) {}
    func curtainWillBeginDragging(_ curtain: Curtain) {}
    func curtainWillEndDragging(_ curtain: Curtain) {}
    func curtainDidEndDragging(_ curtain: Curtain) {}
    func curtainDidDrag(_ curtain: Curtain) {}
    
}
