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

open class CurtainController<T: UIViewController>: NSObject, UIGestureRecognizerDelegate {
    
    enum Change: Int {
        
        case willBeginDragging
        case willEndDragging
        case didEndDragging
        case didChangeHeight
        case didChangeDetent
        
    }
    
    private let minVelocity: CGFloat = 500
    private let maxVelocity: CGFloat = 2500
    
    //Delegate
    var changeListener: ((CurtainController<T>, Change) -> ())?
    
    //Constraints & Heights
    private lazy var heightConstraint: NSLayoutConstraint = {
        let constraint = view.heightAnchor.constraint(equalToConstant: 0)
        constraint.priority = .init(rawValue: 900)
        return constraint
    }()
    private var height: CGFloat {
        get {
            heightConstraint.constant
        }
        set {
            heightConstraint.constant = newValue
        }
    }

    //Live properties
    private var startScrollViewYOffset: CGFloat = 0
    private var touchWithScroll = false
    
    open var bounces = false
    
    //Views & Controllers
    private unowned var curtainViewController: T!
    private var view = UIView()
    private var scrollView: UIScrollView? { curtainViewController?.topMostScrollView() }
    
    //Additions
    private var _detents = Detents(static: UIScreen.main.bounds.height / 2)
    
    internal init(_ curtainVC: T, holder: UIViewController) {
        super.init()
        
        curtainVC.willMove(toParent: holder)
        holder.addChild(curtainVC)
        view.addSubview(curtainVC.view)
        holder.view.addSubview(view)
        curtainVC.didMove(toParent: holder)
        
        curtainViewController = curtainVC
        
        view.clipsToBounds = true
        
        setupConstraints()
        setupPanGesture()
        setupScroll()
    }
    
    private func setupConstraints() {
        guard let content = curtainViewController.parent?.view,
              let curtainContentView = curtainViewController.view else { return }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        curtainContentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 0),
            view.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: 0),
            view.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: 0),
            heightConstraint,
            
            curtainContentView.widthAnchor.constraint(equalTo: view.widthAnchor),
            curtainContentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            curtainContentView.topAnchor.constraint(equalTo: view.topAnchor),
            curtainContentView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panCurtain(_:)))
        panGesture.maximumNumberOfTouches = 1
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
    }
    
    private func setupScroll() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0001) {
            self.scrollView?.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentOffset), options: [.new], context: nil)
        }
    }
    
    @objc private func panCurtain(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed:
            height = detents.permittedHeight(including: -gesture.translation(in: view).y, bounces: touchWithScroll ? false : bounces)//, allowBounces: touchWithScroll ? false : bounces)
            changeListener?(self, .didChangeHeight)
        case .ended, .cancelled, .failed:
            changeListener?(self, .willEndDragging)
            let velocity = gesture.velocity(in: view).y
            detents.commit(height, dirrection: abs(velocity) < minVelocity ? nil : velocity < 0 ? .above : .below)
            changeListener?(self, .didChangeDetent)
            animate(with: abs(velocity))
            changeListener?(self, .didEndDragging)
        default: break
        }
    }

    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard touchWithScroll else { return }
        guard let scrollView = scrollView else { return }
        
        switch keyPath {
        case #keyPath(UIScrollView.contentOffset):
            if startScrollViewYOffset == 0 && height != detents.large {
                scrollView.setContentOffset(.init(x: scrollView.contentOffset.x, y: 0), animated: false)
            }
        default: break
        }
    }
    
    private func animate(with velocity: CGFloat = 0) {
        let velocity = velocity < minVelocity ? 0 : velocity > maxVelocity ? 1 : velocity / maxVelocity
        
        height = detents.currentHeight

        if velocity == 0 {
            UIView.animate(withDuration: 0.2, delay: 0, options: [.allowUserInteraction, .curveEaseOut]) {
                self.view.superview?.layoutIfNeeded()
            } completion: { _ in
                self.touchWithScroll = false
            }
        } else {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6 + 0.4 - 0.4 * velocity, initialSpringVelocity: 0.3 * velocity, options: [.allowUserInteraction, .curveEaseInOut]) {
                self.view.superview?.layoutIfNeeded()
            } completion: { _ in
                self.touchWithScroll = false
            }
        }
    }
    
    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        touchWithScroll = false
        
        guard let scrollStartOffsetY = scrollView?.contentOffset.y else { return false }
        
        startScrollViewYOffset = scrollStartOffsetY < 0 ? 0 : scrollStartOffsetY
        
        if otherGestureRecognizer.view == scrollView && otherGestureRecognizer is UIPanGestureRecognizer {
            touchWithScroll = true
            if startScrollViewYOffset > 0 {
                return false
            } else {
                return true
            }
        } else {
            return false
        }
    }
    
    open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        changeListener?(self, .willBeginDragging)
        //Beta
        return touchWithScroll ? abs(scrollView?.panGestureRecognizer.translation(in: scrollView).x ?? 0) < abs(scrollView?.panGestureRecognizer.translation(in: scrollView).y ?? 0) : true
    }
    
}

//API
public extension CurtainController {
    
    var detents: Detents {
        get { _detents }
        set {
            _detents = newValue
            height = _detents.small
        }
    }
    
    var viewController: T { curtainViewController }
    
    var preferredCornerRadius: CGFloat {
        get { view.layer.cornerRadius }
        set { view.layer.cornerRadius = newValue }
    }
    
}
