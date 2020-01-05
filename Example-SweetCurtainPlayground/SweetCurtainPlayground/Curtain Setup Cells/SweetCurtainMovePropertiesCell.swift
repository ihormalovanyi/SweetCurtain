//
//  SweetCurtainMovePropertiesCell.swift
//  SweetCurtainPlayground
//
//  Created by Ihor Malovanyi on 24.12.2019.
//  Copyright © 2019 Ihor Malovanyi. All rights reserved.
//

import UIKit

class SweetCurtainMovePropertiesCell: UITableViewCell {

    @IBOutlet private weak var resistanceSlider: UISlider!
    @IBOutlet private weak var durationSlider: UISlider!
    
    @IBOutlet private weak var resistanceLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    
    @IBOutlet private weak var topBounceSwitcher: UISwitch!
    @IBOutlet private weak var bottomBounceSwitcher: UISwitch!
    
    private var changes: (resistance: CGFloat, duration: TimeInterval, topBounce: Bool, bottomBounce: Bool) = (600, 0.4, true, true) {
        didSet {
            changeHandler?(changes.resistance, changes.duration, changes.topBounce, changes.bottomBounce)
        }
    }
    
    var changeHandler: ((CGFloat, TimeInterval, Bool, Bool) -> ())?
    
    @IBAction func swipeResistanceChange(_ sender: UISlider) {
        let value = Int(sender.value)
        resistanceLabel.text = String(value)
        changes.resistance = CGFloat(value)
    }
    
    @IBAction private func durationChange(_ sender: UISlider) {
        let value = round(Double(sender.value * 100)) / 100
        durationLabel.text = String(value)
        changes.duration = value
    }
    
    @IBAction private func topBounce(_ sender: UISwitch) {
        changes.topBounce = sender.isOn
    }
    
    @IBAction private func bottomBounce(_ sender: UISwitch) {
        changes.bottomBounce = sender.isOn
    }
    
}
