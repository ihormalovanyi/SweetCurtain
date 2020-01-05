//
//  SweetCurtainHeighsCell.swift
//  SweetCurtainPlayground
//
//  Created by Ihor Malovanyi on 24.12.2019.
//  Copyright © 2019 Ihor Malovanyi. All rights reserved.
//

import UIKit

final class SweetCurtainHeighsCell: UITableViewCell {

    private enum HeightType: Int {
        
        case min, mid, max
        
    }
    
    @IBOutlet private weak var minSlider: UISlider!
    @IBOutlet private weak var midSlider: UISlider!
    @IBOutlet private weak var maxSlider: UISlider!
  
    @IBOutlet private weak var minLabel: UILabel!
    @IBOutlet private weak var midLabel: UILabel!
    @IBOutlet private weak var maxLabel: UILabel!
    
    @IBOutlet private weak var switcher: UISwitch!
    
    var changeHandler: ((CGFloat, CGFloat?, CGFloat) -> ())?
    
    private var isMidActive: Bool = true
    private var heightCoefficients: (min: CGFloat, mid: CGFloat?, max: CGFloat) = (0.2, 0.5, 0.8)
    
    private func change(coefficient: Double, for type: HeightType?) {
        switch type {
        case .min: heightCoefficients.min = CGFloat(coefficient)
        case .mid: heightCoefficients.mid = isMidActive ? CGFloat(coefficient) : nil
        case .max: heightCoefficients.max = CGFloat(coefficient)
        default: break
        }
        
        changeHandler?(heightCoefficients.min, heightCoefficients.mid, heightCoefficients.max)
    }
    
    @IBAction private func changeValue(_ sender: UISlider) {
        let coefficient = round(Double(sender.value * 100)) / 100
        
        [minLabel, midLabel, maxLabel].first(where: { $0.tag == sender.tag })?.text = String(coefficient)

        change(coefficient: coefficient, for: HeightType.init(rawValue: sender.tag))
    }
    
    @IBAction private func toggle(_ sender: UISwitch) {
        isMidActive = sender.isOn
        
        midSlider.alpha = isMidActive ? 1 : 0.5
        midSlider.isUserInteractionEnabled = isMidActive
        midLabel.alpha = isMidActive ? 1 : 0.5
        
        let coefficient = round(Double(midSlider.value * 100)) / 100
        change(coefficient: coefficient, for: .mid)
    }
    
    private func reset(_ sender: Any) {
        switcher.isOn = true
        
        minSlider.value = 0.2
        midSlider.value = 0.5
        maxSlider.value = 0.8
        
        toggle(switcher)
        
        [minSlider, midSlider, maxSlider].forEach { changeValue($0) }
    }
}
