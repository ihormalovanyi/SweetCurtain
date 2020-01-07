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

///A container view controller that implements a content-curtain interface.
open class CurtainController: UIViewController {
    
    //MARK: Constants
    internal struct Constants {
        
        static let heightConstraintID = "heightID"
        static let rubberHeight: CGFloat = 100
        static let rubberWeakening: CGFloat = 2
        static let curtainHandleViewSize: CGSize = .init(width: 36, height: 5)
        static let curtainHandleYCenter: CGFloat = 7.5
        static let curtainHandleSafeAreaTop: CGFloat = 15
        
    }
    
    //MARK: Interface public properties
    ///The delegate you want to receive curtain controller messages that concern its curtain.
    open weak var curtainDelegate: CurtainDelegate?
    ///The object that provides all curtain's behaviour properties.
    open var curtain: Curtain!
    
    //MARK: Internal properties
    internal var ignoreSafeArea: Bool = true
    internal var curtainHeightProvider = CurtainHeightProvider()
    internal var curtainHandleIndicatorColor: UIColor = UIColor.lightGray.withAlphaComponent(0.8) {
        didSet {
            curtainHandleView?.backgroundColor = curtainHandleIndicatorColor
        }
    }
    internal var curtainActualHeight: CGFloat {
        get {
            return curtainViewController.view.constraints.first(where: { $0.identifier == Constants.heightConstraintID })?.constant ?? 0 }
        set {
            curtainViewController.view.constraints.first(where: { $0.identifier == Constants.heightConstraintID })?.constant = newValue
            if !firstLayout {
                curtainDelegate?.curtainDidDrag(curtain)
            }
        }
    }
    internal var curtainHeightCoefficient: CGFloat {
        var sceneHeight: CGFloat = contentViewControlelr.view.bounds.height
        if ignoreSafeArea {
            if #available(iOS 11.0, *) {
                sceneHeight -= contentViewControlelr.view.safeAreaInsets.top
            }
        }
        
        return curtainActualHeight / sceneHeight
    }
    
    internal var curtainShowsHandleIndicator: Bool = true {
        didSet {
            curtainHandleView.alpha = curtainShowsHandleIndicator ? 1 : 0
            if #available(iOS 11.0, *) {
                curtainViewController.additionalSafeAreaInsets.top = curtainShowsHandleIndicator ? Constants.curtainHandleSafeAreaTop : 0
            } else {
                print("The curtain controller did show the handle indicator, but could not create extra space on top because it's only available from iOS 11")
            }
        }
    }
    
    //MARK: Private properties
    private var firstLayout = true
    
    private var scrollLastOffset: CGPoint = .zero
    private var scrollStartLocation: CGPoint = .zero
    private var scrollFreezeContentOffset = false
    
    private var curtainHandleView: UIView!
    private var curtainActualHeightState: CurtainHeightState = .hide {
        didSet {
            guard curtainActualHeightState != oldValue else { return }
            curtainDelegate?.curtain(curtain, didChange: curtainActualHeightState)
        }
    }
    
    //MARK: Private computed properties
    private var contentViewControlelr: UIViewController { children[0] }
    private var curtainViewController: UIViewController { children[1] }
    private var topMostScrollView: UIScrollView?
    
    //MARK: Lifecycle
    ///Initializes and returns a newly created curtain controller.
    ///- Parameter content: The view controller that takes up all the space behind the curtain.
    ///- Parameter curtain: The view controller that sits on top of the content .
    public init(content: UIViewController, curtain: UIViewController) {
        super.init(nibName: nil, bundle: nil)
        
        addContent(content)
        addCurtain(curtain)
        
        setupFlow()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        if storyboard != nil {
            setupFlow()
        }
    }
    
    private func setupFlow() {
        curtain = CurtainUpdateModel(in: self)
        
        performSeguesIfNeeded()
        addCurtainPanGestureRecognizer()
        addCurtainHandleView()
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard firstLayout else { return }
        
        curtainHandleView.center = .init(x: view.center.x, y: Constants.curtainHandleYCenter)
        
        performState(.min, animated: false)
        firstLayout = false
    }
    
    ///Changes a curtain position you want.
    ///- Parameter position: The position of the curtain to be applied.
    ///- Parameter animated: Pass true to animate the position change.
    open func moveCurtain(to position: CurtainHeightState, animated: Bool) {
        performState(position, animated: animated)
    }
    
    private func addCurtainHandleView() {
        curtainHandleView = .init(frame: .init(origin: .zero, size: Constants.curtainHandleViewSize))
        curtainHandleView.backgroundColor = curtainHandleIndicatorColor
        curtainHandleView.layer.cornerRadius = curtainHandleView.frame.height / 2
        curtainHandleView.alpha = 0
        curtainViewController.view.addSubview(curtainHandleView)
        
        curtainShowsHandleIndicator = curtain.showsHandleIndicator
    }
    
    internal func allowScrollViewInCurtain(from viewController: UIViewController) {
        topMostScrollView = viewController.view.findScrollSubview()
        addObservers()
        addScrollPanGestureRecognizer()
    }
    
}

