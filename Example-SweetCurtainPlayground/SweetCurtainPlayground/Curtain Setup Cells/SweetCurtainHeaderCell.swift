//
//  SweetCurtainHeaderCell.swift
//  SweetCurtainPlayground
//
//  Created by Ihor Malovanyi on 24.12.2019.
//  Copyright © 2019 Ihor Malovanyi. All rights reserved.
//

import UIKit

final class SweetCurtainHeaderCell: UITableViewCell {

    enum DelegateIndicator: Int {
        case didChangeState, willBeginDragging, didEndDragging, didDrag
    }
    
    @IBOutlet private weak var hideButton: UIButton!
    @IBOutlet private var labels: [UILabel]!
    
    private var isCurtainHidden = false
    
    var hideHandler: ((Bool) -> ())?
    
    @IBAction private func hide(_ sender: Any) {
        isCurtainHidden.toggle()
        hideHandler?(isCurtainHidden)
        hideButton.setTitle(isCurtainHidden ? "Show" : "Hide", for: .normal)
    }
    
    func performDelegateIndicator(_ indicator: DelegateIndicator) {
        guard let label = labels.first(where: { $0.tag == indicator.rawValue }) else { return }
        
        UIView.animate(withDuration: 0.1) {
            label.alpha = 1
        }
        Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) { (timer) in
            UIView.animate(withDuration: 0.7, animations: {
                label.alpha = 0.5
            }) { isSuccess in
                if isSuccess {
                    timer.invalidate()
                }
            }
        }
    }

    
}
