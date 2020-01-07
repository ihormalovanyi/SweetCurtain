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

public extension UIViewController {
    
    ///The nearest ancestor in the view controller hierarchy that is a curtain controller.
    var curtainController: CurtainController? { findCurtainParent(in: self) }
    
    ///Allows topmost scroll view in the hierarchy to use its scroll simultaneously with the curtain
    func allowScrollViewInCurtain() {
        curtainController?.allowScrollViewInCurtain(from: self)
    }
    
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