//MARK: Permited height
private extension CurtainController {
    
    private func height(for heightType: CurtainHeightState) -> CGFloat {
        curtainHeightProvider.height(heightType, relative: contentViewControlelr.view, ignoreSafeArea: ignoreSafeArea) ?? 0
    }
    
    private func permittedHeight(for translation: CGFloat, bounce: Bool = true) -> CGFloat {
        var permittedHeight = curtainActualHeight - translation
        
        if permittedHeight < height(for: .min) {
            if curtain.bottomBounce && bounce {
                let rubberTranslation = translation * (1 - (height(for: .min) - permittedHeight) / Constants.rubberHeight) / Constants.rubberWeakening
                permittedHeight = curtainActualHeight - rubberTranslation
            } else {
                permittedHeight = height(for: .min)
            }
        }
        
        if permittedHeight > height(for: .max) {
            if curtain.topBounce && bounce {
                let rubberTranslation = translation * (1 - (permittedHeight - height(for: .max)) / Constants.rubberHeight) / Constants.rubberWeakening
                permittedHeight = curtainActualHeight - rubberTranslation
            } else {
                permittedHeight = height(for: .max)
            }
        }
        
        return permittedHeight
    }
    
}

//MARK: Gesture handling
private extension CurtainController {
    
    func addCurtainPanGestureRecognizer() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
        curtainViewController.view.addGestureRecognizer(panGestureRecognizer)
        panGestureRecognizer.delegate = self
    }
    
    func addScrollPanGestureRecognizer() {
        topMostScrollView?.panGestureRecognizer.removeTarget(self, action: #selector(scroll(_:)))
        topMostScrollView?.panGestureRecognizer.addTarget(self, action: #selector(scroll(_:)))
    }
    
    @objc func pan(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .ended, .cancelled:
            curtainDelegate?.curtainDidEndDragging(curtain)
            tryPush(.for(velocity: gesture.velocity(in: view).y, treshold: curtain.swipeResistance.velocity)) { [weak self] in
                self?.bringToNearestPoint()
            }
        case .changed:
            let yTranslation = gesture.translation(in: view).y
            curtainActualHeight = permittedHeight(for: yTranslation, bounce: true)
            gesture.setTranslation(.zero, in: view)
        case .began:
            curtainDelegate?.curtainWillBeginDragging(curtain)
        default: break
        }
    }
    
    @objc func scroll(_ gesture: UIPanGestureRecognizer) {
        guard let scrollView = topMostScrollView else { return }
        
        let yVelocity = gesture.velocity(in: view).y
        
        if scrollView.contentOffset.y > 0 && yVelocity >= 0 {
            scrollLastOffset = scrollView.contentOffset
            scrollStartLocation = gesture.translation(in: scrollView)
            
            return
        }
        
        switch gesture.state {
        case .began:
            curtainDelegate?.curtainWillBeginDragging(curtain)
            scrollFreezeContentOffset = false
            scrollLastOffset = scrollView.contentOffset
            scrollStartLocation = gesture.translation(in: scrollView)
        case .changed:
            let yTranslation = gesture.translation(in: scrollView).y
            let deltaYTranslation = yTranslation - scrollStartLocation.y
            
            curtainActualHeight = permittedHeight(for: deltaYTranslation, bounce: false)
            
            if curtainActualHeight < height(for: .max) && yVelocity < 0 {
                scrollFreezeContentOffset = true
                scrollView.setContentOffset(scrollLastOffset, animated: false)
            } else {
                scrollLastOffset = scrollView.contentOffset
            }
            
            scrollStartLocation = gesture.translation(in: scrollView)
        case .ended:
            tryPush(.for(velocity: gesture.velocity(in: view).y, treshold: curtain.swipeResistance.velocity)) { [weak self] in
                self?.bringToNearestPoint()
            }
            curtainDelegate?.curtainDidEndDragging(curtain)
        default:
            tryPush(.for(velocity: gesture.velocity(in: view).y, treshold: curtain.swipeResistance.velocity)) { [weak self] in
                self?.bringToNearestPoint()
            }
        }
    }
    
}

//MARK: Moving
private extension CurtainController {
    
    func tryPush(_ direction: CurtainPushDirection, otherwise pushFailHandler: @escaping () -> ()) {
        switch direction {
        case .up:
            performState(curtainHeightProvider.heightState(after: curtainActualHeightState, toSmaller: false))
        case .down:
            performState(curtainHeightProvider.heightState(after: curtainActualHeightState, toSmaller: true))
        case .calm: pushFailHandler()
        }
    }
    
    func bringToNearestPoint() {
        let closestHeightState = curtainHeightProvider.closestHeightState(to: curtainHeightCoefficient)
        performState(closestHeightState)
    }
    
    func performState(_ heightState: CurtainHeightState, animated: Bool = true) {
        curtainActualHeight = height(for: heightState)
        curtainActualHeightState = heightState
        
        let isHide = curtainActualHeight == 0
        
        if scrollFreezeContentOffset && topMostScrollView?.panGestureRecognizer.state == .ended && curtainActualHeightState != .max {
            topMostScrollView?.setContentOffset(scrollLastOffset, animated: false)
        }
        
        guard animated else {
            curtainViewController.view.transform = isHide ? CGAffineTransform(translationX: 0, y: curtainViewController.view.bounds.height) : .identity
            
            return
        }
        
        UIView.animate(withDuration: curtain.movingDuration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 3, options: [.allowUserInteraction], animations: {
            self.view.layoutIfNeeded()
            self.curtainViewController.view.transform = isHide ? CGAffineTransform(translationX: 0, y: self.curtainViewController.view.bounds.height) : .identity
        }, completion: nil)
    }
    
}

//MARK: Observers
extension CurtainController {
    
    internal func addObservers() {
        topMostScrollView?.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentOffset), options: [.new, .old], context: nil)
        topMostScrollView?.addObserver(self, forKeyPath: #keyPath(UIScrollView.panGestureRecognizer.state), options: [.new, .old], context: nil)
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let scrollView = topMostScrollView else { return }
        
        if keyPath == #keyPath(UIScrollView.contentOffset) {
            if scrollView.contentOffset.y < 0 {
                scrollView.setContentOffset(.zero, animated: false)
            }
        } else if keyPath == #keyPath(UIScrollView.panGestureRecognizer.state) {
            if scrollView.panGestureRecognizer.state == .ended || scrollView.panGestureRecognizer.state == .cancelled {
                bringToNearestPoint()
            }
        }
    }
    
}
